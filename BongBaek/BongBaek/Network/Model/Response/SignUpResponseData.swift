//
//  SignUpResponseData.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation

typealias SignUpResponse = BaseResponse<AuthResponseData>
typealias KaKaoLoginResponse = BaseResponse<AuthData>
typealias AppleLoginResponse = BaseResponse<AppleAuthData>
typealias RefreshTokenResponse = BaseResponse<TokenInfo>
typealias LogoutResponse = BaseResponse<EmptyData>
typealias WithdrawResponse = BaseResponse<EmptyData>

struct AuthData: Codable {
    let token: TokenInfo?
    let isCompletedSignUp: Bool
    let kakaoId: String
    let kakaoAccessToken: String?
}

struct AppleAuthData: Codable {
    let name: String?
    let token: TokenInfo?
    let isCompletedSignUp: Bool
    let appleId: String
}

struct TokenInfo: Codable {
    let accessToken: TokenDetails
    let refreshToken: TokenDetails
}

struct TokenDetails: Codable {
    let token: String
    let expiredAt: Int
    let calculatedExpiredAt: Int
}


struct AuthResponseData: Codable {
    let token: TokenInfo?
    let isCompletedSignUp: Bool
    
    let kakaoId: String?
    let kakaoAccessToken: String?
    let appleId: String?
    let name: String?
    let apiKey: String?
}
