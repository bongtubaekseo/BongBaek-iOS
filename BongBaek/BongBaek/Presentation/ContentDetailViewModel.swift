//
//  ContentDetailViewModel.swift
//  BongBaek
//
//  Created by 임재현 on 12/5/25.
//

import Foundation
import Combine


@MainActor
class ContentDetailViewModel: ObservableObject {
    
    @Published var contentDetail: MoreContentsDetailResponseData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let contentsService: ContentsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.contentsService = DIContainer.shared.contentsService
    }
    
    var hasData: Bool {
        contentDetail != nil
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
    
    /// 콘텐츠 상세 조회
    func loadContentDetail(contentId: String) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await contentsService.getMoreContentsDetail(contentId: contentId)
            
            if response.isSuccess, let data = response.data {
                self.contentDetail = data
                print("콘텐츠 상세 조회 성공: \(data)")
            } else {
                errorMessage = response.message
                print("콘텐츠 상세 조회 실패: \(response.message)")
            }
        } catch {
            errorMessage = "콘텐츠를 불러오는데 실패했습니다: \(error.localizedDescription)"
            print("콘텐츠 상세 조회 에러: \(error)")
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
