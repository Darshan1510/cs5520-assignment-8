//
//  ChatMessageCell.swift
//  css-5520-assignment-8
//
//  Created by Bhavan Jignesh Trivedi on 11/6/25.
//

import Foundation
import UIKit

class ChatMessageCell: UITableViewCell {
    var messageLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMessageLabel()
        initConstraints()
    }

    func setupMessageLabel() {
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
