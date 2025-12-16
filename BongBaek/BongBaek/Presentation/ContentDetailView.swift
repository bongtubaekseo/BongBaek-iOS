//
//  ContentDetailView.swift
//  BongBaek
//
//  Created by 임재현 on 11/8/25.
//

import SwiftUI

struct ContentDetailView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = ContentDetailViewModel()
    let contentId: String
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "") {
                router.pop()
            }
            
            if viewModel.isLoading {
                loadingView
            } else if viewModel.hasError {
                errorView
            } else if let detail = viewModel.contentDetail {
                contentDetailView(detail)
            }
        }
        .task {
            await viewModel.loadContentDetail(contentId: contentId)
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.bgDisplayPrimary)
    }
    
    private func contentDetailView(_ detail: MoreContentsDetailResponseData) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(detail.contentCategory)
                        .captionRegular12()
                        .foregroundStyle(.txtStatusFocused)
                    
                    Text(detail.contentTitle)
                        .titleSemiBold20()
                        .foregroundStyle(.txtDisplayPrimary)
                        .padding(.top, 2)
                        
                    Text(detail.createdAt.dotDateFormat())
                        .bodyRegular14()
                        .foregroundStyle(.txtDisplayTierary)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                
                Rectangle()
                    .fill(Color.borderDisplayTitle) 
                    .frame(height: 10)
                    .padding(.top, 20)
                
                VStack(spacing: 8) {
                    ForEach(detail.imageUrls, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                Color.gray300
                                    .frame(height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure:
                                Color.gray300
                                    .frame(height: 200)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    )
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
//                .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.primaryNormal)
            Text("콘텐츠를 불러오는 중...")
                .bodyRegular14()
                .foregroundColor(.txtDisplayTierary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다")
                .bodyRegular14()
                .foregroundColor(.txtDisplayTierary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Button("다시 시도") {
                Task {
                    await viewModel.loadContentDetail(contentId: contentId)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(.bgStatusFocused)
            .foregroundColor(.txtInteractiveInverse)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
