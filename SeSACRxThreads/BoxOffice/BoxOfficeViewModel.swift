//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
    let disposeBag = DisposeBag()

    private var recentList = ["1", "a"]

    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }

    struct Output {
        let movieList: Observable<[DailyBoxOfficeList]>
        let recentList: BehaviorSubject<[String]>
    }

    func transform(input: Input) -> Output {
        let recentList = BehaviorSubject(value: recentList)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()

        input.recentText
            .subscribe(with: self) { owner, value in
                print("뷰모델 트랜스폼", value)
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)

        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText) //20240701
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 20240801
                }
                return intText
            }
            .map { return "\($0)" }
            .flatMap { value in
                NetworkManager.shared.callBoxOffice(date: value)
            }
            .subscribe(with: self) { owner, movie in
                dump(movie.boxOfficeResult.dailyBoxOfficeList)
                boxOfficeList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                print("error \(error)")
            } onCompleted: { owner in
                print("complted")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)

        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 글자 인식 \(value)")
            }
            .disposed(by: disposeBag)

        return Output(movieList: boxOfficeList,
                      recentList: recentList)
    }
}
