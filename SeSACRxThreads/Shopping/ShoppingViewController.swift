//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingViewController: UIViewController {
    private let grayBackgroundView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()

    private let addButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()

    private let textField = {
        let textField = UITextField()
        textField.placeholder = "무엇을 구매하실 건가요?"
        return textField
    }()

    private let tableView = UITableView()

    var list = [
        ShoppingItem(isCheck: true, todo: "그립톡 구매하기", isLike: true),
        ShoppingItem(isCheck: false, todo: "사이다 구매", isLike: false),
        ShoppingItem(isCheck: false, todo: "아이패드 케이스 최저가 알아보기", isLike: true),
        ShoppingItem(isCheck: false, todo: "양말", isLike: true)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configrueHierarchy()
        configureLayout()
        configureTableView()
    }

    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "쇼핑"
    }

    private func configrueHierarchy() {
        view.addSubview(grayBackgroundView)
        view.addSubview(addButton)
        view.addSubview(textField)
        view.addSubview(tableView)
    }

    private func configureLayout() {
        grayBackgroundView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(60)
        }

        addButton.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(grayBackgroundView).inset(10)
            make.width.equalTo(addButton.snp.height).multipliedBy(2)
        }

        textField.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(grayBackgroundView).inset(10)
            make.trailing.equalTo(addButton.snp.leading).inset(10)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(grayBackgroundView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

    private func configureTableView() {
        tableView.register(ShoppingTableViewCell.self,forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingTableViewCell.identifier, for: indexPath) as? ShoppingTableViewCell else {
            return UITableViewCell()
        }
        let data = list[indexPath.row]
        cell.setData(data)
        return cell
    }
}
