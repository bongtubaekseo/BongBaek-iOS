//
//  EventLocationView.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct EventLocationView: View {
    @State private var searchText = ""
    @State private var selectedLocation: LocationItem?
    @FocusState private var isSearchFieldFocused: Bool // 포커스 상태 추가
    @EnvironmentObject var stepManager: GlobalStepManager
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

                    // ZStack으로 검색창과 지도 오버레이
                    ZStack(alignment: .top) {
                        // 기본 레이아웃 (검색창 + 지도)
                        VStack(spacing: 8) {
                            // 검색창 영역 (실제 SearchDropdownField에서 검색창 부분만)
                            HStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 20))
                                
                                TextField("장소를 검색하세요", text: $searchText)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .focused($isSearchFieldFocused) 
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
                            
                            Rectangle()
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 312)
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                        }
                        
                        // 드롭다운 오버레이 - 조건에 포커스 상태 추가
                        if !searchText.isEmpty &&
                           !getSearchResults().isEmpty &&
                           selectedLocation?.name != searchText &&
                           isSearchFieldFocused { // 포커스 상태도 확인
                            
                            VStack(spacing: 0) {
                                // 검색창 높이만큼 공간 확보
                                Spacer()
                                    .frame(height: 58) // 검색창 높이
                                
                                // 드롭다운 결과
                                VStack(alignment: .leading, spacing: 0) {
                                    // 여기에 검색 결과 표시
                                    ForEach(getSearchResults(), id: \.id) { location in
                                        Button(action: {
                                            selectedLocation = location
                                            searchText = location.name
                                            isSearchFieldFocused = false // 포커스 해제
                                        }) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(location.name)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    if let address = location.address {
                                                        Text(address)
                                                            .font(.system(size: 14))
                                                            .foregroundColor(.gray)
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
                                        
                                        if location.id != getSearchResults().last?.id {
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
                                
                                Spacer() // 남은 공간 채우기
                            }
                            .zIndex(1) // 지도 위에 표시
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
                                removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
                            ))
                        }
                    }
                    
                    Button {

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
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.background)
        .onTapGesture {
            isSearchFieldFocused = false // 포커스 해제로 키보드와 드롭다운 모두 숨김
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    stepManager.currentStep = 4
                }
            }
        }
        .onDisappear {
            stepManager.previousStep()
        }
    }
    
    private func getSearchResults() -> [LocationItem] {
        let query = searchText.lowercased()
        let allLocations = [
            LocationItem(name: "강남역 10번출구", address: "서울 강남구 강남대로 지하396", category: "지하철역"),
            LocationItem(name: "강남CGV1", address: "서울 강남구 강남대로 456", category: "영화관"),
            LocationItem(name: "강남CGV2", address: "서울 강남구 강남대로 456", category: "영화관"),
            LocationItem(name: "강남CGV3", address: "서울 강남구 강남대로 456", category: "영화관"),
            LocationItem(name: "강남CGV4", address: "서울 강남구 강남대로 456", category: "영화관"),
            LocationItem(name: "강남CGV5", address: "서울 강남구 강남대로 456", category: "영화관"),
            LocationItem(name: "강남CGV6", address: "서울 강남구 강남대로 456", category: "영화관"),
            LocationItem(name: "영등포역", address: "서울 영등포구 영등포동", category: "지하철역"),
            LocationItem(name: "홍대입구역", address: "서울 마포구 양화로 지하", category: "지하철역"),
        ]
        
        return allLocations.filter { location in
            location.name.lowercased().contains(query)
        }.prefix(7).map { $0 }
    }
}
