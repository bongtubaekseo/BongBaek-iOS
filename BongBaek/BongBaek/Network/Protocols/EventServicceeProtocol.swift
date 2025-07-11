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
}
