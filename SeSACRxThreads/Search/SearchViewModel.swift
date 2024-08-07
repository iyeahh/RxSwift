//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/7/24.
//

import Foundation
import RxSwift

final class SearchViewModel {
    let inputQuery = PublishSubject<String>()
    let inputSearchButtonTap = PublishSubject<Void>()

    private var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]

    lazy var list = BehaviorSubject(value: data)

    let disposeBag = DisposeBag()

    init() {
        inputQuery
            .subscribe(with: self) { owner, value in
                print("inputQuery 변경됨: \(value)")
            }
            .disposed(by: disposeBag)

        inputQuery
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.list.onNext(result)
            }
            .disposed(by: disposeBag)
    }
}

