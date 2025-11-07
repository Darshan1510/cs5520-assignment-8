//
//  LoginViewController.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import UIKit
import FirebaseAuth

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
        
        createLoginScreenView.loginButton.addTarget(self, action: #selector(loginButton), for: .touchUpInside)
        createLoginScreenView.signUpButton.addTarget(self, action: #selector(signUpButton), for: .touchUpInside)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func loginButton() {
        guard let email = createLoginScreenView.userEmailField.text, !email.isEmpty,
              let password = createLoginScreenView.userPasswordField.text, !password.isEmpty else {
            return
        }
        
        if email.isEmpty || password.isEmpty {
            Helper.showAlert(on: self, title: "Missing Information", message: "Please enter both your email and password.")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                Helper.showAlert(on: self, title: "Error", message: error.localizedDescription)
                return
            } else {
                DispatchQueue.main.async {
                    let VC = ViewController()
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
    }
    
    @objc func signUpButton() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
