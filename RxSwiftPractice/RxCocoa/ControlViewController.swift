//
//  ControlViewController.swift
//  RxSwiftPractice
//
//  Created by Bora Yang on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class ControlViewController: UIViewController {
    private let simpleSwitch = UISwitch()
    private let signName = UITextField()
    private let signEmail = UITextField()
    private let simpleLabel = UILabel()
    private let signButton = UIButton()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        configureView()
        setSwitch()
        setSign()
    }

    private func configureView() {
        view.backgroundColor = .white
        signButton.backgroundColor = .blue

        view.addSubview(simpleSwitch)
        view.addSubview(signName)
        view.addSubview(signEmail)
        view.addSubview(simpleLabel)
        view.addSubview(signButton)

        simpleSwitch.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
        }

        signName.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(50)
            make.top.equalTo(simpleSwitch.snp.bottom).offset(30)
        }

        signEmail.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(50)
            make.top.equalTo(signName.snp.bottom).offset(30)
        }

        simpleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(50)
            make.top.equalTo(signEmail.snp.bottom).offset(30)
            make.height.equalTo(50)
        }

        signButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(50)
            make.top.equalTo(simpleLabel.snp.bottom).offset(30)
        }
    }

    private func setSwitch() {
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }

    private func setSign() {
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2)입니다"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)

        signName.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)

        signEmail.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signButton.rx.isHidden)
            .disposed(by: disposeBag)

        signButton.rx.tap
            .subscribe { _ in
                print("버튼 눌림")
            }
            .disposed(by: disposeBag)
    }
}
