//
//  MyPageData.swift
//  BongBaek
//
//  Created by hyunwoo on 9/4/25.
//

//MARK: - 회원정보 수정하기
struct UpdateProfileData: Codable {
    let memberName: String
    let memberBirthday: String
    let memberIncome: String
}
