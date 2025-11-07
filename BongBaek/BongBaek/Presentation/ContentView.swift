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
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text("경조사 가이드")
                    .titleSemiBold18()
                    .foregroundStyle(.txtDisplayPrimary)
                
                Spacer()
            }

            categoryScrollView
            
            articleCountView
                .padding(.horizontal, 20)
                .padding(.top, -8)
            
            emptyView
                .background(.bgDisplayPrimary)
            
            Spacer()
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
            
            Text("0개")
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
    
    
    

}

