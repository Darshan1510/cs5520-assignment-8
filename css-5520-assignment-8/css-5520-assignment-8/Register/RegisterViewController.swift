//
//  RegisterViewController.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    let createRegisterScreenView = RegisterView()
    
    override func loadView() {
        view = createRegisterScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        createRegisterScreenView.signUpButton.addTarget(self, action: #selector(signUpButton), for: .touchUpInside)
        createRegisterScreenView.loginButton.addTarget(self, action: #selector(loginButton), for: .touchUpInside)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func signUpButton() {
        guard let name = createRegisterScreenView.userNameField.text,
              let email = createRegisterScreenView.userEmailField.text,
              let password = createRegisterScreenView.userPasswordField.text,
              let confirmPassword = createRegisterScreenView.userConfirmPasswordField.text else {
            return
        }
        
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            Helper.showAlert(on: self, title: "Missing Value", message: "Please enter all the credentials.")
            return
        }
        
        if !Helper.valdiateEmail(email) {
            Helper.showAlert(on: self, title: "Invalid Email", message: "Please enter a valid email.")
            return
        }
        
        if password != confirmPassword {
            Helper.showAlert(on: self, title: "Password Mismatch", message: "Password and confirm password do not match.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                Helper.showAlert(on: self, title: "Registration Error", message: error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else { return }
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    Helper.showAlert(on: self, title: "Can't Update Profile", message: error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    Helper.showAlert(on: self, title: "Success", message: "Registration Successful. Please Try to Login !!")
                }
            }
        }
    }
    
    @objc func loginButton() {
        navigationController?.popViewController(animated: true)
    }
}
