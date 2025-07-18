//
//  LargeMapView.swift
//  BongBaek
//
//  Created by 임재현 on 7/18/25.
//

import SwiftUI

struct LargeMapView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    @StateObject private var keywordSearch = KeyWordSearch()
    @State private var mapView: KakaoMapView?
    @State private var showRecommendLoading = false
    
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLocation: KLDocument?
    
    // 버튼 활성화 조건
    private var isNextButtonEnabled: Bool {
        return selectedLocation?.placeName.isEmpty == false
    }
    
    var body: some View {
        ScrollView {
            VStack {
                CustomNavigationBar(title: "행사장 위치") {
                    dismiss()
                }
                
                VStack(alignment: .leading) {
                    // 검색 섹션을 ZStack으로 감싸서 드롭다운이 바로 아래에 위치하도록
                    ZStack(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 0) {
                            searchSection
                            
                            // 드롭다운이 표시될 공간 확보
                            if !searchText.isEmpty &&
                               !keywordSearch.searchResults.isEmpty &&
                               isSearchFieldFocused {
                                Color.clear
                                    .frame(height: CGFloat(keywordSearch.searchResults.count) * 60) // 대략적인 높이
                            }
                        }
                        
                        // 드롭다운 오버레이 - searchSection 바로 아래에 위치
                        VStack(alignment: .leading, spacing: 0) {
                            // TextField 높이만큼 공간 확보 (약 48px)
                            Color.clear
                                .frame(height: 48)
                            
                            if !searchText.isEmpty &&
                               !keywordSearch.searchResults.isEmpty &&
                               isSearchFieldFocused {
                                searchResultsOverlay
                            }
                        }
                    }
                    
                    // 지도 섹션
                    ZStack(alignment: .bottom) {
                        mapSection
                            .padding(.top, 16)
                        
                        // 선택된 위치 정보를 지도 하단에 표시
                        if let selectedLocation = selectedLocation {
                            selectedLocationOverlay(selectedLocation)
                        }
                    }
                    
                    submitButton
                }
                .padding(.top, 20)
            }
            .onAppear {
                print("📍 EventLocationView 나타남 - step: 4/4")
                print("⏳ path.count: \(router.path.count)")
            }
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
    
    // 선택된 위치 정보를 지도 하단에 표시하는 오버레이
    private func selectedLocationOverlay(_ location: KLDocument) -> some View {
       VStack(alignment: .leading, spacing: 8) {
           Text(location.placeName)
               .font(.system(size: 18, weight: .semibold))
               .foregroundColor(.white)
           
           Text(location.addressName)
               .font(.system(size: 14))
               .foregroundColor(.gray300)
           
       }
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding(.horizontal, 16)
       .padding(.vertical, 12)
       .background(Color.black.opacity(0.8))
       .overlay(
           RoundedRectangle(cornerRadius: 12)
            .stroke(.gray750, lineWidth: 1)
       )
       .cornerRadius(12)
       .padding(.horizontal, 40)
       .padding(.bottom, 20)
       .zIndex(50)
       .transition(.asymmetric(
           insertion: .move(edge: .bottom).combined(with: .opacity),
           removal: .move(edge: .bottom).combined(with: .opacity)
       ))
    }
    
    // MARK: - View Components
    
    private var searchSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 20))
            
            TextField("장소를 검색하세요", text: $searchText)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .focused($isSearchFieldFocused)
                .onChange(of: searchText) { _, newValue in
                    keywordSearch.query = newValue
                    keywordSearch.searchResults.removeAll()
                }
            
            // Clear 버튼 추가
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    keywordSearch.searchResults.removeAll()
                    isSearchFieldFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
                .transition(.scale.combined(with: .opacity))
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
    }
    
    private var mapSection: some View {
        Group {
            if let mapView = mapView {
                mapView
                    .frame(height: 492)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
            } else {
                Rectangle()
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 492)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .onAppear {
                        mapView = KakaoMapView(draw: .constant(true))
                    }
            }
        }
    }
    
    private var searchResultsOverlay: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(keywordSearch.searchResults, id: \.id) { document in
                Button(action: {
                    handleLocationSelection(document)
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
                    .frame(maxWidth: .infinity)
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
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .zIndex(100) // 높은 zIndex로 설정
        .transition(.asymmetric(
            insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
            removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
        ))
    }
    
    private var submitButton: some View {
        Button {
            handleFormSubmission()
        } label: {
            Text("위치 저장")
                .titleSemiBold18()
                .foregroundColor(isNextButtonEnabled ? .white : .gray400)
        }
        .disabled(!isNextButtonEnabled)
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(isNextButtonEnabled ? .primaryNormal : .gray600)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .animation(.easeInOut(duration: 0.2), value: isNextButtonEnabled)
    }
    
    // MARK: - Methods
    
    private func handleLocationSelection(_ document: KLDocument) {
        // EventCreationManager에 위치 데이터 저장
        selectedLocation = document
        
        // UI 업데이트
        searchText = document.placeName
        isSearchFieldFocused = false
        keywordSearch.searchResults = []
        
        // 지도 위치 업데이트
        if let longitude = Double(document.x),
           let latitude = Double(document.y) {
            mapView?.updateLocation(longitude: longitude, latitude: latitude)
            print("지도 위치 업데이트: \(document.placeName)")
            print("좌표: \(longitude), \(latitude)")
        }
        
        // 선택된 위치 정보 출력
        printLocationSelection(document)
    }
    
    private func handleFormSubmission() {
        guard isNextButtonEnabled else {
            print("⚠️ EventLocationView: UI 검증 실패")
            return
        }
        
        // 현재 선택된 모든 데이터 출력
        printCurrentSelections()
        dismiss()
        // 다음 화면으로 이동
//        if eventManager.canCompleteLocationStep {
//            print("✅ EventLocationView: 폼 제출 성공, 추천 로딩으로 이동")
//            router.push(to: .recommendLoadingView)
//        } else {
//            print("❌ EventLocationView: EventCreationManager 이중 검증 실패")
//        }
    }
    
    private func handleSkipLocation() {
        print("🔄 위치 입력 건너뛰기")
        
        // 위치 데이터 초기화 (선택사항)
//        eventManager.clearLocationData()
        
        // 현재 선택된 모든 데이터 출력
        printCurrentSelections()
        
        // 검증 없이 바로 다음 화면으로 이동
        print("✅ EventLocationView: 건너뛰기로 추천 로딩으로 이동")
//        router.push(to: .recommendLoadingView)
    }
    
    private func printLocationSelection(_ document: KLDocument) {
        print("📍 EventLocationView 위치 선택:")
        print("  🏢 장소명: \(document.placeName)")
        print("  📍 주소: \(document.addressName)")
        print("  🛣️도로명: \(document.roadAddressName)")
        print("  🌍 좌표: \(document.x), \(document.y)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
    
    private func printCurrentSelections() {
        print("📍 EventLocationView 현재 선택된 값들:")
//        print("  🏢 장소명: '\(eventManager.locationName)'")
//        print("  📍 주소: '\(eventManager.locationAddress)'")
//        print("  🛣️ 도로명 주소: '\(eventManager.locationRoadAddress)'")
//        print("  🌍 좌표: (\(eventManager.longitude), \(eventManager.latitude))")
//        print("  📍 위치 데이터 존재: \(eventManager.hasLocationData)")
//        print("  ✅ 다음 단계 진행 가능: \(eventManager.canCompleteLocationStep)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
