//
//  User.swift
//  css-5520-assignment-8
//
//  Created by Bhavan Jignesh Trivedi on 11/5/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct User {
    let userId: String
    let name: String
    let email: String
    let createdAt: Date

    init(userId: String, name: String, email: String, createdAt: Date) {
        self.userId = userId
        self.name = name
        self.email = email
        self.createdAt = createdAt
    }

    init(dictionary: [String: Any]) {
        self.userId = dictionary["userId"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        if let timestamp = dictionary["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else if let date = dictionary["createdAt"] as? Date {
            self.createdAt = date
        } else {
            self.createdAt = Date()
        }
    }

    func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "name": name,
            "email": email,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
