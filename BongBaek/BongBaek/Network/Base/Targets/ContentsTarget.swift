//
//  ContentsTarget.swift
//  BongBaek
//
//  Created by 임재현 on 11/28/25.
//

import Foundation
import Moya

enum ContentsTarget {
    case getContentsHome
    case getContentsCategory(page: Int, category: String?)
    case getContentsDetail(contentId: String)
}

extension ContentsTarget: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: EnvironmentSetting.baseURL) else {
            fatalError("Invalid base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getContentsHome:
            return "/api/v1/content/home"
        case .getContentsCategory(let page, let category):
            var path = "/api/v1/content/list/\(page)"
            if let category = category {
                path += "?category=\(category)"
            }
            return path
        case .getContentsDetail(let contentId):
            return "/api/v1/content/\(contentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getContentsHome,.getContentsCategory ,.getContentsDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getContentsHome,.getContentsCategory ,.getContentsDetail:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        // 기본 헤더
        var headers = [
            "Content-Type": "application/json"
        ]
        
        // KeyChain에서 accessToken 가져오기
        if let accessToken = KeychainManager.shared.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
            print("Authorization 헤더 추가됨: Bearer \(accessToken.prefix(10))...")
        } else {
            print("AccessToken이 KeyChain에 없습니다")
        }
        
        return headers
    }
}
