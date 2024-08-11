//
//  ResultCollectionViewCell.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/11/24.
//

import UIKit
import SnapKit

final class ResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResultCollectionViewCell"

    private let iconImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let nameLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()

    private let downloadButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("받기", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()

    private let starImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .tintColor
        return imageView
    }()

    private let rateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()

    private let companyLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()

    private let categoryLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()

    private let descriptionImageView1 = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let descriptionImageView2 = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let descriptionImageView3 = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultCollectionViewCell {
    private func configureHierarchy() {
        [iconImageView, nameLabel, downloadButton, starImageView, rateLabel, companyLabel, categoryLabel, descriptionImageView1, descriptionImageView2, descriptionImageView3].forEach { contentView.addSubview($0)}
    }

    private func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
            make.width.equalTo(iconImageView.snp.height)
        }

        downloadButton.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.trailing.equalToSuperview()
            make.height.equalTo(iconImageView).dividedBy(2)
            make.width.equalTo(downloadButton.snp.height).multipliedBy(3)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
            make.trailing.equalTo(downloadButton.snp.leading).inset(5)
            make.centerY.equalTo(iconImageView)
        }

        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.height.equalTo(iconImageView).dividedBy(4)
            make.width.equalTo(starImageView.snp.height)
        }

        rateLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(3)
            make.centerY.equalTo(starImageView)
        }

        companyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView)
            make.centerX.equalToSuperview()
        }

        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView)
            make.trailing.equalToSuperview()
        }

        descriptionImageView1.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(starImageView.snp.bottom).offset(10)
            make.width.equalTo(contentView.snp.width).dividedBy(3.3)
            make.height.equalTo(descriptionImageView1.snp.width).multipliedBy(2)
        }

        descriptionImageView3.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(starImageView.snp.bottom).offset(10)
            make.width.equalTo(contentView.snp.width).dividedBy(3.3)
            make.height.equalTo(descriptionImageView1.snp.width).multipliedBy(2)
        }

        descriptionImageView2.snp.makeConstraints { make in
            make.top.equalTo(starImageView.snp.bottom).offset(10)
            make.width.equalTo(contentView.snp.width).dividedBy(3.3)
            make.height.equalTo(descriptionImageView1.snp.width).multipliedBy(2)
            make.centerX.equalToSuperview()
        }
    }
}
