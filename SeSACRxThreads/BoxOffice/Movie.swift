//
//  Movie.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/11/24.
//

import Foundation

struct Movie: Decodable {
    let boxOfficeResult: DailyBoxOfficeResult
}

struct DailyBoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let movieNm: String
    let openDt: String
}
