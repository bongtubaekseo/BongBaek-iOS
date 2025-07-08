//
//  EventInformationViewModel.swift
//  BongBaek
//
//  Created by 김현우 on 7/3/25.
//

import SwiftUI
import Combine

// MARK: - EventInformationViewModel
class EventInformationViewModel: ObservableObject {
    // MARK: - Published P  roperties
    @Published var selectedEventType: EventType? = nil
    @Published var showEventDateView = false
    
    // MARK: - Computed Properties
    var isNextButtonEnabled: Bool {
        selectedEventType != nil
    }
    
    // MARK: - Methods
    func selectEventType(_ eventType: EventType) {
        // 이미 선택된 버튼을 다시 클릭하면 선택 해제
        if selectedEventType == eventType {
            selectedEventType = nil
        } else {
            selectedEventType = eventType
        }
    }
    
    func proceedToNext() {
        guard let selectedEventType = selectedEventType else {
            print("경조사가 선택되지 않았습니다.")
            return
        }
        
        print("선택된 경조사: \(selectedEventType.rawValue)")
        // 여기에 다음 화면으로 이동하는 로직 추가
        // 예: NavigationManager, Router 등을 통한 화면 전환
        showEventDateView = true
    }
    
    // MARK: - Helper Methods
    func resetSelection() {
        selectedEventType = nil
    }
    
    func isEventTypeSelected(_ eventType: EventType) -> Bool {
        selectedEventType == eventType
    }
}
