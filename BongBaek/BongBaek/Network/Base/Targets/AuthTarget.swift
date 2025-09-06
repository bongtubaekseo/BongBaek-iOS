//
//  AuthTarget.swift
//  BongBaek
//
//  Created by 임재현 on 7/10/25.
//

import Moya
import Foundation


struct LoginRequest: Codable {
    let accessToken: String
}

enum AuthTarget {
    case kakaoLogin(accessToken: String)
    case appleLogin(idToken: String)
    case signUp(memberInfo: MemberInfo)
    case retryToken
    case logout
    case withdraw(reason:WithdrawRequestData)
}

extension AuthTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: EnvironmentSetting.baseURL) else {
            fatalError("Invalid base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            "/api/v1/oauth/kakao"
        case .signUp:
            "/api/v1/member/profile"
        case .retryToken:
            "/api/v1/member/reissue"
        case .appleLogin:
            "/api/v1/oauth/apple"
        case .logout:
            "/api/v1/member/logout"
        case .withdraw:
            "/api/v1/member/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .signUp,. retryToken, .appleLogin, .logout, .withdraw: .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let accessToken):
            let loginRequest = LoginRequest(accessToken: accessToken)
            return .requestJSONEncodable(loginRequest)
            
        case .signUp(let memberInfo):
            return .requestJSONEncodable(memberInfo)
            
        case .retryToken, .logout:
            return .requestPlain
            
        case .appleLogin(let idToken):
            let loginRequest = LoginRequest(accessToken: idToken)
            return .requestJSONEncodable(loginRequest)
        case .withdraw(let reason):
            return .requestJSONEncodable(reason)
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
