//
//  EventLocationView.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct EventLocationView: View {
    @GestureState private var isScrolling = false
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    @StateObject private var keywordSearch = KeyWordSearch()
    @State private var mapView: KakaoMapView?
    @State private var showRecommendLoading = false
    
    @EnvironmentObject var stepManager: GlobalStepManager
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager
    @Environment(\.dismiss) private var dismiss
    
    // 버튼 활성화 조건
    private var isNextButtonEnabled: Bool {
        return eventManager.hasLocationData && !eventManager.locationName.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack {
                CustomNavigationBar(title: "행사장 위치") {
                    dismiss()
                }
                StepProgressBar(currentStep: stepManager.currentStep, totalSteps: stepManager.totalSteps)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading) {
                    titleSection
                        .padding(.bottom, 12)
                    
                    // 검색 섹션
                    searchSection
                    
                    // 지도 섹션을 ZStack으로 감싸서 dropdown 오버레이
                    ZStack {
                        mapSection
                            .padding(.top, 30)
                        
                        VStack {
                            if !searchText.isEmpty && isSearchFieldFocused {
                                if keywordSearch.searchResults.isEmpty {
                                    emptySearchResultsOverlay
                                } else {
                                    searchResultsOverlay
                                }
                            }
                            Spacer()
                        }
                        
                        VStack {
                            Spacer()
                            if let selectedLocation = eventManager.selectedLocation {
                                selectedLocationOverlay(selectedLocation)
                            }
                        }
                    }
                    
                    submitButton
                        .padding(.top,60)
                }
                .padding(.top, 32)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        stepManager.currentStep = 4
                    }
                }
                print("EventLocationView 나타남 - step: 4/4")
                print("path.count: \(router.path.count)")
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(.bgDisplayPrimary)
        .onTapGesture {
            isSearchFieldFocused = false
        }
    }
    
    // 선택된 위치 정보를 지도 하단에 표시하는 오버레이
    private func selectedLocationOverlay(_ location: KLDocument) -> some View {
       VStack(alignment: .leading, spacing: 4) {
           Text(location.placeName)
               .titleSemiBold18()
               .foregroundColor(.txtDisplayPrimary)
           
           Text(location.addressName)
               .bodyRegular14()
               .foregroundColor(.txtDisplayTierary)
           
       }
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding(.horizontal, 16)
       .padding(.vertical, 12)
       .background(.bgDisplayCard)
       .overlay(
           RoundedRectangle(cornerRadius: 12)
            .stroke(.bgDisplayCard, lineWidth: 1)
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
    
    private var titleSection: some View {
        VStack(alignment: .leading,spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("어디서 열리나요?")
                    .headBold24()
                    .foregroundStyle(.txtDisplaySecondary)
                
                Spacer()
                
                Button(action: {
                    handleSkipLocation()
                }) {
                    Text("건너뛰기")
                        .bodyRegular14()
                        .foregroundColor(.txtStatusDisabled)
                }
            }
            
            Text("주소를 검색하면 더 빨리 찾을 수 있어요!")
                .bodyRegular14()
                .foregroundStyle(.txtDisplayTierary)
                .padding(.top, 12)
        }
        .padding(.horizontal, 20)
    }

    private var searchSection: some View {
        HStack(spacing: 12) {
            Image("icon_search")
                .foregroundColor(.white)
                .font(.system(size: 20))
            
            TextField("기타 사유를 입력해주세요",
                      text: $searchText,
                      prompt: Text("주소를 검색하면 더 빨리 찾을 수 있어요")
                .foregroundColor(.txtFieldPlaceholder))
                .foregroundColor(textFieldTextColor)
                .font(.body2_regular_16)
                .focused($isSearchFieldFocused)
                .onChange(of: searchText) { _, newValue in
                    keywordSearch.query = newValue
                    keywordSearch.searchResults.removeAll()
                }
            
            // Clear 버튼 추가
            if !searchText.isEmpty && isSearchFieldFocused {
                Button(action: {
                    searchText = ""
                    keywordSearch.searchResults.removeAll()
                    isSearchFieldFocused = false
                }) {
                    Image("icon_delete")
                        .renderingMode(.template)
                        .foregroundColor(.iconDisabledPrimary)
                        .frame(width: 24,height: 24)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.bgFieldSecondary)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(searchFieldBorderColor, lineWidth: 1)
        )
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
    
    private var textFieldTextColor: Color {
        if isSearchFieldFocused {
            // 포커스 상태 (입력 중)
            return .txtFieldValue
        } else if eventManager.hasLocationData && !searchText.isEmpty {
            // 장소 선택 완료 상태
            return .txtStatusFocused
        } else {
            // 기본 상태
            return .txtFieldValue
        }
    }
    
    private var searchFieldBorderColor: Color {
        if eventManager.hasLocationData && !searchText.isEmpty && !isSearchFieldFocused {
            // 장소 선택 완료 상태
            return .bgFieldSecondary
        } else if isSearchFieldFocused {
            // 포커스 상태
            return .borderStatusFocused
        } else {
            // 기본 상태
            return .borderFieldDefault
        }
    }
    
    private var mapSection: some View {
        Group {
            if let mapView = mapView {
                mapView
                    .frame(height: 312)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
            } else {
                Rectangle()
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 312)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .onAppear {
                        mapView = KakaoMapView(draw: .constant(true))
                    }
            }
        }
    }
    
    private var searchResultsOverlay: some View {
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(keywordSearch.searchResults, id: \.id) { document in
                    Button(action: {
                        if !isScrolling {
                            handleLocationSelection(document)
                        }
                    }) {
                        HStack {
                            Text(document.placeName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.txtDisplayPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(.bgDisplayCard)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isScrolling)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 12)
        }
        .simultaneousGesture(
            DragGesture()
                .updating($isScrolling) { _, state, _ in
                    state = true
                }
        )
        .frame(height: min(calculateDropdownHeight(), 164))
        .clipped()
        .background(.bgDisplayCard)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.bgDisplayCard, lineWidth: 1)
        )
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .zIndex(1)
        .transition(.asymmetric(
            insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
            removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
        ))
    }
    private func calculateDropdownHeight() -> CGFloat {
        let textHeight: CGFloat = 16 // 텍스트 높이
        let verticalPadding: CGFloat = 10 + 10 // 상하 패딩
        let cellHeight = textHeight + verticalPadding // 36
        let cellSpacing: CGFloat = 4 // 셀 간격
        let topPadding: CGFloat = 12
        let bottomPadding: CGFloat = 12
        
        let maxItems = 3
        let resultCount = keywordSearch.searchResults.count
        
        if resultCount <= maxItems {
            // 결과 개수만큼: 셀들 + 간격들 + 상하 여백
            let totalHeight = (cellHeight * CGFloat(resultCount)) + (cellSpacing * CGFloat(resultCount - 1)) + topPadding + bottomPadding
            return totalHeight
        } else {
            // 3개 고정: 3개 셀 + 2개 간격 + 상하 여백
            let totalHeight = (cellHeight * 3) + (cellSpacing * 2) + topPadding + bottomPadding
            return totalHeight
        }
    }
    
    
    private var emptySearchResultsOverlay: some View {
         VStack(spacing: 12) {
             Image("icon_caution 1")
                 .font(.system(size: 24))
                 .foregroundColor(.orange)
             
             Text("검색 결과가 없습니다")
                 .bodyMedium16()
                 .foregroundColor(.txtDisplayPrimary)
         }
         .frame(maxWidth: .infinity)
         .padding(.vertical, 32)
         .background(.bgDisplayCard)
         .overlay(
             RoundedRectangle(cornerRadius: 8)
                 .stroke(.bgDisplayCard, lineWidth: 1)
         )
         .cornerRadius(12)
         .padding(.horizontal, 20)
         .padding(.top, 4)
         .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
         .zIndex(1)
         .transition(.asymmetric(
             insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
             removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
         ))
     }
    
    private var submitButton: some View {
        Button {
            handleFormSubmission()
        } label: {
            Text("금액 추천 받기")
                .titleSemiBold18()
                .foregroundColor(isNextButtonEnabled ? .txtInteractiveInverse : .txtStatusDisabled)
        }
        .disabled(!isNextButtonEnabled)
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(isNextButtonEnabled ? .bgStatusFocused : .btnInteractiveDisabled)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 36)
        .animation(.easeInOut(duration: 0.2), value: isNextButtonEnabled)
    }
    
    // MARK: - Methods
    
    private func handleLocationSelection(_ document: KLDocument) {
        // EventCreationManager에 위치 데이터 저장
        eventManager.updateLocationData(selectedLocation: document)
        
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
            print("EventLocationView: UI 검증 실패")
            return
        }
        
        // 현재 선택된 모든 데이터 출력
        printCurrentSelections()
        
        // 다음 화면으로 이동
        if eventManager.canCompleteLocationStep {
            print("EventLocationView: 폼 제출 성공, 추천 로딩으로 이동")
            router.push(to: .recommendLoadingView)
        } else {
            print("EventLocationView: EventCreationManager 이중 검증 실패")
        }
    }
    
    private func handleSkipLocation() {
        print("위치 입력 건너뛰기")
        
        // 위치 데이터 초기화 (선택사항)
        eventManager.clearLocationData()
        
        // 현재 선택된 모든 데이터 출력
        printCurrentSelections()
        
        // 검증 없이 바로 다음 화면으로 이동
        print("EventLocationView: 건너뛰기로 추천 로딩으로 이동")
        router.push(to: .recommendLoadingView)
    }
    
    private func printLocationSelection(_ document: KLDocument) {
        print("EventLocationView 위치 선택:")
        print("장소명: \(document.placeName)")
        print("주소: \(document.addressName)")
        print("도로명: \(document.roadAddressName)")
        print("좌표: \(document.x), \(document.y)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
    
    private func printCurrentSelections() {
        print("EventLocationView 현재 선택된 값들:")
        print("장소명: '\(eventManager.locationName)'")
        print("주소: '\(eventManager.locationAddress)'")
        print("도로명 주소: '\(eventManager.locationRoadAddress)'")
        print("좌표: (\(eventManager.longitude), \(eventManager.latitude))")
        print("위치 데이터 존재: \(eventManager.hasLocationData)")
        print("다음 단계 진행 가능: \(eventManager.canCompleteLocationStep)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}


// MARK: - Helper Extension
extension EventLocationView {
    private func hideKeyboard() {
        isSearchFieldFocused = false
    }
}
