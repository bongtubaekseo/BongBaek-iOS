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
    
    @Published var contents: [MoreContentItem] = []
    @Published var filteredContents: [MoreContentItem] = []
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
        print("ViewModel 생성됨")
    }
    
    deinit {
            print("ViewModel 해제됨")
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
        filteredContents.removeAll()
        
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
            let categoryParam = selectedCategory == .all ? nil : selectedCategory.rawValue
            let response = try await contentsService.getMoreContents(
                page: currentPage,
                category: categoryParam
            )
            
            if response.isSuccess, let data = response.data {
                let newContents = data.contents
                
                isLastPage = data.isLast
                hasMoreData = !data.isLast
                
                if isRefresh {
                    self.contents = newContents
                    self.filteredContents = newContents
                } else {
                    self.contents.append(contentsOf: newContents)
                    self.filteredContents.append(contentsOf: newContents)
                }
                
//                applyFilter()
                
                print("콘텐츠 로드 성공: \(newContents.count)개, 마지막페이지: \(data.isLast)")
            } else {
                errorMessage = response.message
                isLastPage = true
                hasMoreData = false
                print("콘텐츠 로드 실패: \(response.message)")
                
            }
        } catch {
            errorMessage = "콘텐츠를 불러오는데 실패했습니다: \(error.localizedDescription)"
            print("콘텐츠 로드 에러: \(error)")
            isLastPage = true
            hasMoreData = false
        }
    }
    
    /// 새로고침 (Pull to Refresh 전용)
    func refreshContents() async {
        // 이미 로딩 중이면 중복 실행 방지
        guard !isLoadingData else { return }
        isLoadingData = true
        
        do {
            let categoryParam = selectedCategory == .all ? nil : selectedCategory.rawValue
            // 1. 최신 페이지(0번)만 요청
            let response = try await contentsService.getMoreContents(
                page: 0,
                category: categoryParam
            )
            
            if response.isSuccess, let data = response.data {
                let fetchedItems = data.contents
                
                // 2. 기존에 내 폰에 저장된 데이터(contents)에 없는 ID만 골라냄
                let trulyNewItems = fetchedItems.filter { newItem in
                    !self.contents.contains(where: { $0.contentId == newItem.contentId })
                }
                
                // 3. 진짜 새 데이터가 있을 때만 맨 앞에 넣어줌
                if !trulyNewItems.isEmpty {
                    self.contents.insert(contentsOf: trulyNewItems, at: 0)
                    self.filteredContents.insert(contentsOf: trulyNewItems, at: 0)
                }
                

                
                print("새로고침 완료: \(trulyNewItems.count)개의 새 콘텐츠 추가됨")
            }
        } catch {
            print("새로고침 중 에러 발생: \(error)")
        }
        
        isLoadingData = false
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
//    func refreshContents() async {
//        print(" 콘텐츠 새로고침")
//        await loadAllContents()
//    }
    
    /// 카테고리 변경 (새로 로드)
    func updateCategory(_ category: ScheduleCategory) async {
        guard selectedCategory != category else { return }
        
        selectedCategory = category
        print("카테고리 변경: \(category.displayName)")
        await loadAllContents()
       // applyFilter()
    }
    
    /// 무한스크롤 트리거 확인
    func shouldLoadMore(for content: MoreContentItem) -> Bool {
        guard let lastContent = filteredContents.last else { return false }
        return content.contentId == lastContent.contentId && !isLastPage && !isLoadingMore
    }
    
    func clearError() {
        errorMessage = nil
    }
}
