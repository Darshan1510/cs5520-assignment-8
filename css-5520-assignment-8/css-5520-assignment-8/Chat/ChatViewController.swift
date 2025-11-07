import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    var createChatScreenView = ChatView()
    var messages = [Message]()
    var chatSessionId: String = ""
    let db = Firestore.firestore()
    var userId: String?
    var userName: String?

    override func loadView() {
        view = createChatScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
        userId = Auth.auth().currentUser?.email
        userName = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        createChatScreenView.tableView.delegate = self
        createChatScreenView.tableView.dataSource = self
        createChatScreenView.tableView.allowsSelection = false
        createChatScreenView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        // Add logout button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutTapped))

        startListeningMessages()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func startListeningMessages() {
        db.collection("chatSessions").document(chatSessionId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error { print("Failed to listen for messages: \(error)"); return }
                self.messages.removeAll()
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let message = Message(dictionary: doc.data())
                        self.messages.append(message)
                    }
                }
                DispatchQueue.main.async {
                    self.createChatScreenView.tableView.reloadData()
                    if self.messages.count > 0 {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.createChatScreenView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomInset = view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.3) {
                self.createChatScreenView.messageInputBottomConstraint.constant = -(keyboardHeight - bottomInset) - 10
                self.view.layoutIfNeeded()
            }
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.createChatScreenView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.createChatScreenView.messageInputBottomConstraint.constant = -10
            self.view.layoutIfNeeded()
        }
    }
     

    @objc func sendButtonTapped() {
        guard let text = createChatScreenView.messageInputField.text, !text.isEmpty,
              let userId = userId,
              let userName = userName else { return }
        let message = Message(senderId: userId, senderName: userName, text: text, timestamp: Date())
        db.collection("chatSessions").document(chatSessionId).collection("messages")
            .addDocument(data: message.toDictionary()) { error in
                if let error = error { print("Error sending message: \(error)") }
                else { DispatchQueue.main.async { self.createChatScreenView.messageInputField.text = "" } }
            }
    }

    @objc func logOutTapped() {
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        } catch {
            Helper.showAlert(on: self, title: "Logout Error", message: error.localizedDescription)
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! ChatMessageCell

        let dateStr = Helper.formatDate(message.timestamp)
        cell.senderNameLabel.text = message.senderName
        cell.messageLabel.text = message.text
        cell.sentTimeLabel.text = dateStr
        cell.senderNameLabel.textAlignment = (message.senderId == userId) ? .right : .left
        cell.messageLabel.textAlignment = (message.senderId == userId) ? .right : .left
        cell.sentTimeLabel.textAlignment = (message.senderId == userId) ? .right : .left
        cell.wrapperCellView.backgroundColor = (message.senderId == userId) ? UIColor.systemGreen.withAlphaComponent(0.3) : UIColor.systemGray5
        cell.selectionStyle = .none
        return cell
    }
}
