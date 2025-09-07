//
//  HomeViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI

import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var homeData: EventHomeData? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let eventManager = EventManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        print("HomeViewModel 초기화됨")
    }
    
    
    /// 홈 데이터 로드 (
    func loadData(forceRefresh: Bool = false) {
        print("HomeViewModel: 데이터 로드 시작 (Combine)")
        eventManager.loadHomeData(forceRefresh: forceRefresh)
    }

    
    /// 새로고침
    func refreshData() {
        print("HomeViewModel: 데이터 새로고침")
        loadData(forceRefresh: true)
    }

    
    /// 에러 해제
    func dismissError() {
        eventManager.clearHomeError()
    }
    
    // MARK: - Private Methods
    
    /// EventManager의 상태를 구독하여 ViewModel 상태 업데이트
    private func setupBindings() {
        // 홈 데이터 구독
        eventManager.$homeData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.homeData = data
                print("HomeViewModel: homeData 업데이트됨 - \(data != nil ? "데이터 있음" : "데이터 없음")")
            }
            .store(in: &cancellables)
        
        // 로딩 상태 구독
        eventManager.$isLoadingHome
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                self?.isLoading = loading
                print("HomeViewModel: 로딩 상태 - \(loading ? "로딩 중" : "완료")")
            }
            .store(in: &cancellables)
        
        // 에러 메시지 구독
        eventManager.$homeError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorMessage = error
                if let error = error {
                    print("HomeViewModel: 에러 발생 - \(error)")
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Computed Properties
extension HomeViewModel {
    /// 에러가 있는지 확인
    var hasError: Bool {
        return errorMessage != nil
    }
    
    /// 데이터가 있는지 확인
    var hasData: Bool {
        return homeData != nil
    }
    
    /// 새로고침 가능한지 확인
    var canRefresh: Bool {
        return !isLoading
    }
    
    /// 로딩 또는 데이터가 없는 상태
    var shouldShowLoading: Bool {
        return isLoading || (!hasData && !hasError)
    }
}
