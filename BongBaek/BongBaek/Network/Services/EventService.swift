//
//  EventService.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation
import Combine

class EventService: EventServiceProtocol {
    private let networkService: NetworkService<EventsTarget>
    
    init(networkService: NetworkService<EventsTarget>) {
        self.networkService = networkService
    }
    
    func getHome() -> AnyPublisher<EventHomeResponse, Error> {
        return networkService.request(
            .getHome,
            responseType: EventHomeResponse.self
        )
    }
    
    func getAttendedEvents(page: Int, attended: Bool, category: String?) -> AnyPublisher<AttendedEventsResponse, Error> {
        
        return getAttendedEventsDirectly(page: page, attended: attended, category: category)
//        return networkService.request(
//            .getAttendedEvents(page: page, attended: attended, category: category),
//            responseType: AttendedEventsResponse.self
//        )
    }
    
    private func getAttendedEventsDirectly(page: Int, attended: Bool, category: String?) -> AnyPublisher<AttendedEventsResponse, Error> {
        
        // URL 직접 생성 (인코딩 없이)
        var urlString = "\(AppConfig.shared.baseURL)/api/v1/events/history/\(page)?attended=\(attended)"
        if let category = category, !category.isEmpty {
            urlString += "&category=\(category)"
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: "InvalidURL", code: 0, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 인증 토큰 추가
        if let accessToken = KeychainManager.shared.accessToken {
            request.setValue("Bearer eyJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE3NTIzNDEzMjAsImV4cCI6MTc1MzU1MDkyMCwibWVtYmVySWQiOiI0Y2I2YTQzYi02MDdmLTRjYTgtYTc5NC1mOTQ2OWJkOTBhN2YifQ.1pLkdYMn5bwl6W7mnlWMvFd-5XOPpYjIPEiMTd3lllnXV18kUjBjlZ9S0iwiM0d-uaX0oC2Lk9t-fMlM9ui0NQ", forHTTPHeaderField: "Authorization")
        }
        
        print("📡 직접 생성된 URL: \(urlString)")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: AttendedEventsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getUpcomingEvents(page: Int, category: String?) -> AnyPublisher<UpcomingEventsResponse, Error> {
        return networkService.request(
            .getUpcomingEvents(page: page, category: category),
            responseType: UpcomingEventsResponse.self
        )
    }
    
    func getEventDetail(eventId: String) -> AnyPublisher<EventDetailResponse, Error> {
        return networkService.request(
            .getEventDetail(eventId: eventId),
            responseType: EventDetailResponse.self
        )
    }
    
    func createEvent(eventData: CreateEventData) -> AnyPublisher<CreateEventResponse, Error> {
        return networkService.request(
            .createEvent(eventData: eventData),
            responseType: CreateEventResponse.self
        )
    }
    
    func updateEvent(eventId: Int, eventData: UpdateEventData) -> AnyPublisher<UpdateEventResponse, Error> {
        return networkService.request(
            .updateEvent(eventId: eventId, eventData: eventData),
            responseType: UpdateEventResponse.self
        )
    }
    
    func deleteEvent(eventId: String) -> AnyPublisher<DeleteEventResponse, Error> {
        return networkService.request(
            .deleteEvent(eventId: eventId),
            responseType: DeleteEventResponse.self
        )
    }
    
    func deleteMultipleEvents(eventIds: [String]) -> AnyPublisher<DeleteMultipleEventsResponse, Error> {
        return networkService.request(
            .deleteMultipleEvents(eventIds: eventIds),
            responseType: DeleteMultipleEventsResponse.self
        )
    }
    
    func getAmountRecommendation(request: AmountRecommendationRequest) -> AnyPublisher<AmountRecommendationResponse, Error> {
        return networkService.request(
            .getAmountRecommendation(request: request),
            responseType: AmountRecommendationResponse.self
        )
    }
}
