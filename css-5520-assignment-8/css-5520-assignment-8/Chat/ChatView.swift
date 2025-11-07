//
//  ChatView.swift
//  css-5520-assignment-8
//
//  Created by Student on 11/2/25.
//

import UIKit

class ChatView: UIView {
    var tableView: UITableView!
    var messageInputField: UITextField!
    var sendButton: UIButton!
    
    var messageInputBottomConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setUpTableView()
        setUpMessageInputField()
        setUpSendButton()
        initConstraints()
    }

    func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "messageCell")
        addSubview(tableView)
    }

    func setUpMessageInputField() {
        messageInputField = UITextField()
        messageInputField.borderStyle = .roundedRect
        messageInputField.placeholder = "Type a message"
        messageInputField.translatesAutoresizingMaskIntoConstraints = false
        messageInputBottomConstraint = messageInputField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        addSubview(messageInputField)
    }

    func setUpSendButton() {
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendButton)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            messageInputBottomConstraint,
            messageInputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageInputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),

            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: messageInputField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60),

            messageInputField.heightAnchor.constraint(equalToConstant: 40),
            tableView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
