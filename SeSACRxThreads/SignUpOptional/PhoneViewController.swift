//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()

    let disposeBag = DisposeBag()
    let viewModel = PhoneViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        phoneTextField.text = "010"
        bind()
    }

    private func bind() {
        let input = PhoneViewModel.Input(
            text: phoneTextField.rx.text,
            tap: nextButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.descriptionText.bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        output.validation.bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)

        output.validation.bind(with: self) { owner, value in
            owner.nextButton.backgroundColor = value ? .systemPink : .lightGray
        }
        .disposed(by: disposeBag)

        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }    }

}
