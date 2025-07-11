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

class NetworkService<Target: TargetType>: NetworkServiceProtocol {
    
    private let provider: MoyaProvider<Target>
    
    init(provider: MoyaProvider<Target> = MoyaProvider<Target>()) {
        self.provider = provider
    }
    
    func request<T: Codable>(_ target: Target, responseType: T.Type) -> AnyPublisher<T, Error> {
        
        return provider.requestPublisher(target)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
