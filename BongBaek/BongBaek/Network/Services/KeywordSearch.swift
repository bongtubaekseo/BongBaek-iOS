//
//  KeywordSearch.swift
//  BongBaek
//
//  Created by 임재현 on 7/9/25.
//

import SwiftUI
import Alamofire


/// TextField 에 장소 검색시 해당 String 값을 쿼리로 parameter 에 담아서 전송후, 카카오에서 제공하는 해당 검색어 기반 위치 정보를 받아오는 객체
class KeyWordSearch: ObservableObject {
    @Published var searchResults: [KLDocument] = []
    let APIKEY = Bundle.main.infoDictionary?["KAKAOAPIKEY"] as? String ?? ""
    
    @Published var query = "" {
        didSet {
            if query.isEmpty {
                searchResults = []
            } else {
                search()
            }
        }
    }
    
    func search() {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(APIKEY)"
        ]
        let parameters: [String: Any] = [
            "query": query,
            "x": 126.97806,
            "y": 37.56667,
            "sort": "distance"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: KakaoSearchResponse.self) { response in
                switch response.result {
                case .success(let kakaoResponse):
                    print("성공: \(kakaoResponse)")
                    
                    // 검색 결과를 배열에 추가
                    self.searchResults.append(contentsOf: kakaoResponse.documents)
                    
                case .failure(let error):
                    print("에러: \(error.localizedDescription)")
                    
                    // 디버깅을 위한 상세 에러 정보
                    if let data = response.data {
                        print("응답 데이터: \(String(data: data, encoding: .utf8) ?? "없음")")
                    }
                }
            }
    }
 
}
