//
//  BaseResponse.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation

//struct BaseResponse<T: Codable>: Codable {
//    let success: Bool
//    let status: Int
//    let message: String
//    let data: T?
//    
//    var isSuccess: Bool {
//        return success && status < 400
//    }
//}

struct BaseResponse<T: Codable>: Codable {
    let status: Int
    let code: String
    let message: String
    let data: T?
    
    var isSuccess: Bool {
        return status >= 200 && status < 300
    }
}

struct BaseResponseV2<T: Codable>: Codable {
    let status: Int
    let code: String
    let message: String
    let data: T?
    
    var isSuccess: Bool {
        return status >= 200 && status < 300
    }
}
