//
//  LargeMapView.swift
//  BongBaek
//
//  Created by 임재현 on 7/18/25.
//

import SwiftUI

struct LargeMapView: View {
    @Binding var selectedLocation: KLDocument? // 바인딩으로 변경
    
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    @StateObject private var keywordSearch = KeyWordSearch()
    @State private var mapView: KakaoMapView?
    @State private var tempSelectedLocation: KLDocument? // 임시 선택 위치
    
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    // 버튼 활성화 조건
    private var isNextButtonEnabled: Bool {
        return tempSelectedLocation?.placeName.isEmpty == false
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                     Button(action: {
                         dismiss()
                     }) {
                         Image(systemName: "xmark")
                             .font(.system(size: 18, weight: .medium))
                             .foregroundColor(.white)
                     }
                     .frame(width: 44, height: 44)
                     .padding(.leading, -8)
                     
                     Spacer()
                     
                     Text("행사장 검색")
                         .titleSemiBold18()
                         .foregroundColor(.white)
                     
                     Spacer()
                     
                     Color.clear
                         .frame(width: 44, height: 44)
                 }
                 .padding(.horizontal, 20)
                 .padding(.top, 8)
                 .padding(.bottom, 16)
                 .background(.gray900)
                
                VStack(alignment: .leading) {
                    // 검색 섹션
                    searchSection
                    
                    // 지도 섹션을 ZStack으로 감싸서 dropdown 오버레이
                    ZStack {
                        mapSection
                            .padding(.top, 16)
                        
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
                            if let tempLocation = tempSelectedLocation {
                                selectedLocationOverlay(tempLocation)
                            }
                        }
                    }
                    
                    submitButton
                        .padding(.top,20)
                }
                .padding(.top, 8)
            }
            .onAppear {
                print("LargeMapView 나타남")
                // 기존에 선택된 위치가 있다면 복원
                if let existingLocation = selectedLocation {
                    tempSelectedLocation = existingLocation
                    searchText = existingLocation.placeName
                    updateMapLocation(existingLocation)
                }
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
               .titleSemiBold18()
               .foregroundColor(.white)
           
           Text(location.addressName)
               .bodyRegular14()
               .foregroundColor(.gray400)
           
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
            
            TextField("기타 사유를 입력해주세요",
                      text: $searchText,
                      prompt: Text("주소를 검색하면 더 빨리 찾을 수 있어요")
                .foregroundColor(.gray500))
                .foregroundColor(.white)
                .font(.body2_regular_16)
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
                        // 지도 생성 후 기존 위치가 있다면 업데이트
                        if let existingLocation = selectedLocation {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                updateMapLocation(existingLocation)
                            }
                        }
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
                                .titleSemiBold18()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(document.addressName)
                                .bodyRegular14()
                                .foregroundColor(.gray400)
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
                        .background(Color.gray750.opacity(0.3))
                        .padding(.horizontal, 16)
                }
            }
        }
        .background(Color.gray750)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray750, lineWidth: 1)
                .padding(.vertical, 14)
        )
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .shadow(color: .gray750.opacity(0.1), radius: 8, x: 0, y: 4)
        .zIndex(100)
        .transition(.asymmetric(
            insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
            removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
        ))
    }
    
    private var emptySearchResultsOverlay: some View {
         VStack(spacing: 12) {
             Image("icon_caution 1")
                 .font(.system(size: 24))
                 .foregroundColor(.orange)
             
             Text("검색 결과가 없습니다")
                 .bodyMedium16()
                 .foregroundColor(.white)
         }
         .frame(maxWidth: .infinity)
         .padding(.vertical, 32)
         .background(Color.gray750)
         .overlay(
             RoundedRectangle(cornerRadius: 8)
                 .stroke(Color.gray.opacity(0.5), lineWidth: 1)
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
            Text("위치 저장")
                .titleSemiBold18()
                .foregroundColor(isNextButtonEnabled ? .white : .gray500)
        }
        .disabled(!isNextButtonEnabled)
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(isNextButtonEnabled ? .primaryNormal : .primaryBg)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 60)
        .animation(.easeInOut(duration: 0.2), value: isNextButtonEnabled)
    }
    
    // MARK: - Methods
    
    private func handleLocationSelection(_ document: KLDocument) {
        // 임시 선택 위치 설정
        tempSelectedLocation = document
        
        // UI 업데이트
        searchText = document.placeName
        isSearchFieldFocused = false
        keywordSearch.searchResults = []
        
        // 지도 위치 업데이트
        updateMapLocation(document)
        
        // 선택된 위치 정보 출력
        printLocationSelection(document)
    }
    
    private func updateMapLocation(_ document: KLDocument) {
        if let longitude = Double(document.x),
           let latitude = Double(document.y) {
            mapView?.updateLocation(longitude: longitude, latitude: latitude)
            print("지도 위치 업데이트: \(document.placeName)")
            print("좌표: \(longitude), \(latitude)")
        }
    }
    
    private func handleFormSubmission() {
        guard isNextButtonEnabled,
              let tempLocation = tempSelectedLocation else {
            print("LargeMapView: UI 검증 실패")
            return
        }
        
        // 바인딩을 통해 부모 뷰에 위치 전달
        selectedLocation = tempLocation
        
        print("위치 저장 완료: \(tempLocation.placeName)")
        print("주소: \(tempLocation.addressName)")
        print("좌표: \(tempLocation.x), \(tempLocation.y)")
        
        // 이전 화면으로 돌아가기
        dismiss()
    }
    
    private func printLocationSelection(_ document: KLDocument) {
        print("LargeMapView 위치 선택:")
        print("장소명: \(document.placeName)")
        print("주소: \(document.addressName)")
        print("도로명: \(document.roadAddressName)")
        print("좌표: \(document.x), \(document.y)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
