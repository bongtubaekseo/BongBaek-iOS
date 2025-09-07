//
//  FullScheduleViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 7/15/25.
//

import Foundation
import Combine

@MainActor
class FullScheduleViewModel: ObservableObject {
    
    @Published var events: [AttendedEvent] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCategory: ScheduleCategory = .all
    
    // 페이지네이션 관련 상태
    private var currentPage: Int = 0
    private var isLastPage: Bool = false
    private var isLoadingData: Bool = false
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.eventService = DIContainer.shared.eventService
    }
    
    // MARK: - Computed Properties
    
    var hasData: Bool {
        !events.isEmpty
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
    
    /// 년/월별로 그룹핑된 이벤트들
    var eventsGrouped: [String: [String: [AttendedEvent]]] {
        let grouped = Dictionary(grouping: events) { event in
            // eventDate: "2025-01-18" → "2025/01"
            let dateComponents = event.eventInfo.eventDate.split(separator: "-")
            let year = dateComponents.count > 0 ? String(dateComponents[0]) : "기타"
            let month = dateComponents.count > 1 ? String(dateComponents[1]) : "기타"
            return "\(year)/\(month)"
        }
        
        return grouped.reduce(into: [String: [String: [AttendedEvent]]]()) { result, pair in
            let parts = pair.key.split(separator: "/")
            guard parts.count == 2 else { return }
            let year = String(parts[0])
            let month = String(parts[1])
            result[year, default: [:]][month, default: []] += pair.value
        }
    }
    
    /// 정렬된 년도 목록
    var sortedYears: [String] {
        eventsGrouped.keys.sorted(by: <)
    }
    
    /// 특정 년도의 월별 이벤트
    func monthsForYear(_ year: String) -> [String: [AttendedEvent]] {
        return eventsGrouped[year] ?? [:]
    }
    
    /// 특정 년도의 정렬된 월 목록
    func sortedMonthsForYear(_ year: String) -> [String] {
        let months = eventsGrouped[year] ?? [:]
        return months.keys.sorted()
    }
    
    // MARK: - API Methods
    
    /// 첫 페이지 로드 (새로고침/카테고리 변경 시)
    func loadAllEvents() async {
        guard !isLoadingData else { return }
        
        isLoading = true
        isLoadingData = true
        errorMessage = nil
        
        // 페이지네이션 상태 초기화
        currentPage = 0
        isLastPage = false
        events.removeAll()
        
        await loadEvents(isRefresh: true)
        
        isLoading = false
        isLoadingData = false
    }
    
    /// 다음 페이지 로드 (무한스크롤)
    func loadMoreEvents() async {
        guard !isLoadingData && !isLastPage else { return }
        
        print("더 많은 이벤트 로드 - 페이지: \(currentPage + 1)")
        
        isLoadingMore = true
        isLoadingData = true
        
        currentPage += 1
        await loadEvents(isRefresh: false)
        
        isLoadingMore = false
        isLoadingData = false
    }
    
    /// 실제 API 호출 메서드
    private func loadEvents(isRefresh: Bool) async {
        do {
            let categoryParam = selectedCategory == .all ? nil : selectedCategory.apiValue
            
            print("이벤트 로드 - 페이지: \(currentPage), 카테고리: \(categoryParam ?? "전체")")
            
            let response = try await eventService.getUpcomingEvents(page: currentPage, category: categoryParam)
                .async()
            
            if response.isSuccess, let data = response.data {
                let newEvents = data.events
                
                if isRefresh {
                    events = newEvents
                } else {
                    events.append(contentsOf: newEvents)
                }
                
                isLastPage = data.isLast
                
                print(events)
                
                print("이벤트 로드 성공:")
                print("  - 새로 로드된 이벤트: \(newEvents.count)개")
                print("  - 전체 이벤트: \(events.count)개")
                print("  - 현재 페이지: \(currentPage)")
                print("  - 마지막 페이지: \(isLastPage)")
                
            } else {
                errorMessage = response.message
                print("이벤트 로드 실패: \(response.message)")
            }
            
        } catch {
            errorMessage = "이벤트를 불러오는데 실패했습니다: \(error.localizedDescription)"
            print("이벤트 로드 에러: \(error)")
        }
        
        
    }
    
    /// 새로고침
    func refreshEvents() async {
        print(" 이벤트 새로고침")
        await loadAllEvents()
    }
    
    /// 카테고리 변경 (새로 로드)
    func updateCategory(_ category: ScheduleCategory) {
        guard selectedCategory != category else { return }
        
        selectedCategory = category
        print("카테고리 변경: \(category.displayName)")
        
        Task {
            await loadAllEvents()
        }
    }
    
    /// 무한스크롤 트리거 확인
    func shouldLoadMore(for event: AttendedEvent) -> Bool {
        guard let lastEvent = events.last else { return false }
        return event.eventId == lastEvent.eventId && !isLastPage && !isLoadingMore
    }
    
    func clearError() {
        errorMessage = nil
    }
}


extension ScheduleCategory {
    /// API에서 사용할 카테고리 값
    var apiValue: String {
        switch self {
        case .all:
            return ""
        case .wedding:
            return "결혼식"
        case .babyParty:
            return "돌잔치"
        case .birthday:
            return "생일"
        case .funeral:
            return "장례식"
        }
    }
}
