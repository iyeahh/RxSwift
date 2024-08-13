//
//  NetworkManager.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/11/24.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invaildURL
    case unknownResponse
    case status
}

final class NetworkManager {
    static let shared = NetworkManager()

    private init() { }

    func callAppStore(searchWord: String) -> Observable<AppResult> {
        let url = "https://itunes.apple.com/search?term=\(searchWord)&country=KR&media=software"

        let result = Observable<AppResult>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.invaildURL)
                return Disposables.create()
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    observer.onError(APIError.unknownResponse)
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.status)
                    return
                }

                if let data = data,
                   let appData = try? JSONDecoder().decode(AppResult.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted()
                } else {
                    print("응답은 왔으나 디코딩 실패")
                    observer.onError(APIError.unknownResponse)
                }
            }.resume()
            return Disposables.create()
        }
        return result
    }
}
