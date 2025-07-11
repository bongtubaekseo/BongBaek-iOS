//
//  SignUpResponseData.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation

typealias SignUpResponse = BaseResponse<SignUpResponseData>

struct SignUpResponseData: Codable {
    let token: TokenInfo
    let isCompletedSignUp: Bool
    let kakaoId: Int
    let kakaoAccessToken: String
}

struct TokenInfo: Codable {
    let accessToken: String
    let refreshToken: String
}
