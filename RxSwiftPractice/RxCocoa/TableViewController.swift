//
//  TableViewController.swift
//  RxSwiftPractice
//
//  Created by Bora Yang on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class TableViewController: UIViewController {
    private let simpleTableView = UITableView()
    private let simpleLabel = UILabel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        configureView()
        setTableView()
    }

    private func configureView() {
        view.backgroundColor = .white

        view.addSubview(simpleTableView)
        view.addSubview(simpleLabel)

        simpleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }

        simpleTableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(simpleLabel.snp.top).offset(50)
        }
    }

    private func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
            .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)

        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
