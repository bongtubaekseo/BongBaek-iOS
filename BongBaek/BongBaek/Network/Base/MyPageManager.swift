//
//  MyPageManager.swift
//  BongBaek
//
//  Created by hyunwoo on 9/4/25.
//

import Foundation
import Combine

@MainActor
class MyPageManager: ObservableObject {
    static let shared = MyPageManager()
    
    @Published var profileData: UpdateProfileData? = nil
    @Published var isLoadingProfile = false
    @Published var profileError: String? = nil
    @Published var isUpdateSuccess = false
    
    private let userService: MyPageServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        self.userService = DIContainer.shared.userService
    }
    
    func loadProfileData(forceRefresh: Bool = false){
        print("새로운 마이페이지 데이터 로드 시작")
        isLoadingProfile = true
        profileError = nil
        
        userService.getProfile()
            .receive(on:DispatchQueue.main)
            .sink(
                receiveCompletion: {[weak self] completion in
                    self?.isLoadingProfile = false
                    if case .failure(let error) = completion {
                        self?.profileError = error.localizedDescription
                        print("마이페이지 데이터 로드 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    print("서버 응답 받음: \(response)")
                    
                    if response.isSuccess, let data = response.data{
                        self?.profileData = data
                        self?.profileError = nil
                        print("마이페이지 데이터 로드 성공")
                    } else {
                        self?.profileError = response.message
                        print("API 응답 실패: \(response.message)")
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func updateProfile(updateData: UpdateProfileData) {
        print("프로필 업데이트 시작: \(updateData)")
        isLoadingProfile = true
        profileError = nil
        isUpdateSuccess = false
        
        userService.updateProfile(profileData: updateData)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingProfile = false
                    if case .failure(let error) = completion {
                        self?.profileError = error.localizedDescription
                        self?.isUpdateSuccess = false
                        print("프로필 업데이트 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    print("프로필 업데이트 응답: \(response)")
                    
                    if response.isSuccess {
                        // 성공 시 로컬 데이터도 업데이트
                        self?.profileData = updateData
                        self?.profileError = nil
                        self?.isUpdateSuccess = true
                        print("프로필 업데이트 성공")
                    } else {
                        self?.profileError = response.message
                        self?.isUpdateSuccess = false
                        print("프로필 업데이트 API 실패: \(response.message)")
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func resetUpdateSuccess() {
        isUpdateSuccess = false
        print("MyPageManager: isUpdateSuccess 리셋 완료")
    }
    
}
extension Notification.Name {
    static let profileUpdateSuccess = Notification.Name("profileUpdateSuccess")
}
