//
//  NetworkServiceProtocol.swift
//  BongBaek
//
//  Created by 임재현 on 7/10/25.
//

import SwiftUI
import Combine

protocol NetworkServiceProtocol {
    func request<T: Codable>(_ target: String, responseType: T.Type) -> AnyPublisher<T, Error>
}


