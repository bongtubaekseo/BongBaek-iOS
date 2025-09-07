//
//  MyPageTarget.swift
//  BongBaek
//
//  Created by hyunwoo on 9/3/25.
//
import Foundation
import Moya

enum MyPageTarget: TargetType {
    case getProfile
    case updateProfile(profileData : UpdateProfileData)
}

extension MyPageTarget {
    var baseURL: URL {
        guard let url = URL(string: EnvironmentSetting.baseURL) else {
            fatalError("Invalid base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getProfile:
            return "/api/v1/member/profile"
        case .updateProfile:
            return "/api/v1/member/profile"
        }
    }
    
    var method: Moya.Method{
        switch self{
        case .getProfile:
            return .get
        
        case .updateProfile:
            return .put
        }
    }
    
    var task: Moya.Task{
        switch self{
        case .getProfile:
            return .requestPlain
        
        case .updateProfile(let profileData):
            return .requestJSONEncodable(profileData)
        }
    }
    
    var headers: [String : String]?{
        var headers = [
            "Content-Type": "application/json"
        ]
        
        if let accessToken = KeychainManager.shared.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
            print("Authorization 헤더 추가됨: Bearer \(accessToken.prefix(10))...")
        } else {
            print("AccessToken이 KeyChain에 없습니다")
        }
        
        return headers
    }
}


