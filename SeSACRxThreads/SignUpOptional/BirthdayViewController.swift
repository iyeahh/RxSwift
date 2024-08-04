//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")

    let year = BehaviorRelay(value: 2024)
    let month = BehaviorRelay(value: 8)
    let day = BehaviorRelay(value: 1)

    let validation = BehaviorRelay(value: false)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        configureLayout()

        bind()
    }

    private func bind() {
        validation
            .bind(with: self) { owner, value in
                owner.infoLabel.text = value ? "가입 가능한 나이입니다" : "만 17세 이상만 가입 가능합니다"
                owner.infoLabel.textColor = value ? .blue : .red
                owner.nextButton.backgroundColor = value ? .blue : .lightGray
                owner.nextButton.isEnabled = value
            }
            .disposed(by: disposeBag)

        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.day, .month, .year], from: date)

                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)

                owner.validation.accept(owner.calculateAge())
            }
            .disposed(by: disposeBag)

        year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)

        month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)

        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)


        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.makeToast("가입되었습니다!")
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func calculateAge() -> Bool {
        var age: Int

        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        let str = dateFormatter.string(from: nowDate)
        let dateStringArray = str.split(separator: " ").map { Int($0)! }

        if dateStringArray[1] > month.value {
            age = dateStringArray[0] - year.value
        } else if dateStringArray[1] == month.value && dateStringArray[2] >= day.value {
            age = dateStringArray[0] - year.value
        } else {
            age = dateStringArray[0] - year.value - 1
        }

        return age >= 17
    }

    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
