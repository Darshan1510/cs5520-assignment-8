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
    var contactList = [String]()
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
        
        createContactListScreenView.tableViewNotes.delegate = self
        createContactListScreenView.tableViewNotes.dataSource = self
        createContactListScreenView.tableViewNotes.separatorStyle = .none
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTapped))
        
        fetchContacts()
    }
    
    func fetchContacts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User").whereField("userId",isNotEqualTo: currentUserId).getDocuments {QuerySnapshot, error in
            if let error = error {
                print("Failing to fetch users: \(error)")
                return
            }
            self.contactList.removeAll()
            if let documents = QuerySnapshot?.documents {
                for doc in documents {
                    if let name = doc.data()["name"] as? String {
                        self.contactList.append(name)
                    }
                }
            }
            DispatchQueue.main.async {
                self.createContactListScreenView.tableViewNotes.reloadData()
            }
        }
    }
    
    @objc func onAddButtonTapped() {
//        let addNotesControl
        
//        ler = AddNotesViewController()
//        navigationController?.pushViewController(addNotesController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contacts", for: indexPath) as! TableViewContactCell
        cell.labelNotes.text = contactList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vC = ChatViewController()
        navigationController?.pushViewController(vC, animated: true)
    }
}
