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
    @Published var isSigningUp: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var navigateToMain: Bool = false
    
    // MARK: - Private Properties
    private let authManager = AuthManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
          setupAuthStateObserver()
          setupSignUpErrorObserver()
      }
    
    // MARK: - Enums
    enum IncomeSelection: Equatable {
        case under200
        case over200
        case none
        
        var displayText: String {
            switch self {
            case .under200: return "200만원 미만"
            case .over200: return "월 200 이상"
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
    
    // MARK: - Computed Properties
    
    private func setupAuthStateObserver() {
         authManager.$authState
             .receive(on: DispatchQueue.main)
             .sink { [weak self] authState in
                 self?.handleAuthStateChange(authState)
             }
             .store(in: &cancellables)
     }
    
    private func setupSignUpErrorObserver() {
        authManager.$signUpError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleSignUpError(error)
            }
            .store(in: &cancellables)
    }
    
    private func handleSignUpError(_ error: String?) {
            if let error = error {
                print("📱 회원가입 에러 수신: \(error)")
                isSigningUp = false
                errorMessage = error
                showErrorAlert = true
                
                // 에러 처리 후 AuthManager의 에러 초기화
                authManager.clearSignUpError()
            }
        }
    

    
    
    var isStartButtonEnabled: Bool {
        let basicFieldsValid = nickname.count >= 2 &&
                              nickname.count <= 10 &&
                              !selectedDate.isEmpty
        
        if hasIncome {
            return basicFieldsValid && currentSelection != .none && !isSigningUp
        } else {
            return basicFieldsValid && !isSigningUp
        }
    }
    
    // MARK: - Initialization

    
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
        guard isStartButtonEnabled else { return }
        
        isSigningUp = true
        
//        let updateData = createUpdateProfileData()
//        updateProfile(updateData: updateData)
    }
    
    func dismissError() {
        showErrorAlert = false
        errorMessage = ""
    }
    
    // MARK: - Private Methods
    
    
    private func handleAuthStateChange(_ authState: AuthManager.AuthState) {
            switch authState {
            case .authenticated:
                // 회원가입 성공
                isSigningUp = false
                navigateToMain = true
                print("회원가입 성공 - 메인으로 이동")
                
            case .needsSignUp:
                // 초기 회원가입 필요 상태 (실패로 인한 것이 아님)
                break
                
            case .loading:
                // 로딩 상태 유지
                break
                
            case .needsLogin:
                // 로그인이 필요한 상태로 변경됨 (예상치 못한 상황)
                if !isSigningUp {
                    errorMessage = "인증이 만료되었습니다. 다시 로그인해주세요."
                    showErrorAlert = true
                }
            }
        }
    
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
    
    private func createMemberInfo() -> MemberInfo {
        let incomeValue: String
        if hasIncome {
            incomeValue = currentSelection.apiValue
        } else {
            incomeValue = "없음"
        }
        
        let formattedBirthday = convertDateFormat(selectedDate)
        
        switch authManager.loginType {
        case .kakao:
            return MemberInfo(
                kakaoId: authManager.currentKakaoId,
                appleId: nil,
                memberName: nickname,
                memberBirthday: formattedBirthday,
                memberIncome: incomeValue
            )
            
        case .apple:
            return MemberInfo(
                kakaoId: nil,
                appleId: authManager.currentAppleId,
                memberName: nickname,
                memberBirthday: formattedBirthday,
                memberIncome: incomeValue
            )
            
        case .none:
            print("로그인 타입이 설정되지 않았습니다")
            return MemberInfo(
                kakaoId: nil,
                appleId: nil,
                memberName: nickname,
                memberBirthday: formattedBirthday,
                memberIncome: incomeValue
            )
        }
    }
    
    private func createAppleMemberInfo() -> MemberInfo {
        let apple = getCurrentAppleId()
        
        let incomeValue: String
        if hasIncome {
            incomeValue = currentSelection.apiValue
        } else {
            incomeValue = "없음"  // 빈 문자열 대신 "없음"으로 변경
        }
        let formattedBirthday = convertDateFormat(selectedDate)
        return MemberInfo(
            kakaoId: nil,
            appleId: apple,
            memberName: nickname,
            memberBirthday: formattedBirthday,
            memberIncome: incomeValue
        )
    }
    
    private func getCurrentKakaoId() -> String {
        // AuthManager에서 현재 로그인된 사용자의 kakaoId 가져오기
        return authManager.getCurrentKakaoId()
    }
    
    private func getCurrentAppleId() -> String {
        // AuthManager에서 현재 로그인된 사용자의 AppleId 가져오기
        return authManager.getCurrentAppleId()
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
}
