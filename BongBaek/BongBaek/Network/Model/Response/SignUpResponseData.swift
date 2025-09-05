//
//  SignUpResponseData.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation

typealias SignUpResponse = BaseResponse<AuthData>
typealias KaKaoLoginResponse = BaseResponse<AuthData>
typealias AppleLoginResponse = BaseResponse<AppleAuthData>
typealias RefreshTokenResponse = BaseResponse<TokenInfo>

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

