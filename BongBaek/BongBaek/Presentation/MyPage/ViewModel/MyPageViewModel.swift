//
//  MyPageViewModel.swift
//  BongBaek
//
//  Created by hyunwoo on 9/4/25.
//
import SwiftUI
import Foundation
import Combine

@MainActor
class MyPageViewModel: ObservableObject {
    
    @Published var profileData: UpdateProfileData? = nil
    @Published var isLoadingProfile: Bool = false
    @Published var errorMessage: String? = nil
    
    private let mypageManager = MyPageManager.shared
    private var cancellables =  Set<AnyCancellable>()
    
    func loadprofile(forceRefresh: Bool = false){
        print("MyPageViewModel: 데이터 로드 시작")
        mypageManager.loadProfileData(forceRefresh: forceRefresh)
    }
    
    private func setupBind(){
        mypageManager.$profileData
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] data in
                self?.profileData = data
                print("MyPageViewModel: 업데이트됨 - \(data != nil ? "있음 데이터" : "없어요" )")
            }
            .store(in: &cancellables)
        
        mypageManager.$isLoadingProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                self?.isLoadingProfile = loading
                print("MyPageViewModel: 로딩상태 - \(loading ? "로딩중" : "완료")")
            }
            .store(in: &cancellables)
        
        mypageManager.$profileError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorMessage = error
                if let error = error {
                    print("MyPageViewModel: 에러발생 - \(error)")
                }
            }
            .store(in: &cancellables)
    }
}

extension MyPageViewModel{
    var hasError: Bool{
        return errorMessage != nil
    }
    
    var hasData: Bool {
        return profileData != nil
    }
    
    var shouldShowLoading: Bool {
        return isLoadingProfile || (!hasData && !hasError)
    }
}
