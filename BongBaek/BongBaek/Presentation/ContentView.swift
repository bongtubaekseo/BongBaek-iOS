//
//  ContentView.swift
//  BongBaek
//
//  Created by 임재현 on 11/7/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = ContentViewModel()
    @State private var selectedCategory: ScheduleCategory = .all
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("경조사 가이드")
                    .titleSemiBold18()
                    .foregroundStyle(.txtDisplayPrimary)
                
                Spacer()
            }
            .padding(.vertical, 12)
            
            categoryScrollView
            
            articleCountView
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .center, spacing: 12) {
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.hasError {
                        errorView
                    } else if viewModel.hasData {
                        guideContentView
                    } else {
                        emptyView
                            .background(.bgDisplayPrimary)
                    }
                    
                    if viewModel.isLoadingMore {
                        loadingMoreView
                    }
                }
                
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            
        }
        .background(Color.bgDisplayPrimary)
        
    }
    
    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(ScheduleCategory.allCases, id: \.self) { category in
                    categoryButton(for: category)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 50)
        .clipped()
    }
    
    private func categoryButton(for category: ScheduleCategory) -> some View {
        Button(action: {
            selectedCategory = category
            viewModel.updateCategory(category)
        }) {
            Text(category.displayName)
                .bodyMedium16()
                .foregroundColor(viewModel.selectedCategory == category ? .txtStatusFocused : .txtStatusDisabled)
                .frame(height: 36)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.selectedCategory == category ? .btnInteractiveDisabled : .btnInteractiveSecondary)
                )
        }
    }
    
    private var articleCountView: some View {
        HStack {
            Text("아티클 수")
                .bodyRegular16()
                .foregroundStyle(.txtDisplayTierary)
            
            Spacer()
            
            Text("\(viewModel.filteredGuides.count)개")
                .bodyRegular16()
                .foregroundStyle(.txtDisplaySecondary)
            
        }
    }
    
    private var emptyView: some View {
        VStack(alignment: .center) {
            Text("아직 올라온 가이드가 없어요!")
                .headBold24()
                .foregroundStyle(.txtDisplaySecondary)
                .padding(.top, 60)
            
            Text("빠른 시일 내로 가이드를 제공드릴게요")
                .bodyRegular14()
                .foregroundStyle(.txtDisplayTierary)
                .padding(.top,16)
            
            
            Rectangle()
                .frame(width: 120,height: 120)
                .foregroundStyle(.red)
                .padding(.top, 32)
        }
    }
    
    private var loadingMoreView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primaryNormal))
                .scaleEffect(0.8)
            
            Text("더 많은 일정을 불러오는 중...")
                .bodyRegular14()
                .foregroundColor(.gray400)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다")
                .bodyRegular14()
                .foregroundColor(.gray400)
                .multilineTextAlignment(.center)
            
            Button("다시 시도") {
                Task {
                    await viewModel.loadAllEvents()
                }
            }
            .foregroundColor(.primaryNormal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.primaryNormal)
            Text("이벤트 정보를 불러오는 중...")
                .bodyRegular14()
                .foregroundColor(.gray400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    @ViewBuilder
    private var guideContentView: some View {
        ForEach(viewModel.filteredGuides) { guide in
            GuideCell(guide: guide)
                .onTapGesture {
                    router.push(to: .contentDetailView)
                }
                .onAppear {
                    // 페이지네이션 처리
                }
        }
        
        if !viewModel.hasMoreData {
            VStack(spacing: 12) {
                Text("더 이상 아티클이 없어요!")
                    .bodyRegular14()
                    .foregroundStyle(.txtDisplayTierary)
            }
        }
    }

}

struct GuideCell: View {
    let guide: Guide
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(guide.backgroundImage)
                .resizable()
                .scaledToFill()
                .frame(height: 251)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(guide.category.displayName)
                    .captionRegular12()
                    .foregroundStyle(.txtDisplayPrimary)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.bgDisplayCard)
                    )
                
                Text(guide.title)
                    .titleSemiBold18()
                    .foregroundStyle(.txtInteractiveInverse)
                
                Text(guide.date)
                    .captionRegular12()
                    .foregroundStyle(.txtDisplayTierary)
            }
            .padding(16)
        }
        .frame(height: 251)
        .background(Color.bgDisplayCard)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
