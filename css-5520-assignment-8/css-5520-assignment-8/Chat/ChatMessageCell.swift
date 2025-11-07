//
//  ChatMessageCell.swift
//  css-5520-assignment-8
//
//  Created by Bhavan Jignesh Trivedi on 11/6/25.
//

import Foundation
import UIKit

class ChatMessageCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var senderNameLabel: UILabel!
    var messageLabel: UILabel!
    var sentTimeLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupSenderNameLabel()
        setupMessageLabel()
        setupSentTimeLabel()
        initConstraints()
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UITableViewCell()
        wrapperCellView.layer.borderWidth = 0.5
        wrapperCellView.layer.borderColor = UIColor.lightGray.cgColor
        wrapperCellView.layer.cornerRadius = 10
        wrapperCellView.layer.masksToBounds = true
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.clipsToBounds = true
        self.addSubview(wrapperCellView)
    }

    func setupSenderNameLabel() {
        senderNameLabel = UILabel()
        senderNameLabel.numberOfLines = 1
        senderNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(senderNameLabel)
    }
    
    func setupMessageLabel() {
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(messageLabel)
    }
    
    func setupSentTimeLabel() {
        sentTimeLabel = UILabel()
        sentTimeLabel.numberOfLines = 1
        sentTimeLabel.font = UIFont.boldSystemFont(ofSize: 11)
        sentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(sentTimeLabel)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -4),
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            wrapperCellView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            wrapperCellView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            senderNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            senderNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            senderNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            
            messageLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            
            sentTimeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            sentTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            sentTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            sentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
