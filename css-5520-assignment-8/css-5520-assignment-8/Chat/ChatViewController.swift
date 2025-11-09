import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        userName = Auth.auth().currentUser?.displayName ?? userId
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        createChatScreenView.tableView.delegate = self
        createChatScreenView.tableView.dataSource = self
        createChatScreenView.tableView.allowsSelection = false
        createChatScreenView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        
        startListeningMessages()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func backTapped() {
            navigationController?.popViewController(animated: true)
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

    @objc func sendButtonTapped() {
        guard let text = createChatScreenView.messageInputField.text, !text.isEmpty,
              let userId = userId,
              let userName = userName else { return }

        let message = Message(senderId: userId, senderName: userName, text: text, timestamp: Date())

        let chatSessionRef = db.collection("chatSessions").document(chatSessionId)
        let messageRef = chatSessionRef.collection("messages").document()

        let batch = db.batch()

        batch.setData(message.toDictionary(), forDocument: messageRef)
        batch.updateData([
            "lastMessage": text,
            "lastMessageTime": message.timestamp
        ], forDocument: chatSessionRef)

        batch.commit{ error in
            if let error = error {
                print("Error occurred: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.createChatScreenView.messageInputField.text = ""
                }
            }
        }
    }

    // MARK: - UITableView Delegates

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
