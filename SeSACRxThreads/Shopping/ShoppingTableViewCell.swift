//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingTableViewCell: UITableViewCell {
    static let identifier = "ShoppingTableViewCell"

    private let grayBackgroundView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()

    let checkButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        button.tintColor = .black
        return button
    }()

    let likeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .black
        return button
    }()

    let todoLabel = {
        let label = UILabel()
        label.text = "dkdkdk"
        return label
    }()

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(grayBackgroundView)
        contentView.addSubview(checkButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(todoLabel)
    }

    private func configureLayout() {
        grayBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(5)
        }

        checkButton.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(grayBackgroundView).inset(10)
            make.width.equalTo(checkButton.snp.height)
        }

        likeButton.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(grayBackgroundView).inset(10)
            make.width.equalTo(likeButton.snp.height)
        }

        todoLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(grayBackgroundView).inset(10)
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.trailing.equalTo(likeButton.snp.leading).inset(10)
        }
    }
}
