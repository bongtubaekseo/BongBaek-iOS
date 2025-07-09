//
//  EventLocationView.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct EventLocationView: View {
    @State private var searchText = ""
    @State private var selectedLocation: KLDocument?
    @FocusState private var isSearchFieldFocused: Bool
    @EnvironmentObject var stepManager: GlobalStepManager
    @StateObject private var keywordSearch = KeyWordSearch()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                CustomNavigationBar(title: "행사장 위치") {
                    dismiss()
                }
                StepProgressBar(currentStep: 4, totalSteps: 4)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        Text("어디서 열리나요?")
                            .headBold24()
                            .foregroundStyle(.white)
                        
                        Text("주소를 검색하면")
                            .bodyRegular14()
                            .foregroundStyle(.gray300)
                            .padding(.top,8)
                        
                        Text("더 적합한 경조사비를 추천받을 수 있어요!")
                            .bodyRegular14()
                            .foregroundStyle(.gray300)
                    }
                    .padding(.horizontal, 20)

                    ZStack(alignment: .top) {

                        VStack(spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 20))
                                
                                TextField("장소를 검색하세요", text: $searchText)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .focused($isSearchFieldFocused)
                                    .onChange(of: searchText) { newValue in
                                        keywordSearch.query = newValue
                                        keywordSearch.searchResults.removeAll()
                                    }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.gray.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                            
                            
                            MapView()
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 312)
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                        }
                        
                        // 드롭다운 오버레이
                        if !searchText.isEmpty &&
                           !keywordSearch.searchResults.isEmpty &&
                           selectedLocation?.placeName != searchText &&
                           isSearchFieldFocused {
                            
                            VStack(spacing: 0) {
                                Spacer()
                                    .frame(height: 58)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(keywordSearch.searchResults, id: \.id) { document in
                                        Button(action: {
                                            selectedLocation = document
                                            searchText = document.placeName
                                            isSearchFieldFocused = false
                                            keywordSearch.searchResults = []
                                        }) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(document.placeName)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    Text(document.addressName)
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.gray)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    if !document.roadAddressName.isEmpty {
                                                        Text(document.roadAddressName)
                                                            .font(.system(size: 12))
                                                            .foregroundColor(.blue)
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "arrow.up.right")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.gray)
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .contentShape(Rectangle())
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        if document.id != keywordSearch.searchResults.last?.id {
                                            Divider()
                                                .background(Color.gray.opacity(0.3))
                                                .padding(.horizontal, 16)
                                        }
                                    }
                                }
                                .background(Color.gray750)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                                .padding(.top, 4)
                                
                                Spacer()
                            }
                            .zIndex(1)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
                                removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
                            ))
                        }
                    }
                    
                    Button {
                        // 다음 단계 로직
                    } label: {
                        Text("다음 단계로")
                            .titleSemiBold18()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.primaryNormal)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
                .padding(.top,20)
            }
            .offset(y: isSearchFieldFocused ? -140 : 0)

        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.background)
        .animation(.easeInOut(duration: 0.3), value: isSearchFieldFocused)
        .onTapGesture {
            isSearchFieldFocused = false
        }
    }
}
