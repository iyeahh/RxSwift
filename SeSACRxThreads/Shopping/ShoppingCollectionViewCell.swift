//
//  ShoppingCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/7/24.
//

import UIKit
import SnapKit

class ShoppingCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShoppingCollectionViewCell"

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
