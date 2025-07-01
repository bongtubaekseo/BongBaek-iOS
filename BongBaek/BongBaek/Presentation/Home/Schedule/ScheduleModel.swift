//
//  ScheduleModel.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//

import SwiftUI

struct ScheduleModel: Identifiable {
    let id =  UUID()
    let type: String
    let relation: String
    let name: String
    let money: String
    let location: String
    let date: String
}

let scheduleDummy: [ScheduleModel] = [
    ScheduleModel(type: "결혼식", relation: "친구", name: "강현우", money: "50,000원", location: "관악대로 275번길 42", date: "2025.05.01(목)"),
    ScheduleModel(type: "돌잔치", relation: "직장", name: "전지영", money: "100,000원", location: "중구 필동로1길 30", date: "2025.07.19(토)"),
    ScheduleModel(type: "생일", relation: "선후배", name: "임재현", money: "30,000원", location: "강남구 테헤란로 30 웨딩홀", date: "2027.10.01(월)")
]
