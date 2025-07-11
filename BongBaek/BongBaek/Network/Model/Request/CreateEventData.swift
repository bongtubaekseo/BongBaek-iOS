//
//  CreateEventData.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//


//MARK: - 경조사 생성하기
struct CreateEventData: Codable {
    let hostInfo: HostInfo
    let eventInfo: CreateEventInfo
    let locationInfo: LocationDetailInfo
    let highAccuracy: HighAccuracyInfo
}

struct CreateEventInfo: Codable {
    let eventCategory: String
    let relationship: String
    let cost: Int
    let isAttend: Bool
    let eventDate: String
}

struct HighAccuracyInfo: Codable {
    let contactFrequency: Int
    let meetFrequency: Int
}


//MARK: - 경조사 수정하기
struct UpdateEventData: Codable {
    let hostInfo: HostInfo
    let eventInfo: UpdateEventInfo
    let locationInfo: LocationDetailInfo
}

struct UpdateEventInfo: Codable {
    let eventCategory: String
    let relationship: String
    let cost: Int
    let isAttend: Bool
    let eventDate: String
    let note: String 
}
