//
//  EventHomeResponse.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation

typealias EventHomeResponse = BaseResponse<EventHomeData>
typealias AttendedEventsResponse = BaseResponse<PagedEventsData>
typealias UpcomingEventsResponse = BaseResponse<PagedEventsData>


// MARK: - 경조사 홈 조회
struct EventHomeData: Codable {
    let events: [Event]
}

struct Event: Codable {
    let eventId: String
    let hostInfo: HostInfo
    let eventInfo: EventInfo
    let locationInfo: LocationInfo
}


struct HostInfo: Codable {
    let hostName: String
    let hostNickname: String
}

struct EventInfo: Codable {
    let eventCategory: String
    let relationship: String
    let cost: Int
    let eventDate: String
    let dDay: Int
}

struct LocationInfo: Codable {
    let location: String
}


// MARK: - 경조사 전체조회 조회(기록하기-다녀온 경조사 정보)

struct PagedEventsData: Codable {
    let events: [AttendedEvent]
    let currentPage: Int
    let isLast: Bool
}

struct AttendedEvent: Codable {
    let eventId: String
    let hostInfo: HostInfo
    let eventInfo: AttendedEventInfo
}

struct AttendedEventInfo: Codable {
    let eventCategory: String
    let relationship: String
    let cost: Int
    let eventDate: String
}


