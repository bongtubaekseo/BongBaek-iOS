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
    
    func login(accessToken: String) -> AnyPublisher<String, Error> {
        return networkService.request(
            .login(accessToken: accessToken),
            responseType: String.self 
        )
    }
    
    func signUp(memberInfo: MemberInfo) -> AnyPublisher<String, Error> {
        return networkService.request(
            .signUp(memberInfo: memberInfo),
            responseType: String.self
        )
    }
    
    func retryToken() -> AnyPublisher<String, Error> {
        return networkService.request(
            .retryToken,
            responseType: String.self
        )
    }
}

