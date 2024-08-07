//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel {
    let disposeBag = DisposeBag()

    var data = [
        ShoppingItem(isCheck: true, todo: "그립톡 구매하기", isLike: true),
        ShoppingItem(isCheck: false, todo: "사이다 구매", isLike: false),
        ShoppingItem(isCheck: false, todo: "아이패드 케이스 최저가 알아보기", isLike: true),
        ShoppingItem(isCheck: false, todo: "양말", isLike: true)
    ]

    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let itemDeleted: ControlEvent<IndexPath>
        let itemSelected: ControlEvent<IndexPath>
        let addButtonTapped: ControlEvent<Void>
        let text: ControlProperty<String?>
        let isChcekTap: PublishSubject<Int>
        let isLikeTap: PublishSubject<Int>
    }

    struct Output {
        let list: BehaviorRelay<[ShoppingItem]>
        let itemSelected: ControlEvent<IndexPath>
    }

    func transform(input: Input) -> Output {
        let list = BehaviorRelay(value: data)

        input.searchButtonClicked
            .withLatestFrom(input.searchText.orEmpty)
            .bind(with: self) { owner, value in
                let array = owner.data.filter { $0.todo.contains(value) }
                list.accept(array)
            }
            .disposed(by: disposeBag)

        input.searchText
            .orEmpty
            .bind(with: self) { owner, value in
                let array = value.isEmpty ? owner.data : owner.data.filter { $0.todo.contains(value) }
                list.accept(array)
            }
            .disposed(by: disposeBag)

        input.itemDeleted
            .bind(with: self) { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)


        input.addButtonTapped
            .withLatestFrom(input.text.orEmpty)
            .bind(with: self) { owner, value in
                owner.data.append(ShoppingItem(isCheck: false, todo: value, isLike: false))
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)

        input.isLikeTap
            .bind(with: self) { owner, value in
                owner.data[value].isLike.toggle()
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)

        input.isChcekTap
            .bind(with: self) { owner, value in
                owner.data[value].isCheck.toggle()
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)

        return Output(list: list, itemSelected: input.itemSelected)
    }
}
