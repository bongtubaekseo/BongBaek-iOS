//
//  ProfileSettingViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 7/14/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class ProfileSettingViewModel: ObservableObject {
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
    
    // MARK: - Enums
    enum IncomeSelection: Equatable {
        case under200
        case over200
        case none
        
        var displayText: String {
            switch self {
            case .under200: return "월 200 이하"
            case .over200: return "월 200 이상"
            case .none: return ""
            }
        }
        
        var apiValue: String {
            switch self {
            case .under200: return "200만원 이하"
            case .over200: return "200만원 이상"
            case .none: return ""
            }
        }
    }
    
    // MARK: - Computed Properties
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
    init() {
        setupAuthStateObserver()
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
    
    func performSignUp() {
        guard isStartButtonEnabled else { return }
        
        isSigningUp = true
        
        let memberInfo = createMemberInfo()

        
        authManager.signUp(memberInfo: memberInfo)
        
        // 5초 후 상태 확인
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            print("🔍 5초 후 AuthManager 상태: \(self.authManager.authState)")
            self.isSigningUp = false
        }
    }
    
    func dismissError() {
        showErrorAlert = false
        errorMessage = ""
    }
    
    // MARK: - Private Methods
    private func setupAuthStateObserver() {
        authManager.$authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authState in
                self?.handleAuthStateChange(authState)
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthStateChange(_ authState: AuthManager.AuthState) {
        switch authState {
        case .authenticated:
            // 회원가입 성공
            isSigningUp = false
            navigateToMain = true
            print("회원가입 성공 - 메인으로 이동")
            
        case .needsSignUp:
            // 회원가입 실패 ]
            if isSigningUp { // 회원가입 진행 중이었다면 실패로 간주
                isSigningUp = false
                errorMessage = "회원가입에 실패했습니다. 다시 시도해주세요."
                showErrorAlert = true
                print("회원가입 실패")
            }
            
        case .loading:
            // 로딩 상태 유지
            break
            
        case .needsLogin:
            // 로그인이 필요한 상태로 변경됨 (예상치 못한 상황)
            isSigningUp = false
            errorMessage = "인증이 만료되었습니다. 다시 로그인해주세요."
            showErrorAlert = true
        }
    }
    
    private func convertDateFormat(_ dateString: String) -> String {
           let converted = dateString.replacingOccurrences(of: ".", with: "-")
           print("날짜 형식 변환: \(dateString) → \(converted)")
           return converted
       }
    
    private func createMemberInfo() -> MemberInfo {
        let kakaoId = getCurrentKakaoId()
        
        let incomeValue: String
        if hasIncome {
            incomeValue = currentSelection.apiValue
        } else {
            incomeValue = ""
        }
        let formattedBirthday = convertDateFormat(selectedDate)
        return MemberInfo(
            kakaoId: Int(kakaoId) ?? 0,
            appleId: nil,
            memberName: nickname,            
            memberBirthday: formattedBirthday,
            memberIncome: incomeValue
        )
    }
    
    private func getCurrentKakaoId() -> String {
        // AuthManager에서 현재 로그인된 사용자의 kakaoId 가져오기
        return authManager.getCurrentKakaoId()
    }
}

extension ProfileSettingViewModel {
    func isSelected(_ selection: IncomeSelection) -> Bool {
        return currentSelection == selection
    }
    
    func getSelectedIncomeText() -> String {
        return currentSelection.displayText
    }
    
    func logCurrentSelection() {
        switch currentSelection {
        case .under200:
            print("선택된 수입: 월 200 이하")
        case .over200:
            print("선택된 수입: 월 200 이상")
        case .none:
            print("수입이 선택되지 않음")
        }
    }
}
