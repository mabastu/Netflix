//
//  CollectionViewCell.swift
//  Netflix
//
//  Created by Mabast on 2024-08-03.
//

import UIKit

class HomeCllectionViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
