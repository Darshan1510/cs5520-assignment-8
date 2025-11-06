


//
//  Helper.swift
//  css-5520-assignment-8
//
//  Created by Bhavan Jignesh Trivedi on 11/5/25.
//

import Foundation
import Firebase

class Helper {
    static func valdiateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
    static func formatDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMM dd, yyyy hh:mm a"
           return formatter.string(from: date)
    }
}
