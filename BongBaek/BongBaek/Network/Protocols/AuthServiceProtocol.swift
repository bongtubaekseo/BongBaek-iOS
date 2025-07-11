//
//  AuthServiceProtocol.swift
//  BongBaek
//
//  Created by 임재현 on 7/10/25.
//

import Moya
import Combine

protocol AuthServiceProtocol {
    func login(accessToken: String) -> AnyPublisher<LoginResponse, Error>
    func signUp(memberInfo: MemberInfo) -> AnyPublisher<SignUpResponse, Error>
    func retryToken() -> AnyPublisher<RefreshTokenResponse, Error>
}
