//
//  ViewController.swift
//  css-5520-assignment-8
//
//  Created by Student on 11/2/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    let createContactListScreenView = ContactListView()
    var contactList = [Chat]()
    let db = Firestore.firestore()

    override func loadView() {
        view = createContactListScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"

        if let user = Auth.auth().currentUser {
            print("User email: \(user.email ?? "N/A")")
            print("User UID: \(user.uid)")
        } else {
            navigationController?.pushViewController(LoginViewController(), animated: true)
            return
        }

        createContactListScreenView.tableViewNotes.delegate = self
        createContactListScreenView.tableViewNotes.dataSource = self
        createContactListScreenView.tableViewNotes.separatorStyle = .none
        createContactListScreenView.tableViewNotes.register(TableViewContactCell.self, forCellReuseIdentifier: "contacts")

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTapped))

        fetchContacts()
    }

    func fetchContacts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }


        db.collection("chatSessions").addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching chat sessions: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            contactList.removeAll()

            for doc in documents {
                guard let session = try? doc.data(as: ChatSession.self),
                      let participants = session.participants else { continue }

                // Check if current user is in participants
                guard participants.contains(where: { $0["userId"] == currentUserId }) else { continue }

                var chatGroupName = ""
                for participant in participants {
                    if (participant["userId"] ?? "") != currentUserId {
                        if chatGroupName.isEmpty {
                            chatGroupName = participant["userName"] ?? ""
                        } else {
                            chatGroupName.append(", \(participant["userName"] ?? "")")
                        }
                    }
                }

                var chat = Chat()
                chat.name = chatGroupName
                chat.lastMessage = session.lastMessage ?? ""
                chat.chatSessionId = session.id ?? ""
                
                if let timestamp = session.lastMessageTime {
                    let date = timestamp.dateValue()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd/yyyy"
                    chat.lastMessageTime = formatter.string(from: date)
                }

                self.contactList.append(chat)
            }

            DispatchQueue.main.async {
                print("Reloading table with \(self.contactList.count) chats")
                self.createContactListScreenView.tableViewNotes.reloadData()
            }
        }
    }

    @objc func onAddButtonTapped() {
        let addVC = AddFriendController()
        addVC.completion = { [weak self] in self?.fetchContacts() }
        navigationController?.pushViewController(addVC, animated: true)
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contacts", for: indexPath) as! TableViewContactCell
        cell.labelChatName.text = contactList[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vC = ChatViewController()
        vC.chatSessionId = contactList[indexPath.row].chatSessionId ?? ""
        navigationController?.pushViewController(vC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
