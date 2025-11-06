//
//  ChatListView.swift
//  css-5520-assignment-8
//
//  Created by Student on 11/2/25.
//

import UIKit

class ContactListView: UIView {
    
    var tableViewNotes: UITableView!
    
    var userProfileDelete: UIButton!

        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupTableViewNotes()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableViewNotes() {
        tableViewNotes = UITableView()
        tableViewNotes.register(TableViewContactCell.self, forCellReuseIdentifier: "contacts")
        tableViewNotes.translatesAutoresizingMaskIntoConstraints = false
        tableViewNotes.clipsToBounds = true
        self.addSubview(tableViewNotes)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            tableViewNotes.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableViewNotes.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewNotes.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewNotes.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
}
