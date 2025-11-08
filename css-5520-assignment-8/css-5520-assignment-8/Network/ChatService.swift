//
//  ChatService.swift
//  css-5520-assignment-8
//
//  Created by Student on 11/6/25.
//

import FirebaseFirestore

class ChatService {

     private let db = Firestore.firestore()
 
    func getUserChatSessions(userEmailId: String, userId: String, completion: @escaping ([ChatSession]) -> Void) {

        db.collection("users").document(userId).addSnapshotListener() { snapshot, error in
             if let error = error {
                 print("Error fetching user: \(error)")
                 completion([])
                 return
             }
            print("This is getting called")
            guard let data = snapshot,
                   let sessionIds = data["chatSessions"] as? [String] else {
                 print("No chat sessions found for user")
                 completion([])
                 return

             }
 
            var chatSessions: [ChatSession] = []
            let group = DispatchGroup()
 
            for sessionId in sessionIds {
                 group.enter()
                 self.db.collection("chatSessions").document(sessionId).getDocument { doc, err in
                     defer { group.leave() }
                    if let doc = doc, doc.exists {
                         do {
                             let chatSession = try doc.data(as: ChatSession.self)
                             chatSessions.append(chatSession)
                         } catch {
                             print("Error decoding chatSession: \(error)")
                         }
                     }
                 }
             }

            group.notify(queue: .main) {
                 completion(chatSessions.sorted { ($0.lastMessageTime?.dateValue() ?? .distantPast) > ($1.lastMessageTime?.dateValue() ?? .distantPast) })
             }

         }

     }

 }
