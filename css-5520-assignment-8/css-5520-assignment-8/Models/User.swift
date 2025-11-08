//
//  User.swift
//  css-5520-assignment-8
//
//  Created by Bhavan Jignesh Trivedi on 11/5/25.
//

import Foundation
import FirebaseCore

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

    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "createdAt": Timestamp(date: createdAt),
            "chatSessions": []
        ]
    }
}
