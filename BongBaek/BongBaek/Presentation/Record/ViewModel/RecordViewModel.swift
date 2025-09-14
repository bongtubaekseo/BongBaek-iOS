//
//  RecordViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI
import Combine

enum Category: String, CaseIterable {
    case all = "전체"
    case wedding = "결혼식"
    case babyParty = "돌잔치"
    case birthday = "생일"
    case funeral = "장례식"
    
}

@MainActor
class RecordViewModel: ObservableObject {
    
    @Published var isDeleteMode = false
    @Published var selectedSection: RecordSection = .attended
    @Published var selectedCategory: EventsCategory = .all
    @Published var selectedRecordIDs: Set<String> = []
    
    @Published var attendedEvents: [AttendedEvent] = []
    @Published var notAttendedEvents: [AttendedEvent] = []
    
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    private var attendedCurrentPage = 0
    private var notAttendedCurrentPage = 0
    private var attendedIsLastPage = false
    private var notAttendedIsLastPage = false
    private var isLoadingData = false
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    
    /// 참석한 경조사 개수
    var attendedCount: Int {
        attendedEvents.count
    }
    
    /// 불참한 경조사 개수
    var notAttendedCount: Int {
        notAttendedEvents.count
    }
    
    /// 선택된 섹션에 따른 현재 데이터
    var currentEvents: [AttendedEvent] {
        switch selectedSection {
        case .attended:
            return attendedEvents
        case .notAttended:
            return notAttendedEvents
        }
    }
    
