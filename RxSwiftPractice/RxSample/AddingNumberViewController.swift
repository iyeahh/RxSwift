//
//  AddingNumberViewController.swift
//  RxSwiftPractice
//
//  Created by Bora Yang on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class AddingNumberViewController: UIViewController {
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    private let result = UILabel()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }

    private func configureView() {
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(result)

        view.backgroundColor = .white
        number1.backgroundColor = .lightGray
        number2.backgroundColor = .lightGray
        number3.backgroundColor = .lightGray
        result.backgroundColor = .lightGray

        number1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
        }

        number2.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.top.equalTo(number1.snp.bottom).offset(10)
        }

        number3.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.top.equalTo(number2.snp.bottom).offset(10)
        }

        result.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.top.equalTo(number3.snp.bottom).offset(10)
        }
    }
}
