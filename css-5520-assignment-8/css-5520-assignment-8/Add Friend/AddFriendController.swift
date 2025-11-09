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
            let friendName = (doc.data()["userName"] as? String) ?? friendEmail

            if friendId == currentUserId {
                Helper.showAlert(on: self, title: "Invalid", message: "You cannot chat with yourself.")
                return
            }

            let currentUserRef = db.collection("users").document(currentUserId)
            currentUserRef.getDocument { (myDocSnap, myError) in
                let myName = myDocSnap?.data()?["userName"] as? String ?? "Me"
                let sorted: [(String, String)] = [
                    (currentUserId, myName),
                    (friendId, friendName)
                ].sorted { $0.0 < $1.0 }
                let participantDicts = sorted.map { ["userId": $0.0, "userName": $0.1] }

                // Check for existing session
                db.collection("chatSessions").getDocuments { (snapshot, _) in
                    var existingSessionId: String?
                    for doc in snapshot?.documents ?? [] {
                        if let session = try? doc.data(as: ChatSession.self),
                           let participants = session.participants {
                            let participantIds = participants.compactMap { $0["userId"] }.sorted()
                            let sortedIds = participantDicts.compactMap { $0["userId"] }
                            if participantIds == sortedIds {
                                existingSessionId = doc.documentID
                                break
                            }
                        }
                    }

                    if let sessionId = existingSessionId {
                        DispatchQueue.main.async {
                            self.goToChat(sessionId: sessionId)
                            self.completion?()
                        }
                    } else {
                        let newSession: [String: Any] = [
                            "participants": participantDicts,
                            "createdAt": Timestamp(),
                            "lastMessage": "",
                            "lastMessageTime": Timestamp()
                        ]
                        var ref: DocumentReference?
                        ref = db.collection("chatSessions").addDocument(data: newSession) { err in
                            if let err = err {
                                Helper.showAlert(on: self, title: "Error", message: err.localizedDescription)
                            } else if let newDocId = ref?.documentID {
                                DispatchQueue.main.async {
                                    self.goToChat(sessionId: newDocId)
                                    self.completion?()
                                }
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
