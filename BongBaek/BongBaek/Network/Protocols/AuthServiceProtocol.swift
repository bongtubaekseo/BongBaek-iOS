//
//  AuthServiceProtocol.swift
//  BongBaek
//
//  Created by 임재현 on 7/10/25.
//

import Moya
import Combine

protocol AuthServiceProtocol {
    func login() -> AnyPublisher<String, Error>
    func signUp() -> AnyPublisher<String, Error>
    func retryToken() -> AnyPublisher<String, Error>
}
