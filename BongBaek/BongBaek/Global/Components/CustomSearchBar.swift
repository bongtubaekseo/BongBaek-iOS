//
//  CustomSearchBar.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI


// MARK: - Search Dropdown Field
struct SearchDropdownField: View {
    @Binding var searchText: String
    @Binding var selectedLocation: KLDocument?
    let placeholder: String
    let onSearch: (String) -> Void
    let onLocationSelected: (KLDocument) -> Void
    
    @StateObject private var keywordSearch = KeyWordSearch()
    @State private var isShowingResults = false
    @State private var isSearching = false
    
    init(
        searchText: Binding<String>,
        selectedLocation: Binding<KLDocument?> = .constant(nil),
        placeholder: String = "장소를 검색하세요",
        onSearch: @escaping (String) -> Void = { _ in },
        onLocationSelected: @escaping (KLDocument) -> Void = { _ in }
    ) {
        self._searchText = searchText
        self._selectedLocation = selectedLocation
        self.placeholder = placeholder
        self.onSearch = onSearch
        self.onLocationSelected = onLocationSelected
    }
    
    var body: some View {
        ZStack(alignment: .top) {

            SearchInputField()
            
            if isShowingResults && !keywordSearch.searchResults.isEmpty {
                VStack(spacing: 0) {

                    Spacer()
                        .frame(height: 62)

                    SearchResultsList()
                }
                .zIndex(1) 
            }
        }
    }
    
    // MARK: - Search Input Field
    private func SearchInputField() -> some View {
        HStack(spacing: 12) {
            // 검색 아이콘
            Image(systemName: isSearching ? "magnifyingglass.circle.fill" : "magnifyingglass")
                .foregroundColor(isSearching ? .blue : .gray)
                .font(.system(size: 20))
                .animation(.easeInOut(duration: 0.2), value: isSearching)
            
            // 텍스트 필드
            TextField(placeholder, text: $searchText)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .onChange(of: searchText) { newValue in
                    handleSearchTextChange(newValue)
                }
                .onSubmit {
                    performSearch()
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.gray.opacity(0.2))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSearching ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(8)
        .animation(.easeInOut(duration: 0.2), value: isSearching)
    }
    
    // MARK: - Search Results List
    private func SearchResultsList() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(keywordSearch.searchResults, id: \.id) { document in // API 결과 사용
                Button(action: {
                    selectLocation(document)
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(document.placeName) // KLDocument 프로퍼티 사용
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(document.addressName) // KLDocument 프로퍼티 사용
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if !document.roadAddressName.isEmpty { // 도로명 주소 표시
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
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.clear)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                // 구분선
                if document.id != keywordSearch.searchResults.last?.id {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.horizontal, 16)
                }
            }
        }
        .background(Color.gray.opacity(0.2))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(8)
        .transition(.asymmetric(
            insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
            removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
        ))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isShowingResults)
    }
    
    // MARK: - Helper Methods
    private func handleSearchTextChange(_ newValue: String) {
        withAnimation {
            isSearching = !newValue.isEmpty
        }
        
        if newValue.isEmpty {
            withAnimation {
                keywordSearch.searchResults = []
                isShowingResults = false
            }
        } else {
            // 실제 API 호출
            keywordSearch.query = newValue
            withAnimation {
                isShowingResults = true
            }
        }
    }
    private func selectLocation(_ document: KLDocument) { // 타입 변경
        selectedLocation = document
        searchText = document.placeName // placeName 사용
        
        withAnimation {
            isShowingResults = false
            keywordSearch.searchResults = []
        }
        
        // 콜백 호출
        onLocationSelected(document)
        onSearch(document.placeName)
    }
    
    private func performSearch() {
        withAnimation {
            isShowingResults = false
        }
        onSearch(searchText)
    }
}
