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
        return networkService.request(
            .getAttendedEvents(page: page, attended: attended, category: category),
            responseType: AttendedEventsResponse.self
        )
    }
    
    func getUpcomingEvents(page: Int, category: String?) -> AnyPublisher<UpcomingEventsResponse, Error> {
        return networkService.request(
            .getUpcomingEvents(page: page, category: category),
            responseType: UpcomingEventsResponse.self
        )
    }
}
