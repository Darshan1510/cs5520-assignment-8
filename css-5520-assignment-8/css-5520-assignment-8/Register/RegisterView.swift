//
//  RegisterView.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import UIKit

class RegisterView: UIView {
    
    var cardView: UIView!
    
    var createAccountLabel: UILabel!
    var userNameField: UITextField!
    var userEmailField: UITextField!
    var userPasswordField: UITextField!
    var userConfirmPasswordField: UITextField!
    
    var signUpButton: UIButton!
    var loginButton: UIButton!
    
    var cardStack: UIStackView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground

        setUpCreateProfileLabel()
        setupCardView()
        setupUserNameField()
        setupUserEmailField()
        setupUserPasswordField()
        setupUserConfirmPasswordField()
        setupSignUpButton()
        setupLoginButton()
        
        setupCardStack()
        
        initConstraints()
    }
    
    func setUpCreateProfileLabel() {
        createAccountLabel = UILabel()
        createAccountLabel.text = "Create Profile"
        createAccountLabel.font = UIFont.boldSystemFont(ofSize: 20)
        createAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(createAccountLabel)
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

    
    func setupUserNameField() {
        userNameField = UITextField()
        userNameField.placeholder = "Sagar Bilwal"
        userNameField.layer.cornerRadius = 0
        userNameField.backgroundColor = UIColor.systemGray6
        userNameField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        userNameField.leftView = leftPaddingView(userNameField)
        userNameField.leftViewMode = .always
        userNameField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUserEmailField() {
        userEmailField = UITextField()
        userEmailField.placeholder = "sagar@gmail.co"
        userEmailField.layer.cornerRadius = 0
        userEmailField.backgroundColor = UIColor.systemGray6
        userEmailField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        userEmailField.leftView = leftPaddingView(userNameField)
        userEmailField.leftViewMode = .always
        userEmailField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUserPasswordField() {
        userPasswordField = UITextField()
        userPasswordField.isSecureTextEntry = true
        userPasswordField.placeholder = "Password"
        userPasswordField.layer.cornerRadius = 0
        userPasswordField.backgroundColor = UIColor.systemGray6
        userPasswordField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        userPasswordField.leftView = leftPaddingView(userNameField)
        userPasswordField.leftViewMode = .always
        userPasswordField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUserConfirmPasswordField() {
        userConfirmPasswordField = UITextField()
        userConfirmPasswordField.isSecureTextEntry = true
        userConfirmPasswordField.placeholder = "Confirm Password"
        userConfirmPasswordField.layer.cornerRadius = 0
        userConfirmPasswordField.backgroundColor = UIColor.systemGray6
        userConfirmPasswordField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        userConfirmPasswordField.leftView = leftPaddingView(userNameField)
        userConfirmPasswordField.leftViewMode = .always
        userConfirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSignUpButton() {
        signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = .systemRed
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 8
        signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLoginButton() {
        loginButton = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Already have an account? Log In", attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 14)])
        loginButton.setAttributedTitle(attributedText, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCardStack() {
        // found using google
        cardStack = UIStackView( arrangedSubviews: [
            createLabel("Full Name"), userNameField,
            createLabel("Email ID"), userEmailField,
            createLabel("Password"), userPasswordField,
            createLabel("Confirm Password"), userConfirmPasswordField,
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
            createAccountLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            createAccountLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            cardView.topAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 14),
            cardView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -14),
            
            cardStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            cardStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            cardStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            cardStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
        ])
    }
}
