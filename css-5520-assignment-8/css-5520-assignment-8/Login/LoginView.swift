//
//  LoginView.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import UIKit

class LoginView: UIView {
    
    var cardView: UIView!
    
    var loginAccountLabel: UILabel!
    var userEmailField: UITextField!
    var userPasswordField: UITextField!
    
    var signUpButton: UIButton!
    var loginButton: UIButton!
    
    var cardStack: UIStackView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground

        setUpCreateProfileLabel()
        setupCardView()
        setupUserEmailField()
        setupUserPasswordField()
        setupSignUpButton()
        setupLoginButton()
        
        setupCardStack()
        
        initConstraints()
    }
    
    func setUpCreateProfileLabel() {
        loginAccountLabel = UILabel()
        loginAccountLabel.text = "Log In"
        loginAccountLabel.font = UIFont.boldSystemFont(ofSize: 20)
        loginAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginAccountLabel)
    }
    
    func setupCardView() {
        cardView = UIView()
        cardView.layer.cornerRadius = 12
        cardView.backgroundColor = .white
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cardView)
    }
    
    func setupUserEmailField() {
        userEmailField = UITextField()
        userEmailField.placeholder = "sagar@gmail.co"
        userEmailField.layer.cornerRadius = 0
        userEmailField.backgroundColor = UIColor.systemGray6
        userEmailField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        userEmailField.leftView = leftPaddingView(userEmailField)
        userEmailField.leftViewMode = .always
        userEmailField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUserPasswordField() {
        userPasswordField = UITextField()
        //userPasswordField.isSecureTextEntry = true
        userPasswordField.placeholder = "Password"
        userPasswordField.layer.cornerRadius = 0
        userPasswordField.backgroundColor = UIColor.systemGray6
        userPasswordField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        userPasswordField.leftView = leftPaddingView(userPasswordField)
        userPasswordField.leftViewMode = .always
        userPasswordField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSignUpButton() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemRed
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLoginButton() {
        signUpButton = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign Up", attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 14)])
        signUpButton.setAttributedTitle(attributedText, for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCardStack() {
        // found using google
        cardStack = UIStackView( arrangedSubviews: [
            createLabel("Email Id"), userEmailField,
            createLabel("Password"), userPasswordField,
            signUpButton,
            loginButton,
        ])
        
        cardStack.axis = .vertical
        cardStack.spacing = 13
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(cardStack)
    }
    
    func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    func leftPaddingView(_ textField: UITextField) -> UIView {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        return paddingView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            loginAccountLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            loginAccountLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            cardView.topAnchor.constraint(equalTo: loginAccountLabel.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 14),
            cardView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -14),
            
            cardStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            cardStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            cardStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            cardStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
        ])
    }
}
