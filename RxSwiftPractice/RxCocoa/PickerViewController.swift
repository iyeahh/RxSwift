//
//  PickerViewController.swift
//  RxSwiftPractice
//
//  Created by Bora Yang on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PickerViewController: UIViewController {
    private let simplePickerView = UIPickerView()
    private let simpleLabel = UILabel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        configureView()
        setPickerView()
        practiceJust()
        practiceOf()
        practiceFrom()
        practiceTake()
    }

    private func configureView() {
        view.backgroundColor = .white

        view.addSubview(simplePickerView)
        view.addSubview(simpleLabel)

        simplePickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(100)
        }

        simpleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(simplePickerView.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
    }

    private func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])

        items.bind(to: simplePickerView.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: disposeBag)

        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func practiceJust() {
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]

        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }

    private func practiceOf() {
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]

        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
    }

    private func practiceFrom() {
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]

        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }

    private func practiceTake() {
        Observable.repeatElement("Jack")
            .take(5)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
    }
}
