//
//  MemberInfo.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI

struct MemberInfo: Codable {
    let kakaoId: String?
    let appleId: String?
    let oauthId: String?
    let memberName: String
    let memberBirthday: String
    let memberIncome: String
    let oauthProvider: String
    
    enum CodingKeys: String, CodingKey {
        case kakaoId
        case appleId
        case memberName
        case memberBirthday
        case memberIncome
        case oauthId
        case oauthProvider
    }
    
    init(kakaoId: String?, appleId: String? = nil,oauthId: String?, memberName: String, memberBirthday: String, memberIncome: String,oauthProvider: String) {
        self.kakaoId = kakaoId
        self.appleId = appleId
        self.oauthId = oauthId
        self.memberName = memberName
        self.memberBirthday = memberBirthday
        self.memberIncome = memberIncome
        self.oauthProvider = oauthProvider
    }
}
