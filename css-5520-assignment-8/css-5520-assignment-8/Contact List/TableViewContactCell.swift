//
//  TableViewContactCell.swift
//  css-5520-assignment-8
//
//  Created by Student on 11/2/25.
//

import UIKit

class TableViewContactCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelChatName: UILabel!
//    var labelLastMessage: UILabel!
//    var labelLastMessageTime: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupLabelNotes()
//        setupLabelLastMessage()
//        setupLabelLastMessageTime()
        
        initContraints()
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UITableViewCell()
        wrapperCellView.layer.borderWidth = 0.5
        wrapperCellView.layer.borderColor = UIColor.lightGray.cgColor
        wrapperCellView.layer.cornerRadius = 8
        wrapperCellView.layer.masksToBounds = true
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.clipsToBounds = true
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelNotes() {
        labelChatName = UILabel()
        labelChatName.font = UIFont.boldSystemFont(ofSize: 16)
        labelChatName.numberOfLines = 3
        labelChatName.lineBreakMode = .byTruncatingTail
        labelChatName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelChatName)
    }
    
//    func setupLabelLastMessage() {
//        labelLastMessage = UILabel()
//        labelLastMessage.font = UIFont.systemFont(ofSize: 14)
//        labelLastMessage.numberOfLines = 1
//        labelLastMessage.lineBreakMode = .byTruncatingTail
//        labelLastMessage.translatesAutoresizingMaskIntoConstraints = false
//        wrapperCellView.addSubview(labelLastMessage)
//    }
//        
//    func setupLabelLastMessageTime() {
//        labelLastMessageTime = UILabel()
//        labelLastMessageTime.font = UIFont.boldSystemFont(ofSize: 11)
//        labelLastMessageTime.numberOfLines = 1
//        labelLastMessageTime.lineBreakMode = .byTruncatingTail
//        labelLastMessageTime.translatesAutoresizingMaskIntoConstraints = false
//        wrapperCellView.addSubview(labelLastMessageTime)
//    }
    
    func initContraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -4),
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            
            labelChatName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            labelChatName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelChatName.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            labelChatName.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -10),

            
//            labelLastMessage.topAnchor.constraint(equalTo: labelChatName.bottomAnchor, constant: 10),
//            labelLastMessage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
//            labelLastMessage.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
//            
//            labelLastMessageTime.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
//            labelLastMessageTime.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -10),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
