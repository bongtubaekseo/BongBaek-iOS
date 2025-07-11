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
    

    lazy var authProvider: MoyaProvider<AuthTarget> = {
        return MoyaProvider<AuthTarget>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
    }()
    
    lazy var eventProvider: MoyaProvider<EventsTarget> = {
        return MoyaProvider<EventsTarget>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
    }()

    
    lazy var authNetworkService: NetworkService<AuthTarget> = NetworkService(
        provider: authProvider
    )
    
    lazy var eventNetworkService: NetworkService<EventsTarget> = NetworkService(
        provider: eventProvider
    )
    
    lazy var authService: AuthServiceProtocol = AuthService(
        networkService: authNetworkService
    )
    
    lazy var eventService: EventServiceProtocol = EventService(
        networkService: eventNetworkService
    )
}
