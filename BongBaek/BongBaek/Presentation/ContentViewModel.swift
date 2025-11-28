//
//  ContentViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 11/7/25.
//

import Foundation
import Combine

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var contents: [ContentHomeItem] = []
    @Published var filteredContents: [ContentHomeItem] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCategory: ScheduleCategory = .all
    @Published var hasMoreData = false
    
    // 페이지네이션 관련 상태
    private var currentPage: Int = 0
    private var isLastPage: Bool = false
    private var isLoadingData: Bool = false
    
    private let contentsService: ContentsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.contentsService = DIContainer.shared.contentsService
    }
    
    // MARK: - Computed Properties
    
    var hasData: Bool {
        !filteredContents.isEmpty
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
    
    // MARK: - API Methods
    
    /// 첫 페이지 로드 (새로고침/카테고리 변경 시)
    func loadAllContents() async {
        guard !isLoadingData else { return }
        
        isLoading = true
        isLoadingData = true
        errorMessage = nil
        
        // 페이지네이션 상태 초기화
        currentPage = 0
        isLastPage = false
        contents.removeAll()
        
        await loadContents(isRefresh: true)
        
        isLoading = false
        isLoadingData = false
    }
    
    /// 다음 페이지 로드 (무한스크롤)
    func loadMoreContents() async {
        guard !isLoadingData && !isLastPage else { return }
        
        print("더 많은 이벤트 로드 - 페이지: \(currentPage + 1)")
        
        isLoadingMore = true
        isLoadingData = true
        
        currentPage += 1
        await loadContents(isRefresh: false)
        
        isLoadingMore = false
        isLoadingData = false
    }
    
    /// 실제 API 호출 메서드
    private func loadContents(isRefresh: Bool) async {
        do {
            let response = try await contentsService.getHomeContents()
            
            if response.isSuccess, let data = response.data {
                let newContents = data.contents
                
                if isRefresh {
                    self.contents = newContents
                } else {
                    self.contents.append(contentsOf: newContents)
                }
                
                applyFilter()
                
                print("콘텐츠 로드 성공: \(newContents.count)개")
            } else {
                errorMessage = response.message
                print("콘텐츠 로드 실패: \(response.message)")
            }
        } catch {
            errorMessage = "콘텐츠를 불러오는데 실패했습니다: \(error.localizedDescription)"
            print("콘텐츠 로드 에러: \(error)")
        }
    }
    /// 카테고리 필터 적용'
    private func applyFilter() {
        if selectedCategory == .all {
            filteredContents = contents
        } else {
            filteredContents = contents.filter {
                $0.contentCategory == selectedCategory.rawValue
            }
        }
        print("필터링된 콘텐츠 수: \(filteredContents.count)개")
    }

    
    /// 새로고침
    func refreshContents() async {
        print(" 콘텐츠 새로고침")
        await loadAllContents()
    }
    
    /// 카테고리 변경 (새로 로드)
    func updateCategory(_ category: ScheduleCategory) {
        guard selectedCategory != category else { return }
        
        selectedCategory = category
        print("카테고리 변경: \(category.displayName)")
        
        applyFilter()
    }
    
    /// 무한스크롤 트리거 확인
    func shouldLoadMore(for content: ContentHomeItem) -> Bool {
        guard let lastContent = filteredContents.last else { return false }
        return content.contentId == lastContent.contentId && !isLastPage && !isLoadingMore
    }
    
    func clearError() {
        errorMessage = nil
    }
}
