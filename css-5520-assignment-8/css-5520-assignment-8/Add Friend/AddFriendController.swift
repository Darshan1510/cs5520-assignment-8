//
//  AddFriendController.swift
//  css-5520-assignment-8
//
//  Created by Bhavan Jignesh Trivedi on 11/6/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddFriendController: UIViewController {
    let addFriendsView = AddFriendView()
    var completion: (() -> Void)?

    override func loadView() {
        view = addFriendsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Friends"
        addFriendsView.addMoreButton.addTarget(self, action: #selector(addMoreTapped), for: .touchUpInside)
        addFriendsView.submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    @objc func addMoreTapped() {
        addFriendsView.addEmailField()
    }

    @objc func submitTapped() {
        let emails = addFriendsView.getAllEmails().map { $0.lowercased() }
        guard !emails.isEmpty else {
            Helper.showAlert(on: self, title: "Input Error", message: "Enter at least one email.")
            return
        }

        let db = Firestore.firestore()
        let usersRef = db.collection("User")
        let currentUserId = Auth.auth().currentUser?.uid

        let group = DispatchGroup()
        var addedEmails = [String]()
        var notFoundEmails = [String]()

        for email in emails {
            group.enter()
            usersRef.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
                defer { group.leave() }
                if let doc = snapshot?.documents.first, let friendId = doc.data()["userId"] as? String, let currentUserId = currentUserId {
                    db.collection("User")
                        .document(currentUserId)
                        .collection("Friends")
                        .document(friendId)
                        .setData(["userId": friendId, "email": email]) { _ in
                            addedEmails.append(email)
                        }
                } else {
                    notFoundEmails.append(email)
                }
            }
        }
        group.notify(queue: .main) {
            var message = ""
            if !addedEmails.isEmpty { message += "Added: " + addedEmails.joined(separator: ", ") + "." }
            if !notFoundEmails.isEmpty { message += " Not found: " + notFoundEmails.joined(separator: ", ") + "." }
            Helper.showAlert(on: self, title: "Result", message: message.isEmpty ? "No contacts added." : message)
            self.completion?()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
