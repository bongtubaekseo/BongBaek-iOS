//
//  AuthService.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import Combine
import Moya

class AuthService: AuthServiceProtocol {

    private let networkService: NetworkService<AuthTarget>
    init(networkService: NetworkService<AuthTarget>) {
        self.networkService = networkService
    }
    
    func kakaoLogin(accessToken: String) -> AnyPublisher<KaKaoLoginResponse, Error> {
        return networkService.request(
            .kakaoLogin(accessToken: accessToken),
            responseType: KaKaoLoginResponse.self
        )
    }
    
    func appleLogin(idToken: String) -> AnyPublisher<AppleLoginResponse, any Error> {
        return networkService.request(
            .appleLogin(idToken: idToken),
            responseType: AppleLoginResponse.self
        )
    }
    
    func signUp(memberInfo: MemberInfo) -> AnyPublisher<SignUpResponse, Error> {
        return networkService.request(
            .signUp(memberInfo: memberInfo),
            responseType: SignUpResponse.self
        )
    }
    
    func retryToken() -> AnyPublisher<RefreshTokenResponse, Error> {
        return networkService.request(
            .retryToken,
            responseType: RefreshTokenResponse.self
        )
    }
    
    func logout() -> AnyPublisher<LogoutResponse, any Error> {
        return networkService.request(
            .logout,
            responseType: LogoutResponse.self
        )
    }
}

