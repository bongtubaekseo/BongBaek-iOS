//
//  AuthServiceProtocol.swift
//  BongBaek
//
//  Created by 임재현 on 7/10/25.
//

import Moya
import Combine

protocol AuthServiceProtocol {
    func kakaoLogin(accessToken: String) -> AnyPublisher<KaKaoLoginResponse, Error>
    func appleLogin(idToken: String) -> AnyPublisher<AppleLoginResponse, Error>
    func signUp(memberInfo: MemberInfo) -> AnyPublisher<SignUpResponse, Error>
    func retryToken() -> AnyPublisher<RefreshTokenResponse, Error>
    func logout() -> AnyPublisher<LogoutResponse, Error>
    func withdraw(reason: WithdrawRequestData) -> AnyPublisher<WithdrawResponse, Error>
}
