//
//  NetworkError.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI
import Foundation
import Combine

enum EventError: Error, LocalizedError {
    case apiError(String)
    case networkError
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .apiError(let message):
            return message
        case .networkError:
            return "네트워크 연결을 확인해주세요"
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다"
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다"
        }
    }
}
