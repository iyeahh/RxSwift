//
//  AppResult.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/11/24.
//

import Foundation

struct AppResult: Decodable {
    let results: [AppDetail]
}

struct AppDetail: Decodable {
    let screenshotUrls: [String]
    let artworkUrl100: String
    let genres: [String]
    let sellerName: String
    let trackName: String
    let averageUserRating: Double
}
