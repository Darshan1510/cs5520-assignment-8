//
//  ChatSession.swift
//  css-5520-assignment-8
//
//  Created by Student on 11/6/25.
//

import Foundation
import FirebaseFirestore

struct ChatSession: Identifiable, Codable {
    @DocumentID var id: String?
    var participants: [[String: String]]?
    var lastMessage: String?
    var lastMessageTime: Timestamp?
    var createdAt: Timestamp?
}


