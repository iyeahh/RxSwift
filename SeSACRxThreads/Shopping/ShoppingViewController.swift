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

    private let searchBar = UISearchBar()

    private let tableView = UITableView()

    let disposeBag = DisposeBag()

    var data = [
        ShoppingItem(isCheck: true, todo: "그립톡 구매하기", isLike: true),
        ShoppingItem(isCheck: false, todo: "사이다 구매", isLike: false),
        ShoppingItem(isCheck: false, todo: "아이패드 케이스 최저가 알아보기", isLike: true),
        ShoppingItem(isCheck: false, todo: "양말", isLike: true)
    ]

    lazy var list = BehaviorRelay(value: data)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configrueHierarchy()
        configureLayout()
        configureTableView()
        bind()
    }

    private func bind() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                let array = owner.data.filter { $0.todo.contains(value) }
                owner.list.accept(array)
            }
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .bind(with: self) { owner, value in
                let array = value.isEmpty ? owner.data : owner.data.filter { $0.todo.contains(value) }
                owner.list.accept(array)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                var listArr = owner.list.value
                listArr.remove(at: indexPath.row)
                owner.list.accept(listArr)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(DetailViewController(), animated: true)
            }
            .disposed(by: disposeBag)

        list
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
                let checkImage = element.isCheck ? "checkmark.square.fill" : "checkmark.square"
                let likeImage = element.isLike ? "star.fill" : "star"

                cell.checkButton.setImage(UIImage(systemName: checkImage), for: .normal)
                cell.todoLabel.text = element.todo
                cell.likeButton.setImage(UIImage(systemName: likeImage), for: .normal)

                cell.likeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.data[row].isLike.toggle()
                        owner.list.accept(owner.data)
                    }
                    .disposed(by: cell.disposeBag)

                cell.checkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.data[row].isCheck.toggle()
                        owner.list.accept(owner.data)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        addButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                owner.data.append(ShoppingItem(isCheck: false, todo: value, isLike: false))
                owner.list.accept(owner.data)
            }
            .disposed(by: disposeBag)
    }

    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "쇼핑"
        searchBar.searchBarStyle = .minimal
    }

    private func configrueHierarchy() {
        view.addSubview(grayBackgroundView)
        view.addSubview(addButton)
        view.addSubview(textField)
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }

    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        grayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
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
    }
}
