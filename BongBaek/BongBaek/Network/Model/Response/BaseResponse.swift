//
//  BaseResponse.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let success: Bool
    let status: Int
    let message: String
    let data: T?
    
    var isSuccess: Bool {
        return success && status < 400
    }
}
