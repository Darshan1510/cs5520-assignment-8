import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddFriendController: UIViewController {
    var addFriendsView = AddFriendView()
    var completion: (() -> Void)?

    override func loadView() {
        view = addFriendsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Friend"
        addFriendsView.submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    @objc func submitTapped() {
        let emails = addFriendsView.getAllEmails().map { $0.lowercased() }
        guard emails.count == 1, let friendEmail = emails.first else {
            Helper.showAlert(on: self, title: "Input Error", message: "Enter exactly one email per chat.")
            return
        }

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            Helper.showAlert(on: self, title: "Auth Error", message: "User not logged in.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: friendEmail).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                Helper.showAlert(on: self, title: "Error", message: error.localizedDescription)
                return
            }

            guard let doc = snapshot?.documents.first else {
                Helper.showAlert(on: self, title: "Not Found", message: "No user found with \(friendEmail)")
                return
            }

            let friendId = doc.documentID
            if friendId == currentUserId {
                Helper.showAlert(on: self, title: "Invalid", message: "You cannot chat with yourself.")
                return
            }
            let participantIds = [currentUserId, friendId].sorted()
            db.collection("chatSessions").whereField("participants", isEqualTo: participantIds).getDocuments { (sessionSnapshot, _) in
                if let sessionDoc = sessionSnapshot?.documents.first {
                    let sessionId = sessionDoc.documentID
                    DispatchQueue.main.async {
                        self.goToChat(sessionId: sessionId)
                    }
                } else {
                    let newSession: [String: Any] = [
                        "participants": participantIds,
                        "createdAt": Timestamp(),
                        "lastMessage": "",
                        "lastMessageTime": Timestamp()
                    ]
                    var ref: DocumentReference? = nil
                    ref = db.collection("chatSessions").addDocument(data: newSession) { err in
                        if let err = err {
                            Helper.showAlert(on: self, title: "Error", message: err.localizedDescription)
                        } else if let newDocId = ref?.documentID {
                            DispatchQueue.main.async {
                                self.goToChat(sessionId: newDocId)
                            }
                        }
                    }
                }
            }
        }
    }

    func goToChat(sessionId: String) {
        let chatVC = ChatViewController()
        chatVC.chatSessionId = sessionId
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
