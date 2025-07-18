//
//  AuthViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI
import Combine

//class AuthViewModel: ObservableObject {
//    @Published var isLoading = false
//    @Published var isLoginSuccess = false
//    @Published var errorMessage: String?
//    @Published var isSignUpSuccess = false
//    
//    private let authService: AuthServiceProtocol
//    private var cancellables = Set<AnyCancellable>()
//    
//         {
//        self.authService = authService
//    }
//    
//    func signUp(memberInfo: MemberInfo) {
//        isLoading = true
//        errorMessage = nil
//        
//        authService.signUp(memberInfo: memberInfo)
//            .sink(
//                receiveCompletion: { [weak self] completion in
//                    self?.isLoading = false
//                    if case .failure(let error) = completion {
//                        self?.errorMessage = error.localizedDescription
//                    }
//                },
//                receiveValue: { [weak self] response in
//                    if response.isSuccess, let data = response.data {
//                        // ToDo: - 성공 처리 후 토큰 save 함수 생성
//                        self?.isSignUpSuccess = true
//                    } else {
//                        self?.errorMessage = response.message
//                    }
//                }
//            )
//            .store(in: &cancellables)
//    }
//    
//    func login(accessToken: String) {
//        isLoading = true
//        errorMessage = nil
//        
//        authService.login(accessToken: accessToken)
//            .sink(
//                receiveCompletion: { [weak self] completion in
//                    self?.isLoading = false
//                    if case .failure(let error) = completion {
//                        self?.errorMessage = error.localizedDescription
//                    }
//                },
//                receiveValue: { [weak self] response in
//                    if response.isSuccess, let data = response.data {
//                        if data.isCompletedSignUp {
//                            // 기존 회원 - 로그인 성공
//                            if let token = data.token {
//                                // ToDo: - 성공 처리 후 토큰 save 함수 생성
//                                self?.isLoginSuccess = true
//                            }
//                        } else {
//                            // ToDo: - 신규 회원/회원가입 필요
//                            self?.navigateToSignUp(kakaoId: data.kakaoId, kakaoAccessToken: data.kakaoAccessToken)
//                        }
//                    } else {
//                        self?.errorMessage = response.message
//                    }
//                }
//            )
//            .store(in: &cancellables)
//    }
//    
//    private func navigateToSignUp(kakaoId: Int, kakaoAccessToken: String?) {
//        // ToDo:- 회원가입 화면으로 이동 로직
//        // kakaoId와 kakaoAccessToken을 전달
//    }
//    
//    func retryToken() {
//        isLoading = true
//        errorMessage = nil
//        
//        authService.retryToken()
//            .sink(
//                receiveCompletion: { [weak self] completion in
//                    self?.isLoading = false
//                    if case .failure(let error) = completion {
//                        self?.errorMessage = error.localizedDescription
//                    }
//                },
//                receiveValue: { [weak self] response in
//                    if response.isSuccess, let tokenData = response.data {
//                        // 토큰 재발급 성공
//                        // ToDo: - 성공 처리 후 토큰 save 함수 생성
//                        print("토큰 재발급 성공")
//                    } else {
//                        // 토큰 재발급 실패 (리프레시 토큰 만료 등)
//                        self?.errorMessage = response.message
//                        self?.handleRefreshTokenExpired()
//                    }
//                }
//            )
//            .store(in: &cancellables)
//    }
//
//    private func handleRefreshTokenExpired() {
//        // 리프레시 토큰도 만료된 경우 로그아웃 처리
//        // 로그인 화면으로 이동 로직
//    }
//}
