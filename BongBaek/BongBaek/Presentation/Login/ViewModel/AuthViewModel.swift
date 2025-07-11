//
//  AuthViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSignUpSuccess = false
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol = DIContainer.shared.authService) {
        self.authService = authService
    }
    
    func signUp(memberInfo: MemberInfo) {
        isLoading = true
        errorMessage = nil
        
        authService.signUp(memberInfo: memberInfo)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.isSuccess, let data = response.data {
                        // ToDo: - 성공 처리 후 토큰 save 함수 생성
                        self?.isSignUpSuccess = true
                    } else {
                        self?.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
}
