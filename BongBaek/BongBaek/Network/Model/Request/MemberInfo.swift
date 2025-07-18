//
//  MemberInfo.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI

struct MemberInfo: Codable {
    let kakaoId: Int
    let appleId: Int?
    let memberName: String
    let memberBirthday: String
    let memberIncome: String
    
    enum CodingKeys: String, CodingKey {
        case kakaoId
        case appleId
        case memberName
        case memberBirthday
        case memberIncome
    }
    
    init(kakaoId: Int, appleId: Int? = nil, memberName: String, memberBirthday: String, memberIncome: String) {
        self.kakaoId = kakaoId
        self.appleId = appleId
        self.memberName = memberName
        self.memberBirthday = memberBirthday
        self.memberIncome = memberIncome
    }
}
