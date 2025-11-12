import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddFriendController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var addFriendsView = AddFriendView()
    var users: [User] = []
    let db = Firestore.firestore()
    var completion: (() -> Void)?
    
    override func loadView() {
        view = addFriendsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Friend"
        addFriendsView.tableView.dataSource = self
        addFriendsView.tableView.delegate = self
        addFriendsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        fetchUsers()
    }
    
    func fetchUsers() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.users = documents
                .map { User(dictionary: $0.data()) }
                .filter { $0.userId != currentUserId }
            DispatchQueue.main.async {
                self.addFriendsView.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView DataSource/Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name + " (" + user.email + ")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        startOrGoToChat(with: selectedUser)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func startOrGoToChat(with friend: User) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let currentUserId = currentUser.uid
        let currentUserName = currentUser.displayName ?? "Me"
        
        let sorted: [(String, String)] = [
            (currentUserId, currentUserName),
            (friend.userId, friend.name)
        ].sorted { $0.0 < $1.0 }
        let participantDicts = sorted.map { ["userId": $0.0, "userName": $0.1] }
        
        // Check for existing session
        db.collection("chatSessions").getDocuments { [weak self] (snapshot, _) in
            guard let self = self else { return }
            var existingSessionId: String?
            let sortedIds = participantDicts.compactMap { $0["userId"] }
            for doc in snapshot?.documents ?? [] {
                if let sessionData = doc.data()["participants"] as? [[String: String]] {
                    let participantIds = sessionData.compactMap { $0["userId"] }.sorted()
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
                let ref = self.db.collection("chatSessions").document()
                    ref.setData(newSession) { err in
                        if let err = err {
                            print("Error: \(err.localizedDescription)")
                        } else {
                            DispatchQueue.main.async {
                                self.goToChat(sessionId: ref.documentID)
                                self.completion?()
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
