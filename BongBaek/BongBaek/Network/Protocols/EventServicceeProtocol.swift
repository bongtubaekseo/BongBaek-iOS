//
//  EventServicceeProtocol.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Moya
import Combine

protocol EventServiceProtocol {
    func getHome() -> AnyPublisher<EventHomeResponse, Error>
    func getAttendedEvents(page: Int, attended: Bool, category: String?) -> AnyPublisher<AttendedEventsResponse, Error>
    func getUpcomingEvents(page: Int, category: String?) -> AnyPublisher<UpcomingEventsResponse, Error>
    func getEventDetail(eventId: String) -> AnyPublisher<EventDetailResponse, Error>
    func createEvent(eventData: CreateEventData) -> AnyPublisher<CreateEventResponse, Error>
    func updateEvent(eventId: Int, eventData: UpdateEventData) -> AnyPublisher<UpdateEventResponse, Error>
    func deleteEvent(eventId: String) -> AnyPublisher<DeleteEventResponse, Error>
    func deleteMultipleEvents(eventIds: [String]) -> AnyPublisher<DeleteMultipleEventsResponse, Error>
    func getAmountRecommendation(request: AmountRecommendationRequest) -> AnyPublisher<AmountRecommendationResponse, Error>
}
