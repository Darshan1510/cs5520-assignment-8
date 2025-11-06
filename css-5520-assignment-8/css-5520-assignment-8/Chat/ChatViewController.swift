import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    var createChatScreenView = ChatView()
    var messages = [Message]()
    var chatSessionId: String = "" // Assign dynamically based on chat selection
    
    let db = Firestore.firestore()
    var userId: String?
    var userName: String?
    
    override func loadView() {
        view = createChatScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = Auth.auth().currentUser?.email
        userName = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email
        
        createChatScreenView.tableView.delegate = self
        createChatScreenView.tableView.dataSource = self
        createChatScreenView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "messageCell")
        
        createChatScreenView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        startListeningMessages()
    }
    
    func startListeningMessages() {
        db.collection("chatSessions").document(chatSessionId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Failed to listen for messages: \(error)")
                    return
                }
                print(messages)
                self.messages.removeAll()
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let message = Message(dictionary: doc.data())
                        self.messages.append(message)
                    }
                }
                print("After")
                print(messages)
                DispatchQueue.main.async {
                    self.createChatScreenView.tableView.reloadData()
                    if self.messages.count > 0 {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//                        self.createChatScreenView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
    }
    
    @objc func sendButtonTapped() {
        guard let text = createChatScreenView.messageInputField.text, !text.isEmpty,
              let userId = userId,
              let userName = userName else { return }
        
        let message = Message(senderId: userId, senderName: userName, text: text, timestamp: Date())
        db.collection("chatSessions").document(chatSessionId).collection("messages")
            .addDocument(data: message.toDictionary()) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.createChatScreenView.messageInputField.text = ""
                    }
                }
            }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        let isCurrentUser = message.senderId == userId
        cell.textLabel?.numberOfLines = 0
        
        let dateStr = Helper.formatDate(message.timestamp)
        
        let displayText = "\(message.senderName)\n\(message.text)\n\(dateStr)"
        cell.textLabel?.text = displayText
        cell.textLabel?.textAlignment = isCurrentUser ? .right : .left
        
        cell.backgroundColor = isCurrentUser ? UIColor.systemGreen.withAlphaComponent(0.3) : UIColor.systemGray5

        return cell
    }
}
