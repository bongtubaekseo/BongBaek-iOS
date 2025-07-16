//
//  EventManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/14/25.
//

import Foundation
import Combine

@MainActor
class EventManager: ObservableObject {
    static let shared = EventManager()
    
    @Published var homeData: EventHomeData? = nil
    @Published var isLoadingHome = false
    @Published var homeError: String? = nil
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.eventService = DIContainer.shared.eventService
    }
    
    
    /// 홈 데이터 로드 (
    func loadHomeData(forceRefresh: Bool = false) {
        // 캐싱 체크
        if !forceRefresh && homeData != nil {
            print("캐시된 홈 데이터 사용")
            return
        }
        
        isLoadingHome = true
        homeError = nil
        
        eventService.getHome()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingHome = false
                    if case .failure(let error) = completion {
                        self?.homeError = error.localizedDescription
                        print("홈 데이터 로드 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    print("🔄 서버 응답 받음: \(response)")
                    
                    if response.isSuccess, let data = response.data {
                        self?.homeData = data
                        self?.homeError = nil
                        print("홈 데이터 로드 성공")
                    } else {
                        self?.homeError = response.message
                        print("API 응답 실패: \(response.message)")
                    }
                }
            )
            .store(in: &cancellables)
    }

    
    /// 홈 데이터 새로고침
    func refreshHomeData() {
        print("🔄 홈 데이터 새로고침")
        loadHomeData(forceRefresh: true)
    }

    
    /// 에러 초기화
    func clearHomeError() {
        homeError = nil
    }
    
    /// 홈 데이터 초기화
    func clearHomeData() {
        homeData = nil
        homeError = nil
    }
}

// MARK: - Computed Properties
extension EventManager {
    var hasHomeData: Bool {
        return homeData != nil
    }
    
    var hasHomeError: Bool {
        return homeError != nil
    }
    
    var canLoadHome: Bool {
        return !isLoadingHome
    }
}
