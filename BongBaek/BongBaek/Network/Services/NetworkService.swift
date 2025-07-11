//
//  NetworkService.swift
//  BongBaek
//
//  Created by 임재현 on 7/10/25.
//

import Moya
import Combine
import CombineMoya
import Foundation

class NetworkService: NetworkServiceProtocol {
    
    private let provider: MoyaProvider<AuthTarget>
    
    init(provider: MoyaProvider<AuthTarget> = MoyaProvider<AuthTarget>()) {
        self.provider = provider
    }
    
    func request<T: Codable>(_ target: AuthTarget, responseType: T.Type) -> AnyPublisher<T, Error> {
        
        return provider.requestPublisher(target)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
