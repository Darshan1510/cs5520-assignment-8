//
//  RegisterViewController.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import UIKit

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
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
