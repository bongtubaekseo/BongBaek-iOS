//
//  EventViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation
import Combine

class EventViewModel: ObservableObject {
    @Published var homeEvents: [Event] = []
    @Published var attendedEvents: [AttendedEvent] = []
    @Published var upcomingEvents: [AttendedEvent] = []

    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    @Published var attendedCurrentPage = 1
    @Published var attendedIsLastPage = false
    @Published var upcomingCurrentPage = 1
    @Published var upcomingIsLastPage = false
    
    @Published var eventDetail: EventDetailData?
    
    @Published var isCreating = false
    @Published var createSuccess = false
    
    @Published var isUpdating = false
    @Published var updateSuccess = false
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(eventService: EventServiceProtocol = DIContainer.shared.eventService) {
        self.eventService = eventService
    }
    
    func loadHome() {
        isLoading = true
        errorMessage = nil
        
        eventService.getHome()
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.isSuccess, let data = response.data {
                        self?.homeEvents = data.events
                    } else {
                        self?.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadAttendedEvents(page: Int = 1, attended: Bool = true, category: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        eventService.getAttendedEvents(page: page, attended: attended, category: category)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.isSuccess, let data = response.data {
                        if page == 1 {
                            // 첫 페이지는 새로 할당
                            self?.attendedEvents = data.events
                        } else {
                            // 추가 페이지는 append
                            self?.attendedEvents.append(contentsOf: data.events)
                        }
                        self?.attendedCurrentPage = data.currentPage
                        self?.attendedIsLastPage = data.isLast
                    } else {
                        self?.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadNextPage(attended: Bool = true, category: String? = nil) {
        guard !attendedIsLastPage && !isLoading else { return }
        loadAttendedEvents(page: attendedCurrentPage + 1, attended: attended, category: category)
    }
    
    func loadUpcomingEvents(page: Int = 1, category: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        eventService.getUpcomingEvents(page: page, category: category)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.isSuccess, let data = response.data {
                        if page == 1 {
                            self?.upcomingEvents = data.events
                        } else {
                            self?.upcomingEvents.append(contentsOf: data.events)
                        }
                        self?.upcomingCurrentPage = data.currentPage
                        self?.upcomingIsLastPage = data.isLast
                    } else {
                        self?.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadNextUpcomingPage(category: String? = nil) {
        guard !upcomingIsLastPage && !isLoading else { return }
        loadUpcomingEvents(page: upcomingCurrentPage + 1, category: category)
    }
    
    func loadEventDetail(eventId: Int) {
        isLoading = true
        errorMessage = nil
        
        eventService.getEventDetail(eventId: eventId)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.isSuccess, let data = response.data {
                        self?.eventDetail = data
                    } else {
                        self?.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func createEvent(eventData: CreateEventData) {
        isCreating = true
        errorMessage = nil
        createSuccess = false
        
        eventService.createEvent(eventData: eventData)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isCreating = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.isSuccess {
                        self?.createSuccess = true
                        // 생성 성공시 홈 화면 다시 재호출 (새로고침)
                        self?.loadHome()
                    } else {
                        self?.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func updateEvent(eventId: Int, eventData: UpdateEventData) {
        isUpdating = true
        errorMessage = nil
        updateSuccess = false
        
        eventService.updateEvent(eventId: eventId, eventData: eventData)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isUpdating = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.isSuccess {
                        self?.updateSuccess = true
                        self?.loadEventDetail(eventId: eventId)
                        // 수정 성공시 홈 화면 다시 재호출 (새로고침)
                        self?.loadHome()
                    } else {
                        self?.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
}
