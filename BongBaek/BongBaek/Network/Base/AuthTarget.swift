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
    case login(accessToken: String)
    case signUp(memberInfo: MemberInfo)
    case retryToken
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
        case .login:
            "/api/v1/oauth/kakao"
        case .signUp:
            "/api/v1/member/profile"
        case .retryToken:
            "/api/v1/member/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signUp,. retryToken: .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let accessToken):
            let loginRequest = LoginRequest(accessToken: accessToken)
            return .requestJSONEncodable(loginRequest)
            
        case .signUp(let memberInfo):
            return .requestJSONEncodable(memberInfo)
            
        case .retryToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(let accessToken):
            return [
                "Content-Type": "application/json"
            ]
        case .signUp(let memberInfo):
            return [
                "Content-Type": "application/json",
                "kakaoId" : memberInfo.kakaoID,
                "appleId" : memberInfo.appleID ?? "",
                "memberBirthday": memberInfo.memberBirthday,
                "memberIncome" : memberInfo.memberIncome
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
