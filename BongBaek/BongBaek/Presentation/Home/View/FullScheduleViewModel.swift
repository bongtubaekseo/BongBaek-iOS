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
    
    @Published var schedules: [ScheduleModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCategory: ScheduleCategory = .all
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.eventService = DIContainer.shared.eventService
    }
    
    
    /// 년/월별로 그룹핑된 일정들
    var schedulesGrouped: [String: [String: [ScheduleModel]]] {
        let grouped = Dictionary(grouping: filteredSchedules) { model in
            let components = model.date.split(separator: ".")
            let year = components.count > 0 ? String(components[0]).trimmingCharacters(in: .whitespaces) : "기타"
            let month = components.count > 1 ? String(components[1]).trimmingCharacters(in: .whitespaces) : "기타"
            return "\(year)/\(month)"
        }
        
        return grouped.reduce(into: [String: [String: [ScheduleModel]]]()) { result, pair in
            let parts = pair.key.split(separator: "/")
            guard parts.count == 2 else { return }
            let year = String(parts[0])
            let month = String(parts[1])
            result[year, default: [:]][month, default: []] += pair.value
        }
    }
    
    /// 카테고리별 필터링된 일정들
    private var filteredSchedules: [ScheduleModel] {
        if selectedCategory == .all {
            return schedules
        } else {
            return schedules.filter { schedule in
                schedule.type == selectedCategory.rawValue
            }
        }
    }
    
    /// 정렬된 년도 목록
    var sortedYears: [String] {
        schedulesGrouped.keys.sorted(by: <)
    }
    
    /// 특정 년도의 월별 일정
    func monthsForYear(_ year: String) -> [String: [ScheduleModel]] {
        return schedulesGrouped[year] ?? [:]
    }
    
    /// 특정 년도의 정렬된 월 목록
    func sortedMonthsForYear(_ year: String) -> [String] {
        let months = schedulesGrouped[year] ?? [:]
        return months.keys.sorted()
    }
    
    // MARK: - API Methods
    
    /// 전체 일정 로드
    func loadAllSchedules() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {

            
            //Todo - 실제 더보기 API 구현
            // let response = try await eventService.getAllEvents().async()
            
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
            
            let dummySchedules = createDummySchedules()
            schedules = dummySchedules
            
            print("전체 일정 로드 성공: \(schedules.count)개")
            
        } catch {
            errorMessage = "일정을 불러오는데 실패했습니다: \(error.localizedDescription)"
            print("전체 일정 로드 실패: \(error)")
        }
        
        isLoading = false
    }
    
    func refreshSchedules() async {
        print("전체 일정 새로고침")
        await loadAllSchedules()
    }
    
    func updateCategory(_ category: ScheduleCategory) {
        selectedCategory = category
        print("📂 카테고리 변경: \(category.displayName)")
    }
    
    func clearError() {
        errorMessage = nil
    }
    

    private func createDummySchedules() -> [ScheduleModel] {
        return [
            ScheduleModel(
                type: "결혼식",
                relation: "친구",
                name: "김철수",
                money: "10만원",
                location: "강남구 웨딩홀",
                date: "2024.12.15"
            ),
            ScheduleModel(
                type: "돌잔치",
                relation: "가족",
                name: "이영희",
                money: "5만원",
                location: "서초구 한정식집",
                date: "2024.11.20"
            ),
            ScheduleModel(
                type: "생일",
                relation: "동료",
                name: "박민수",
                money: "3만원",
                location: "홍대 카페",
                date: "2024.10.08"
            ),
            ScheduleModel(
                type: "결혼식",
                relation: "가족",
                name: "최미영",
                money: "20만원",
                location: "잠실 롯데호텔",
                date: "2024.09.25"
            ),
            ScheduleModel(
                type: "장례식",
                relation: "지인",
                name: "정대호",
                money: "10만원",
                location: "서울대병원 장례식장",
                date: "2024.08.12"
            ),
            ScheduleModel(
                type: "결혼식",
                relation: "친구",
                name: "안소영",
                money: "15만원",
                location: "여의도 63빌딩",
                date: "2025.01.18"
            ),
            ScheduleModel(
                type: "돌잔치",
                relation: "동료",
                name: "송민호",
                money: "7만원",
                location: "분당 레스토랑",
                date: "2025.02.28"
            ),
            ScheduleModel(
                type: "생일",
                relation: "가족",
                name: "김하늘",
                money: "5만원",
                location: "집",
                date: "2025.03.12"
            )
        ]
    }
}

// MARK: - Computed Properties Extension
extension FullScheduleViewModel {
    
    /// 데이터가 있는지 확인
    var hasData: Bool {
        return !schedules.isEmpty
    }
    
    /// 에러가 있는지 확인
    var hasError: Bool {
        return errorMessage != nil
    }
    
    /// 로딩 가능 여부
    var canLoad: Bool {
        return !isLoading
    }
    
    /// 필터링된 일정 개수
    var filteredCount: Int {
        return filteredSchedules.count
    }
}
