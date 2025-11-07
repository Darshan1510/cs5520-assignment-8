//
//  AddFileView.swift
//  css-5520-assignment-8
//
//  Created by Bhavan Jignesh Trivedi on 11/6/25.
//

import UIKit

class AddFriendView: UIView {
    var instructionLabel: UILabel!
    var stackView: UIStackView!
    var addMoreButton: UIButton!
    var submitButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        instructionLabel = UILabel()
        instructionLabel.text = "Enter friend email(s):"
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(instructionLabel)

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        // Add initial email field
        stackView.addArrangedSubview(createEmailField())

        addMoreButton = UIButton(type: .system)
        addMoreButton.setTitle("Add More", for: .normal)
        addMoreButton.backgroundColor = .systemGray4
        addMoreButton.setTitleColor(.black, for: .normal)
        addMoreButton.layer.cornerRadius = 8
        addMoreButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addMoreButton)

        submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(submitButton)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            instructionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            addMoreButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            addMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addMoreButton.widthAnchor.constraint(equalToConstant: 120),
            addMoreButton.heightAnchor.constraint(equalToConstant: 40),

            submitButton.topAnchor.constraint(equalTo: addMoreButton.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 160),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createEmailField() -> UITextField {
        let emailField = UITextField()
        emailField.borderStyle = .roundedRect
        emailField.placeholder = "Friend's Email"
        emailField.autocapitalizationType = .none
        return emailField
    }

    /// Get all email entries from stackView
    func getAllEmails() -> [String] {
        stackView.arrangedSubviews.compactMap { ($0 as? UITextField)?.text?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }

    /// Add a new email field
    func addEmailField() {
        stackView.addArrangedSubview(createEmailField())
    }
}
