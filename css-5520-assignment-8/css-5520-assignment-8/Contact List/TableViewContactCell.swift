//
//  TableViewContactCell.swift
//  css-5520-assignment-8
//
//  Created by Student on 11/2/25.
//

import UIKit

class TableViewContactCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelNotes: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupLabelNotes()
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
        labelNotes = UILabel()
        labelNotes.font = UIFont.boldSystemFont(ofSize: 18)
        labelNotes.numberOfLines = 3
        labelNotes.lineBreakMode = .byTruncatingTail
        labelNotes.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelNotes)
    }
    
    func initContraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -4),
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            
            labelNotes.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            labelNotes.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelNotes.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            labelNotes.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -10),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 80)
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
