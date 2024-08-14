//
//  SimpleValidationViewController.swift
//  RxSwiftPractice
//
//  Created by Bora Yang on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

final class SimpleValidationViewController : UIViewController {

    private let usernameOutlet = UITextField()
    private let usernameValidOutlet = UILabel()

    private let passwordOutlet = UITextField()
    private let passwordValidOutlet = UILabel()

    private let doSomethingOutlet = UIButton()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"

        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)

        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    private func configureView() {
        view.addSubview(usernameValidOutlet)
        view.addSubview(usernameOutlet)
        view.addSubview(passwordValidOutlet)
        view.addSubview(passwordOutlet)
        view.addSubview(doSomethingOutlet)

        view.backgroundColor = .white
        usernameOutlet.backgroundColor = .lightGray
        usernameValidOutlet.backgroundColor = .lightGray
        passwordValidOutlet.backgroundColor = .lightGray
        passwordOutlet.backgroundColor = .lightGray
        doSomethingOutlet.backgroundColor = .lightGray

        usernameOutlet.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }

        usernameValidOutlet.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(usernameOutlet.snp.bottom).offset(10)
        }

        passwordOutlet.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(usernameValidOutlet.snp.bottom).offset(10)
        }

        passwordValidOutlet.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(passwordOutlet.snp.bottom).offset(10)
        }

        doSomethingOutlet.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(passwordValidOutlet.snp.bottom).offset(10)
        }
    }
}

