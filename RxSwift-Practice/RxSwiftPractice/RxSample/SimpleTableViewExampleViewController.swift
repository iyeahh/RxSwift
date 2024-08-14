//
//  SimpleTableViewExampleViewController.swift
//  RxSwiftPractice
//
//  Created by Bora Yang on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SimpleTableViewExampleViewController : UIViewController, UITableViewDelegate {
    private let tableView = UITableView()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )

        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { value in
                self.presentAlert("Tapped `\(value)`")
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                self.presentAlert("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }

    private func presentAlert(_ message: String) {
        let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        present(alertView, animated: true, completion: nil)
    }

    private func configureView() {
        view.addSubview(tableView)

        view.backgroundColor = .white

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
