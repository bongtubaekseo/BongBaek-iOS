//
//  AuthService.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import Combine

class AuthService: AuthServiceProtocol {

    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
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

