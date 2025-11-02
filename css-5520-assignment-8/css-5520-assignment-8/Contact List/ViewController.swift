//
//  ViewController.swift
//  css-5520-assignment-8
//
//  Created by Student on 11/2/25.
//

import UIKit

class ViewController: UIViewController {
    
    let createContactListScreenView = ContactListView()
    var contactList = [String]()
    let notificationCenter = NotificationCenter.default
    
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
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
        notificationCenter.addObserver(self,
            selector: #selector(notificationReceivedForNotesUpdate(notification:)), name: Notification.Name("notesUpdate"), object: nil)
        createContactListScreenView.tableViewNotes.delegate = self
        createContactListScreenView.tableViewNotes.dataSource = self
        createContactListScreenView.tableViewNotes.separatorStyle = .none
        
        createContactListScreenView.tableViewNotes.reloadData()
        let registerController = RegisterViewController()
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    @objc func onAddButtonTapped() {
//        let addNotesController = AddNotesViewController()
//        navigationController?.pushViewController(addNotesController, animated: true)
    }
    
    @objc func notificationReceivedForNotesUpdate(notification: Notification) {
        
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

    }
}
