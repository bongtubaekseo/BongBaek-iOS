//
//  AuthError.swift
//  BongBaek
//
//  Created by 임재현 on 7/14/25.
//

import Foundation

enum AuthError: Error {
    case keychainError
    case tokenNotFound
    case tokenExpired
    case networkError
    case loginFailed
    case logoutFailed
    case notLoggedIn
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .keychainError: return "키체인 저장/읽기 실패"
        case .tokenNotFound: return "토큰이 존재하지 않습니다"
        case .tokenExpired: return "토큰이 만료되었습니다"
        case .networkError: return "네트워크 오류"
        case .loginFailed: return "로그인에 실패했습니다."
        case .logoutFailed: return "로그아웃에 실패했습니다."
        case .notLoggedIn: return "로그인이 필요합니다"
        case .invalidData: return "유효하지 않은 데이터"
            
        }
    }
}
