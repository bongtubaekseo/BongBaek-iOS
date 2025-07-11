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
    
    func getEventDetail(eventId: Int) -> AnyPublisher<EventDetailResponse, Error> {
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
}
