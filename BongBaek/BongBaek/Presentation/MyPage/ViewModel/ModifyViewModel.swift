//
//  ModifyViewModel.swift
//  BongBaek
//
//  Created by hyunwoo on 9/5/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class ModifyViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var nickname: String = ""
    @Published var selectedDate: String = ""
    @Published var hasIncome: Bool = true
    @Published var currentSelection: IncomeSelection = .none
    
    // UI State
    @Published var isUpdating: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var updateSuccess: Bool = false
    
    private var initialNickname: String = ""
    private var initialDate: String = ""
    private var initialHasIncome: Bool = true
    private var initialSelection: IncomeSelection = .none
    
    // MARK: - Private Properties
    let myPageManager = MyPageManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Enums
    enum IncomeSelection: Equatable {
        case under200
        case over200
        case none
        
        var displayText: String {
            switch self {
            case .under200: return "월 200만원 미만"
            case .over200: return "월 200만원 이상"
            case .none: return ""
            }
        }
        
        var apiValue: String {
            switch self {
            case .under200: return "200만원 미만"
            case .over200: return "200만원 이상"
            case .none: return ""
            }
        }
    }
    
    init() {
        setupProfileUpdateObserver()
    }
    
    // MARK: - Computed Properties

    private func setupProfileUpdateObserver() {
        myPageManager.$isLoadingProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                print("isLoadingProfile 변화: \(loading)")
                self?.isUpdating = loading
            }
            .store(in: &cancellables)
        
        myPageManager.$profileError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print("profileError 변화: \(error ?? "nil")")
                if let error = error {
                    self?.isUpdating = false
                    self?.errorMessage = error
                    self?.showErrorAlert = true
                }
            }
            .store(in: &cancellables)
        
        myPageManager.$isUpdateSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                print("isUpdateSuccess 변화: \(success)")
                if success {
                    self?.updateSuccess = true
                    print("프로필 업데이트 성공!")
                }
            }
            .store(in: &cancellables)
    }
    

    
    var isUpdateButtonEnabled: Bool {
        let basicFieldsValid = nickname.count >= 2 &&
                              nickname.count <= 10 &&
                              !selectedDate.isEmpty
        
        let normalizedCurrentDate = normalizeDate(selectedDate)
           let normalizedInitialDate = normalizeDate(initialDate)
        
        let hasChanges = nickname != initialNickname ||
                        normalizedCurrentDate != normalizedInitialDate ||
                        hasIncome != initialHasIncome ||
                        currentSelection != initialSelection
        
        print("=== 버튼 활성화 체크 ===")
        print("현재 nickname: '\(nickname)' vs 초기값: '\(initialNickname)'")
        print("현재 date: '\(selectedDate)' vs 초기값: '\(initialDate)'")
        print("현재 hasIncome: \(hasIncome) vs 초기값: \(initialHasIncome)")
        print("현재 selection: \(currentSelection) vs 초기값: \(initialSelection)")
        print("hasChanges: \(hasChanges)")
        print("=====================")
        
        if hasIncome {
            return basicFieldsValid && currentSelection != .none && !isUpdating && hasChanges
        } else {
            return basicFieldsValid && !isUpdating && hasChanges
        }
    }
    
    // MARK: - Initialization
    
    func saveInitialValues() {
        initialNickname = nickname
        initialDate = selectedDate
        initialHasIncome = hasIncome
        initialSelection = currentSelection
        print("=== 초기값 저장 ===")
        print("nickname: '\(initialNickname)'")
        print("date: '\(initialDate)'")
        print("hasIncome: \(initialHasIncome)")
        print("selection: \(initialSelection)")
        print("==================")
    }
    
    // MARK: - Public Methods
    func selectIncome(_ selection: IncomeSelection) {
        currentSelection = selection
    }
    
    func toggleIncomeStatus() {
        hasIncome.toggle()
        if !hasIncome {
            currentSelection = .none
        }
    }
    
    func performProfileUpdate() {
        guard isUpdateButtonEnabled else { return }
        
        isUpdating = true
        
        let updateData = createUpdateProfileData()
        myPageManager.updateProfile(updateData: updateData)
    }
    
    private func createUpdateProfileData() -> UpdateProfileData {
        let incomeValue: String
        if hasIncome {
            incomeValue = currentSelection.apiValue
        } else {
            incomeValue = "없음"
        }
        
        let formattedBirthday = convertDateFormat(selectedDate)
        
        return UpdateProfileData(
            memberName: nickname,
            memberBirthday: formattedBirthday,
            memberIncome: incomeValue
        )
    }
    
    private func normalizeDate(_ dateString: String) -> String {
        if dateString.contains("년") {
            let components = dateString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            let numbers = components.filter { !$0.isEmpty }
            if numbers.count >= 3 {
                let year = numbers[0]
                let month = String(format: "%02d", Int(numbers[1]) ?? 0)
                let day = String(format: "%02d", Int(numbers[2]) ?? 0)
                return "\(year)-\(month)-\(day)"
            }
        } else if dateString.contains(".") {
            // "2011.09.19" → "2011-09-19"
            return dateString.replacingOccurrences(of: ".", with: "-")
        }
        return dateString
    }
    
    func dismissError() {
        showErrorAlert = false
        errorMessage = ""
    }
    
    // MARK: - Private Methods

    private func convertDateFormat(_ dateString: String) -> String {
        if dateString.contains("년") {
            let components = dateString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            let numbers = components.filter { !$0.isEmpty }
            
            if numbers.count >= 3 {
                let year = numbers[0]
                let month = String(format: "%02d", Int(numbers[1]) ?? 0)
                let day = String(format: "%02d", Int(numbers[2]) ?? 0)
                let converted = "\(year)-\(month)-\(day)"
                print("날짜 형식 변환: \(dateString) → \(converted)")
                return converted
            }
        }

        let converted = dateString.replacingOccurrences(of: ".", with: "-")
        print("날짜 형식 변환: \(dateString) → \(converted)")
        return converted
    }
}

extension ModifyViewModel {
    func isSelected(_ selection: IncomeSelection) -> Bool {
        return currentSelection == selection
    }
    
    func getSelectedIncomeText() -> String {
        return currentSelection.displayText
    }
    
    func logCurrentSelection() {
        if hasIncome {
            switch currentSelection {
            case .under200:
                print("선택된 수입: 월 200 이하")
            case .over200:
                print("선택된 수입: 월 200 이상")
            case .none:
                print("수입이 선택되지 않음")
            }
        } else {
            print("선택된 수입: 수입없음")
        }
    }
    
    func resetUpdateSuccess() {
        updateSuccess = false
        myPageManager.resetUpdateSuccess()
        print("ModifyViewModel: updateSuccess 리셋 완료")
    }
    
    func initializeState() {
        updateSuccess = false
        myPageManager.resetUpdateSuccess()
        print("ModifyViewModel: 상태 초기화 완료")
    }
}
