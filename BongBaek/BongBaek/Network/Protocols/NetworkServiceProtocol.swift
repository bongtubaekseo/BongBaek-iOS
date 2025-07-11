//
//  NetworkServiceProtocol.swift
//  BongBaek
//
//  Created by 임재현 on 7/10/25.
//

import SwiftUI
import Combine
import Moya

protocol NetworkServiceProtocol {
    associatedtype Target: TargetType
    func request<T: Codable>(_ target: Target, responseType: T.Type) -> AnyPublisher<T, Error>
}


