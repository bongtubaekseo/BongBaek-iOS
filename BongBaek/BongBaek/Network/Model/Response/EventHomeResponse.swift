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
typealias EventDetailResponse = BaseResponse<EventDetailData>
typealias CreateEventResponse = BaseResponse<EmptyData>
typealias UpdateEventResponse = BaseResponse<EmptyData>
typealias DeleteEventResponse = BaseResponse<EmptyData>
typealias DeleteMultipleEventsResponse = BaseResponse<EmptyData>
typealias AmountRecommendationResponse = BaseResponse<AmountRecommendationData>


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
    let note: String?
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


// MARK: - 경조사 상세 조회
struct EventDetailData: Codable {
    let eventId: String
    let hostInfo: HostInfo
    let eventInfo: EventDetailInfo
    let locationInfo: LocationDetailInfo
}


struct EventDetailInfo: Codable {
    let eventCategory: String
    let relationship: String
    let cost: Int
    let isAttend: Bool
    let eventDate: String
    let note: String?
}

struct LocationDetailInfo: Codable {
    let location: String
    let address: String
    let latitude: Double
    let longitude: Double
}


struct EmptyData: Codable {}


// MARK: - 경조사 금액 추천 결과 반환
struct AmountRecommendationData: Codable {
    let cost: Int
    let range: AmountRange
    let category: String
    let location: String
    let params: RecommendationParams
}


struct AmountRange: Codable {
    let min: Int
    let max: Int
}


struct RecommendationParams: Codable {
    let age: Int
    let income: String
    let category: String
    let relationship: String
    let attended: Bool
    let contactFrequency: Int?
    let meetFrequency: Int?
}
