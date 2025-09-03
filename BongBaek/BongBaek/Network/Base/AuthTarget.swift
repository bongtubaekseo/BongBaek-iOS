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
}

extension AuthTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: AppConfig.shared.baseURL) else {
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .signUp,. retryToken, .appleLogin, .logout: .post
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .kakaoLogin, .appleLogin, .logout:
            return [
                "Content-Type": "application/json"
            ]
        case .signUp(let memberInfo):
            return [
                "Content-Type": "application/json"
            ]
        case .retryToken:
            let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(refreshToken)"
            ]
        }
    }
}
