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
    let notificationCenter = NotificationCenter.default
    let db = Firestore.firestore()
    
    override func loadView() {
        view = createContactListScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Contacts"
//        var note1 = Notes(_id: "secure1", text: "Adding a longer text to to test if the text will be curtailed by the code logic I have written.")
//        var note2 = Notes(_id: "secure1", text: "Smaller text should not be affected")
//        notesList.append(note1)
//        notesList.append(note2)
//        do{
//            try Auth.auth().signOut()
//        } catch {
//            
//        }
        if let user = Auth.auth().currentUser {print(user.email)}
        else {
            navigationController?.pushViewController(LoginViewController(), animated: true)
        }
        createContactListScreenView.tableViewNotes.delegate = self
        createContactListScreenView.tableViewNotes.dataSource = self
        createContactListScreenView.tableViewNotes.separatorStyle = .none
        createContactListScreenView.tableViewNotes.focusEffect = .none
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTapped))
        fetchContacts()
    }
    
    func fetchContacts() {
        guard let currentUserEmailId = Auth.auth().currentUser?.email else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        print(currentUserEmailId)
        let chatService = ChatService()
        chatService.getUserChatSessions(userEmailId: currentUserEmailId, userId: currentUserId) {
            sessions in
            for session in sessions {
                if let participants = session.participants {
                    
                    var chatGroupName = ""
                    for participant in participants{
                        print(participant["userId"])
                        let participantEmailId = participant["userId"] ?? ""
                        if  participantEmailId != currentUserEmailId {
                            if (chatGroupName.isEmpty) {
                                chatGroupName.append(participant["userName"] ?? "")
                            } else {
                                chatGroupName.append(", \(participant["userName"] ?? "")")
                            }
                        }
                    }
                    print(chatGroupName)
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
                print("Last Message: \(session.lastMessage)")
            }
            DispatchQueue.main.async{
                self.createContactListScreenView.tableViewNotes.reloadData()
            }
        }
    }
    
    @objc func onAddButtonTapped() {
        let addVC = AddFriendController()
            addVC.completion = { [weak self] in self?.fetchContacts() }
            navigationController?.pushViewController(addVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contacts", for: indexPath) as! TableViewContactCell
        cell.labelChatName.text = contactList[indexPath.row].name
//        cell.labelLastMessage.text = contactList[indexPath.row].lastMessage
//        cell.labelLastMessageTime.text = contactList[indexPath.row].lastMessageTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vC = ChatViewController()
        vC.chatSessionId = contactList[indexPath.row].chatSessionId ?? ""
        navigationController?.pushViewController(vC, animated: true)
    }
}
