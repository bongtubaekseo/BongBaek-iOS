//
//  ContentViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 11/7/25.
//

import Foundation
import Combine

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var guides: [Guide] = Guide.mockGuides
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCategory: ScheduleCategory = .all
    @Published var hasMoreData = false
    
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
        !guides.isEmpty
    }
    
    var hasError: Bool {
        errorMessage != nil
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
        guides.removeAll()
        
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
//        do {
//            let categoryParam = selectedCategory == .all ? nil : selectedCategory.apiValue
//            
//            print("이벤트 로드 - 페이지: \(currentPage), 카테고리: \(categoryParam ?? "전체")")
//            
//            let response = try await eventService.getUpcomingEvents(page: currentPage, category: categoryParam)
//                .async()
//            
//            if response.isSuccess, let data = response.data {
//                let newEvents = data.events
//                
//                if isRefresh {
//                    guides = newEvents
//                } else {
//                    guides.append(contentsOf: newEvents)
//                }
//                
//                isLastPage = data.isLast
//                
//                print(guides)
//                
//                print("이벤트 로드 성공:")
//                print("  - 새로 로드된 이벤트: \(newEvents.count)개")
//                print("  - 전체 이벤트: \(guides.count)개")
//                print("  - 현재 페이지: \(currentPage)")
//                print("  - 마지막 페이지: \(isLastPage)")
//                
//            } else {
//                errorMessage = response.message
//                print("이벤트 로드 실패: \(response.message)")
//            }
//            
//        } catch {
//            errorMessage = "이벤트를 불러오는데 실패했습니다: \(error.localizedDescription)"
//            print("이벤트 로드 에러: \(error)")
//        }
        
        
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
        
//        Task {
//            await loadAllEvents()
//        }
    }
    
    /// 무한스크롤 트리거 확인
    func shouldLoadMore(for event: AttendedEvent) -> Bool {
//        guard let lastEvent = guides.last else { return false }
//        return event.eventId == lastEvent.eventId && !isLastPage && !isLoadingMore
        return false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
