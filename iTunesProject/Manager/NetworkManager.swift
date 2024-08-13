//
//  NetworkManager.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/11/24.
//

import Foundation
import RxSwift
import Alamofire

enum APIError: Error {
    case invaildURL
    case unknownResponse
    case status
}

final class NetworkManager {
    static let shared = NetworkManager()

    private init() { }

    func callAppStore(searchWord: String) -> Single<Result<AppResult, APIError>> {
        let url = "https://itunes.apple.com/search?term=\(searchWord)&country=KR&media=software"

        return Single.create { observer -> Disposable in
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AppResult.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        observer(.success(.failure(.invaildURL)))
                    }
                }
            return Disposables.create()
        }
    }
}
