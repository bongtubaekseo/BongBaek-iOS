//
//  EventsTarget.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation
import Moya



enum EventsTarget {
    case getHome
    case getAttendedEvents(page: Int, attended: Bool, category: String?)
    case getUpcomingEvents(page: Int, category: String?)
    case getEventDetail(eventId: Int)
    case createEvent(eventData: CreateEventData)
    case updateEvent(eventId: Int, eventData: UpdateEventData)
    case deleteEvent(eventId: Int)
    case deleteMultipleEvents(eventIds: [Int])
    case getAmountRecommendation(eventType: String, relationship: String)
}

extension EventsTarget: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: AppConfig.shared.baseURL) else {
            fatalError("Invalid base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getHome:
            return "/api/v1/events/home"
            
        case .getAttendedEvents(let page, let attended, let category):
            var path = "/api/v1/events/history/\(page)?attended=\(attended)"
            if let category = category {
                path += "&category=\(category)"
            }
            return path
            
        case .getUpcomingEvents(let page, let category):
            var path = "/api/v1/events/\(page)"
            if let category = category {
                path += "?category=\(category)"
            }
            return path
            
        case .getEventDetail(let eventId):
            return "/api/v1/events/\(eventId)"
            
        case .createEvent:
            return "/api/v1/events"
            
        case .updateEvent(let eventId, _):
            return "/api/v1/events/\(eventId)"
            
        case .deleteEvent(let eventId):
            return "/api/v1/events/\(eventId)"
            
        case .deleteMultipleEvents:
            return "/api/v1/events"
            
        case .getAmountRecommendation:
            return "/api/v1/events/cost"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHome, .getAttendedEvents, .getUpcomingEvents, .getEventDetail, .getAmountRecommendation:
            return .get
            
        case .createEvent:
            return .post
            
        case .updateEvent:
            return .put
            
        case .deleteEvent, .deleteMultipleEvents:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getHome, .getEventDetail, .deleteEvent:
            return .requestPlain
            
        case .getAttendedEvents, .getUpcomingEvents:
            return .requestPlain
            
        case .createEvent(let eventData):
            return .requestJSONEncodable(eventData)
            
        case .updateEvent(_, let eventData):
            return .requestJSONEncodable(eventData)
            
        case .deleteMultipleEvents(let eventIds):
            return .requestParameters(
                parameters: ["eventIds": eventIds],
                encoding: JSONEncoding.default
            )
            
        case .getAmountRecommendation(let eventType, let relationship):
            return .requestParameters(
                parameters: [
                    "eventType": eventType,
                    "relationship": relationship
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        ["":""]
    }
}
