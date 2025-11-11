//
//  RegisterViewController.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    let createRegisterScreenView = RegisterView()
    let db = Firestore.firestore()
    
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
                print("The user id at time of register: \(user.uid)")
                Auth.auth().currentUser?.reload(completion: { _ in
                        let realUID = Auth.auth().currentUser?.uid
                        print("Real UID after reload:", realUID ?? "nil")
                })
                let user = User(userId: user.uid ?? "", name: user.displayName ?? "", email: user.email ?? "", createdAt: Date())
                
                self.db.collection("users").document(user.userId).setData(user.toDictionary()) { error in
                    if let error = error {
                        print("Error sending message: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            // Native Swift UIAlertController instead of Helper.showAlert with handler
                            let alert = UIAlertController(title: "Success", message: "Registration Successful. Please Try to Login !", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                                self.navigationController?.popViewController(animated: true)
                            })
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc func loginButton() {
        navigationController?.popViewController(animated: true)
    }
}
