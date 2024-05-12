//
//  APIService.swift
//  MukApp
//
//  Created by Kang on 10/28/23.
//

import UIKit
import Alamofire

protocol APIServiceType {
    func performRequest(keyword: String, completion: @escaping ([Document]?) -> Void)
    func fetchAPI(urlString: String, headers : HTTPHeaders, parameters: [String: Any], completion: @escaping ([Document]?) -> Void)
}

// MARK: - api 결과 데이터 구조체
struct apiResult: Codable {
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let address: String?
    let group: String?
    let phone: String?
    let placeName: String?
    let placeURL: String?
    let roadAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
        case group = "category_name"
        case phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddress = "road_address_name"
    }
}

// MARK: - APIService 클래스
class APIService: APIServiceType {
    // 싱글톤
    static let shared = APIService()
    
    func performRequest(keyword: String, completion: @escaping ([Document]?) -> Void) {
        
        var resultArray: [Document] = []
        
        // let apiKeyString: String = "aae19e621a75ab0a39bf676555887e27"
        
        guard let apiKeyString = Bundle.main.kakaoApiKey else {
            print("API 키를 로드하지 못했습니다.")
            return
        }
        
        let resUrlString: String = "https://dapi.kakao.com/v2/local/search/keyword.json?category_group_code=CE7"
        let cafeUrlString: String = "https://dapi.kakao.com/v2/local/search/keyword.json?category_group_code=FD6"
        
        // 헤더
        let headers : HTTPHeaders = [
            "Authorization": "KakaoAK \(apiKeyString)"
        ]
        
        let parameters: [String: Any] = [
            "query": keyword,
            "page": 1,
            "size": 15
        ]
        
        // DispatchGroup 비동기 처리 병렬 사용
        let group = DispatchGroup()
        
        // 레스토랑 카테고리 검색
        group.enter()
        fetchAPI(urlString: resUrlString, headers: headers, parameters: parameters) { result in
            // 옵셔널 바인딩
            guard let result = result else { return }
            resultArray.append(contentsOf: result)
            group.leave()
        }
        
        // 카페 카테고리 검색
        group.enter()
        fetchAPI(urlString: cafeUrlString, headers: headers, parameters: parameters) { result in
            // 옵셔널 바인딩
            guard let result = result else { return }
            resultArray.append(contentsOf: result)
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            // fetch 완료 후 데이터 전달
            completion(resultArray)
        }
    }
    
    // fetch 실행
    func fetchAPI(urlString: String, headers : HTTPHeaders, parameters: [String: Any], completion: @escaping ([Document]?) -> Void) {
        AF.request(urlString,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success:
                // 데이터 문자열로 변환
                let resultString = String(data: response.data!, encoding: .utf8)
                
                // JSON 문자열을 Data로 변환
                if let jsonData = resultString?.data(using: .utf8) {
                    do {
                        // 디코드
                        let decoder = JSONDecoder()
                        let resultArray = try decoder.decode(apiResult.self, from: jsonData)
                        completion(resultArray.documents)
                    } catch {
                        completion(nil)
                        return
                    }
                } else {
                    completion(nil)
                    return
                }
            case .failure(let error):
                print(error)
                completion(nil)
                return
            }
        }
    }
}

extension Bundle {
    var kakaoApiKey: String? {
        return infoDictionary?["KAKAO_API_KEY"] as? String
    }
}
