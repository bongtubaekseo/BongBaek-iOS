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
    case getEventDetail(eventId: String)
    case createEvent(eventData: CreateEventData)
    case updateEvent(eventId: Int, eventData: UpdateEventData)
    case deleteEvent(eventId: String)
    case deleteMultipleEvents(eventIds: [String])
    case getAmountRecommendation(request: AmountRecommendationRequest)
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
            var path = "/api/v1/events/upcoming/\(page)"
            if let category = category {
                path += "?category=\(category)"
            }
            print("생성된 path: \(path)")
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
        case .getHome, .getAttendedEvents, .getUpcomingEvents, .getEventDetail:
            return .get
            
        case .createEvent,.getAmountRecommendation:
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
            
        case .getAmountRecommendation(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        // 기본 헤더
        var headers = [
            "Content-Type": "application/json"
        ]
        
        // KeyChain에서 accessToken 가져오기
        if let accessToken = KeychainManager.shared.accessToken {
            headers["Authorization"] = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE3NTIzNDEzMjAsImV4cCI6MTc1MzU1MDkyMCwibWVtYmVySWQiOiI0Y2I2YTQzYi02MDdmLTRjYTgtYTc5NC1mOTQ2OWJkOTBhN2YifQ.1pLkdYMn5bwl6W7mnlWMvFd-5XOPpYjIPEiMTd3lllnXV18kUjBjlZ9S0iwiM0d-uaX0oC2Lk9t-fMlM9ui0NQ"
            print("Authorization 헤더 추가됨: Bearer \(accessToken.prefix(10))...")
        } else {
            print("AccessToken이 KeyChain에 없습니다")
        }
        
        return headers
    }
}