    var currentEventsGrouped: [String: [String: [AttendedEvent]]] {
         let events = currentEvents
         
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
    
    var sortedYears: [String] {
        currentEventsGrouped.keys.sorted(by: <)
    }
    
    func monthsForYear(_ year: String) -> [String: [AttendedEvent]] {
        return currentEventsGrouped[year] ?? [:]
    }
    
    /// 특정 년도의 정렬된 월 목록
    func sortedMonthsForYear(_ year: String) -> [String] {
        let months = currentEventsGrouped[year] ?? [:]
        return months.keys.sorted()
    }
    
    /// 현재 섹션이 비어있는지 확인
    var isCurrentSectionEmpty: Bool {
        currentEvents.isEmpty
    }
    
    // 다른 선택 관련 상태들도 초기화
    func cancelDeleteMode() {
        isDeleteMode = false
        selectedRecordIDs.removeAll()
    }
    
    /// 현재 섹션의 빈 상태 메시지
    var emptyMessage: String {
        switch selectedSection {
        case .attended:
            switch selectedCategory {
            case .babyParty:
                return "참석한 돌잔치가 없습니다"
            case .wedding:
                return "참석한 결혼식이 없습니다"
            case .birthday:
                return "참석한 생일이 없습니다"
            case .funeral:
                return "참석한 장례식이 없습니다"
            case .all:
                return "참석한 경조사가 없습니다"
            default:
                return "참석한 경조사가 없습니다"
            }
        case .notAttended:
            switch selectedCategory {
            case .babyParty:
                return "불참한 돌잔치가 없습니다"
            case .wedding:
                return "불참한 결혼식이 없습니다"
            case .birthday:
                return "불참한 생일이 없습니다"
            case .funeral:
                return "불참한 장례식이 없습니다"
            case .all:
                return "불참한 경조사가 없습니다"
            default:
                return "불참한 경조사가 없습니다"
            }
        }
    }
    
    
    init() {
        self.eventService = DIContainer.shared.eventService
    }
      
    /// 삭제 모드 토글
    func toggleDeleteMode() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isDeleteMode.toggle()
            if !isDeleteMode {
                selectedRecordIDs.removeAll()
            }
        }
    }
    
    /// 섹션 변경
    func changeSection(to section: RecordSection) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedSection = section
            selectedRecordIDs.removeAll() // 섹션 변경 시 선택 초기화
            selectedCategory = .all
        }
        
        // 해당 섹션 데이터가 없으면 로드
        Task {
            await loadSectionDataIfNeeded()
        }
    }
    
    /// 카테고리 변경
    func changeCategory(to category: EventsCategory) {
        selectedCategory = category
        print("카테고리 변경: \(category.display)")
        
        // 카테고리 변경 시 데이터 새로 로드
        Task {
            await loadAllRecords()
        }
    }
    
    /// 기록 선택/해제
    func toggleRecordSelection(_ eventId: String) {
        if selectedRecordIDs.contains(eventId) {
            selectedRecordIDs.remove(eventId)
        } else {
            selectedRecordIDs.insert(eventId)
        }
        print("선택된 ID: \(selectedRecordIDs)")
    }
    
    /// 선택된 기록들 삭제
    func deleteSelectedRecords() {
        print("삭제할 기록 ID들: \(selectedRecordIDs)")
        
        Task {
            for eventId in selectedRecordIDs {
                do {
                    let response = try await eventService.deleteEvent(eventId: eventId).async()
                    if response.isSuccess {
                        print("이벤트 삭제 성공: \(eventId)")
                    } else {
                        print("이벤트 삭제 실패: \(eventId) - \(response.message)")
                    }
                } catch {
                    print("이벤트 삭제 에러: \(eventId) - \(error)")
                }
            }
            
            // 모든 작업을 메인 스레드에서 실행
            selectedRecordIDs.removeAll()
            isDeleteMode = false
            await loadAllRecords()
            
            print("선택된 기록들이 삭제되었습니다")
        }
    }
    
    /// 무한스크롤 트리거 확인
    func shouldLoadMore(for event: AttendedEvent) -> Bool {
        let currentData = currentEvents
        guard let lastEvent = currentData.last else { return false }
        
        let isLastPage = selectedSection == .attended ? attendedIsLastPage : notAttendedIsLastPage
        return event.eventId == lastEvent.eventId && !isLastPage && !isLoadingMore
    }
    
    /// 에러 메시지 초기화
    func clearError() {
        errorMessage = nil
    }
    
    
    /// 전체 기록 로드 (첫 페이지)
    func loadAllRecords() async {
        guard !isLoadingData else { return }
        
        isLoading = true
        isLoadingData = true
        errorMessage = nil
        
        // 페이지네이션 상태 초기화
        attendedCurrentPage = 0
        notAttendedCurrentPage = 0
        attendedIsLastPage = false
        notAttendedIsLastPage = false
        
        // 데이터 초기화
        attendedEvents.removeAll()
        notAttendedEvents.removeAll()
        
        // 참석/불참 데이터 모두 로드
        async let attendedResult: () = loadAttendedEvents(isRefresh: true)
        async let notAttendedResult: () = loadNotAttendedEvents(isRefresh: true)
        
        _ = await (attendedResult, notAttendedResult)
        
        isLoading = false
        isLoadingData = false
    }
    
    /// 더 많은 데이터 로드 (무한스크롤)
    func loadMoreEvents() async {
        guard !isLoadingData else { return }
        
        switch selectedSection {
        case .attended:
            guard !attendedIsLastPage else { return }
            attendedCurrentPage += 1
            await loadAttendedEvents(isRefresh: false)
            
        case .notAttended:
            guard !notAttendedIsLastPage else { return }
            notAttendedCurrentPage += 1
            await loadNotAttendedEvents(isRefresh: false)
        }
    }
    
    /// 새로고침
    func refreshRecords() async {
        print("기록 새로고침")
        await loadAllRecords()
    }
       
    /// 참석한 이벤트 로드
    private func loadAttendedEvents(isRefresh: Bool) async {
        do {
            let categoryParam = selectedCategory == .all ? nil : selectedCategory.apiValue
            
            print(" 참석 이벤트 로드 - 페이지: \(attendedCurrentPage), 카테고리: \(categoryParam ?? "전체")")
            
            let response = try await eventService.getAttendedEvents(
                page: attendedCurrentPage,
                attended: true,  // 참석한 이벤트
                category: categoryParam
            ).async()
            
            if response.isSuccess, let data = response.data {
                let newEvents = data.events
                
                if isRefresh {
                    attendedEvents = newEvents
                } else {
                    attendedEvents.append(contentsOf: newEvents)
                }
                
                
                print(attendedEvents)
                attendedIsLastPage = data.isLast
                
                print("참석 이벤트 로드 성공:")
                print("  - 새로 로드된 이벤트: \(newEvents.count)개")
                print("  - 전체 참석 이벤트: \(attendedEvents.count)개")
                print("  - 마지막 페이지: \(attendedIsLastPage)")
                
            } else {
                errorMessage = response.message
                print(" 참석 이벤트 로드 실패: \(response.message)")
            }
            
        } catch {
            errorMessage = "참석 이벤트를 불러오는데 실패했습니다: \(error.localizedDescription)"
            print("참석 이벤트 로드 에러: \(error)")
        }
    }
    
    /// 불참한 이벤트 로드
    private func loadNotAttendedEvents(isRefresh: Bool) async {
        do {
            let categoryParam = selectedCategory == .all ? nil : selectedCategory.apiValue
            
            print("불참 이벤트 로드 - 페이지: \(notAttendedCurrentPage), 카테고리: \(categoryParam ?? "전체")")
            
            let response = try await eventService.getAttendedEvents(
                page: notAttendedCurrentPage,
                attended: false,  // 불참한 이벤트
                category: categoryParam
            ).async()
            
            if response.isSuccess, let data = response.data {
                let newEvents = data.events
                
                if isRefresh {
                    notAttendedEvents = newEvents
                } else {
                    notAttendedEvents.append(contentsOf: newEvents)
                }
                
                notAttendedIsLastPage = data.isLast
                print(notAttendedEvents)
                print("불참 이벤트 로드 성공:")
                print("  - 새로 로드된 이벤트: \(newEvents.count)개")
                print("  - 전체 불참 이벤트: \(notAttendedEvents.count)개")
                print("  - 마지막 페이지: \(notAttendedIsLastPage)")
                
            } else {
                errorMessage = response.message
                print("불참 이벤트 로드 실패: \(response.message)")
            }
            
        } catch {
            errorMessage = "불참 이벤트를 불러오는데 실패했습니다: \(error.localizedDescription)"
            print("불참 이벤트 로드 에러: \(error)")
        }
    }
    
    /// 필요한 경우만 섹션 데이터 로드
    private func loadSectionDataIfNeeded() async {
        switch selectedSection {
        case .attended:
            if attendedEvents.isEmpty {
                await loadAttendedEvents(isRefresh: true)
            }
        case .notAttended:
            if notAttendedEvents.isEmpty {
                await loadNotAttendedEvents(isRefresh: true)
            }
        }
    }
}


extension EventsCategory {
    var apiValue: String {
        switch self {
        case .all: return ""
        case .wedding: return "결혼식"
        case .babyParty: return "돌잔치"
        case .birthday: return "생일"
        case .funeral: return "장례식"
        }
    }
}

extension RecordViewModel {
    func clearSelectedRecords() {
        selectedRecordIDs.removeAll()
        print("선택된 레코드 초기화 완료 - 총 \(selectedRecordIDs.count)개")
    }
}
