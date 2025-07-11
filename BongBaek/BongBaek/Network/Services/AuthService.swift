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
    
    func login(accessToken: String) -> AnyPublisher<LoginResponse, Error> {
        return networkService.request(
            .login(accessToken: accessToken),
            responseType: LoginResponse.self
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
}

