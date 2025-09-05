//
//  Environment.swift
//  BongBaek
//
//  Created by 임재현 on 9/5/25.
//

import Foundation

struct EnvironmentSetting {
    enum APIEnvironment {
        case test
        case release
    }
    
    static let current: APIEnvironment = .test

    static var baseURL: String {
        switch current {
        case .test:
            return AppConfig.shared.baseURLForTest
        case .release:
            return  AppConfig.shared.baseURL
        }
    }
}
