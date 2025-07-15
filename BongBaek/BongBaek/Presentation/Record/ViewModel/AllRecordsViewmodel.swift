//
//  AllRecordsViewmodel.swift
//  BongBaek
//
//  Created by 임재현 on 7/15/25.
//

import Foundation
import Combine

@MainActor
class AllRecordsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var eventDetail: EventDetailData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var memoText: String = ""
    
    // MARK: - Dependencies
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.eventService = DIContainer.shared.eventService
    }
    
    // MARK: - API Methods
    
    /// eventId로 이벤트 상세 정보 로드
    func loadEventDetail(eventId: String) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await eventService.getEventDetail(eventId: eventId)
                .async()
            
            if response.isSuccess, let eventData = response.data {
                self.eventDetail = eventData
                
                self.memoText = eventData.eventInfo.note ?? ""
                
                print("이벤트 상세 정보 로드 성공!")
                print("  - 이름: \(eventData.hostInfo.hostName)")
                print("  - 이벤트: \(eventData.eventInfo.eventCategory)")
                print("  - 경조사비: \(eventData.eventInfo.cost)원")
                print("  - 메모: '\(self.memoText)'")
                
            } else {
                errorMessage = response.message
                print("이벤트 상세 정보 로드 실패: \(response.message)")
            }
            
        } catch {
            errorMessage = "이벤트 정보를 불러오는데 실패했습니다: \(error.localizedDescription)"
            print("이벤트 상세 정보 로드 에러: \(error)")
            print("에러 상세: \(error)")
        }
        
        isLoading = false
    }
    
    /// 메모 저장 (별도 API가 있다면)
    func saveMemo() async {
        // 메모 저장 API 호출
        // let response = try await eventService.updateEventMemo(eventId: event.eventId, memo: memoText)
        
        print("메모 저장: \(memoText)")
    }
    
    // MARK: - Helper Methods
    
    /// 에러 초기화
    func clearError() {
        errorMessage = nil
    }
    
    /// 데이터 초기화
    func resetData() {
        eventDetail = nil
        memoText = ""
        errorMessage = nil
    }
}


extension AllRecordsViewModel {
    
    var hasEventDetail: Bool {
        return eventDetail != nil
    }
    
    var hasError: Bool {
        return errorMessage != nil
    }
    
    var canSaveMemo: Bool {
        return hasEventDetail && !isLoading
    }
}

