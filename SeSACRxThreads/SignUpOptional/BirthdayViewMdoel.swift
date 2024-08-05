//
//  BirthdayViewMdoel.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewMdoel {
    let disposeBag = DisposeBag()

    struct Input {
        let date: ControlProperty<Date>
        let tap: ControlEvent<Void>
    }

    struct Output {
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let validation: BehaviorRelay<Bool>
        let tap: ControlEvent<Void>
    }

    func transform(input: Input) -> Output {
        let year = BehaviorRelay(value: 2024)
        let month = BehaviorRelay(value: 8)
        let day = BehaviorRelay(value: 1)
        let validation = BehaviorRelay(value: false)

        input.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.day, .month, .year], from: date)

                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)

                validation.accept(owner.calculateAge(year: year.value, month: month.value, day: day.value))
            }
            .disposed(by: disposeBag)

        return Output(year: year, month: month, day: day, validation: validation, tap: input.tap)
    }


    private func calculateAge(year: Int, month: Int, day: Int) -> Bool {
        var age: Int

        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        let str = dateFormatter.string(from: nowDate)
        let dateStringArray = str.split(separator: " ").map { Int($0)! }

        if dateStringArray[1] > month {
            age = dateStringArray[0] - year
        } else if dateStringArray[1] == month && dateStringArray[2] >= day {
            age = dateStringArray[0] - year
        } else {
            age = dateStringArray[0] - year - 1
        }

        return age >= 17
    }
}
