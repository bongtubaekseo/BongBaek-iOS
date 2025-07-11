//
//  DIContainer.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Moya

class DIContainer {
    static let shared = DIContainer()
    private init() {}
    
    lazy var authMoyaProvider: MoyaProvider<AuthTarget> = {
        return MoyaProvider<AuthTarget>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
    }()
    
    lazy var networkService: NetworkServiceProtocol = NetworkService(
        provider: authMoyaProvider
    )
    
    lazy var authService: AuthServiceProtocol = AuthService(
        networkService: networkService
    )
}
