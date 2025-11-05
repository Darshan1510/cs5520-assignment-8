//
//  Message.swift
//  css-5520-assignment-8
//
//  Created by Bhavan Jignesh Trivedi on 11/5/25.
//

import Foundation
import FirebaseCore

struct Message {
    let senderId: String
    let senderName: String
    let text: String
    let timestamp: Date

    // Dictionary initializer
    init(dictionary: [String: Any]) {
        self.senderId = dictionary["senderId"] as? String ?? ""
        self.senderName = dictionary["senderName"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        if let timestamp = dictionary["timestamp"] as? Timestamp {
            self.timestamp = timestamp.dateValue()
        } else {
            self.timestamp = Date()
        }
    }

    // Memberwise initializer (required for sending)
    init(senderId: String, senderName: String, text: String, timestamp: Date) {
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
        self.timestamp = timestamp
    }

    func toDictionary() -> [String: Any] {
        return [
            "senderId": senderId,
            "senderName": senderName,
            "text": text,
            "timestamp": Timestamp(date: timestamp)
        ]
    }
}
