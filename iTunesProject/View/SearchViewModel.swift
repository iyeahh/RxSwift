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
    }

    struct Output {
        let appList: Observable<[AppDetail]>
    }

    func transform(input: Input) -> Output {
        let movieList = PublishSubject<[AppDetail]>()

        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .flatMap { value in
                NetworkManager.shared.callAppStore(searchWord: value)
            }
            .subscribe(with: self) { owner, appResult in
                movieList.onNext(appResult.results)
            } onError: { owner, error in
                print("error \(error)")
            } onCompleted: { owner in
                print("complted")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)

        return Output(appList: movieList)
    }
}
