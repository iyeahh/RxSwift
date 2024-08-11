//
//  NetworkManager.swift
//  SeSACRxThreads
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

    func callBoxOffice(date: String) -> Observable<Movie> {
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=c17a9fadaa431c6ca35748a4e077c3bc&targetDt=\(date)"

        let result = Observable<Movie>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.invaildURL)
                return Disposables.create()
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.status)
                    return
                }

                if let data = data,
                   let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(appData)
                    // ⭐️ complete를 만나게 해서 dispose 되도록 하기
                    observer.onCompleted()
                } else {
                    print("응답은 왔으나 디코딩 실패")
                    observer.onError(APIError.unknownResponse)
                }
            }.resume()

            return Disposables.create()
        }.debug("박스오피스 조회") // 검색을 할 때마다 구독을 함 - Stream이 해제되지 않고 유지
        return result
    }
}
