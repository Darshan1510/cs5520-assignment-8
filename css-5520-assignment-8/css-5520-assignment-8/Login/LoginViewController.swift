//
//  LoginViewController.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import UIKit

class LoginViewController: UIViewController {

    let createLoginScreenView = LoginView()
    override func loadView() {
        view = createLoginScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
