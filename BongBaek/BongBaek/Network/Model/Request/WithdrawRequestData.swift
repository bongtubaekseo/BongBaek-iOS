//
//  WithdrawRequestData.swift
//  BongBaek
//
//  Created by 임재현 on 9/5/25.
//

import Foundation

struct WithdrawRequestData: Codable {
    let withdrawalReason: String
    let detail: String?
}
