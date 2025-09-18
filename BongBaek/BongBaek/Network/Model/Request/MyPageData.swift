//
//  MyPageData.swift
//  BongBaek
//
//  Created by hyunwoo on 9/4/25.
//

import Foundation

//MARK: - 회원정보 수정하기
struct UpdateProfileData: Codable,Hashable {
    let memberName: String
    let memberBirthday: String
    let memberIncome: String
}

extension UserDefaults {
    var memberName: String {
        return string(forKey: "memberName") ?? ""
    }
    
    var apiKey: String {
        return string(forKey: "apiKey") ?? ""
    }
    
    func clearApiKey() {
        removeObject(forKey: "apiKey")
    }
    
    func clearMemberName() {
        removeObject(forKey: "memberName")
    }
}
