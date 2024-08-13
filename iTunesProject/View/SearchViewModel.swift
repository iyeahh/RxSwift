//
//  SearchViewModel.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    let disposeBag = DisposeBag()

    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let cellTap: ControlEvent<AppDetail>
    }

    struct Output {
        let appList: Observable<[AppDetail]>
        let cellTap: ControlEvent<AppDetail>
    }

    func transform(input: Input) -> Output {
        let appList = PublishSubject<[AppDetail]>()

        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .flatMap { value in
                NetworkManager.shared.callAppStore(searchWord: value)
            }
            .subscribe(with: self) { owner, appResult in
                switch appResult {
                case .success(let value):
                    appList.onNext(value.results)
                case .failure(let error):
                    print("에러 발생")
                }
            } onError: { owner, error in
                print("error \(error)")
            } onCompleted: { owner in
                print("complted")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)

        return Output(appList: appList, cellTap: input.cellTap)
    }
}
