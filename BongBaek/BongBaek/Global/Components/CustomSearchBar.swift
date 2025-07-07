//
//  CustomSearchBar.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct LocationItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let address: String?
    let category: String?
    
    var displayText: String {
        if let address = address {
            return "\(name) - \(address)"
        }
        return name
    }
}

// MARK: - Search Dropdown Field
struct SearchDropdownField: View {
    @Binding var searchText: String
    @Binding var selectedLocation: LocationItem?
    let placeholder: String
    let onSearch: (String) -> Void
    let onLocationSelected: (LocationItem) -> Void
    
    @State private var searchResults: [LocationItem] = []
    @State private var isShowingResults = false
    @State private var isSearching = false
    
    init(
        searchText: Binding<String>,
        selectedLocation: Binding<LocationItem?> = .constant(nil),
        placeholder: String = "장소를 검색하세요",
        onSearch: @escaping (String) -> Void = { _ in },
        onLocationSelected: @escaping (LocationItem) -> Void = { _ in }
    ) {
        self._searchText = searchText
        self._selectedLocation = selectedLocation
        self.placeholder = placeholder
        self.onSearch = onSearch
        self.onLocationSelected = onLocationSelected
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // 검색 입력 필드만 (레이아웃에 영향)
            SearchInputField()
            
            // 검색 결과 드롭다운 (완전한 오버레이)
            if isShowingResults && !searchResults.isEmpty {
                VStack(spacing: 0) {
                    // 검색창 높이만큼 공간 확보
                    Spacer()
                        .frame(height: 62) // 검색창 높이 + 간격
                    
                    // 실제 드롭다운 결과
                    SearchResultsList()
                }
                .zIndex(1) // 다른 요소들 위에 표시
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
            ForEach(searchResults, id: \.id) { location in
                Button(action: {
                    selectLocation(location)
                }) {
                    VStack(alignment: .leading, spacing: 4) {
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
                                
                                if let category = location.category {
                                    Text(category)
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
                .background(
                    Color.gray.opacity(0.1)
                        .opacity(0) // 기본은 투명
                )
                
                // 구분선 (마지막 항목 제외)
                if location.id != searchResults.last?.id {
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
                searchResults = []
                isShowingResults = false
            }
        } else {
            // 실제 앱에서는 API 호출이나 데이터베이스 검색
            performMockSearch(query: newValue)
        }
    }
    
    private func performMockSearch(query: String) {
        // 모의 검색 데이터 (실제로는 API 호출)
        let mockData = generateMockSearchResults(for: query)
        
        withAnimation {
            searchResults = mockData
            isShowingResults = !mockData.isEmpty
        }
    }
    
    private func selectLocation(_ location: LocationItem) {
        selectedLocation = location
        searchText = location.name // 선택된 장소 이름으로 텍스트 업데이트
        
        withAnimation {
            isShowingResults = false
            searchResults = []
        }
        
        // 선택된 장소로 검색 실행
        onLocationSelected(location)
        onSearch(location.name)
    }
    
    private func performSearch() {
        withAnimation {
            isShowingResults = false
        }
        onSearch(searchText)
    }
    
    // MARK: - Mock Data Generator
    private func generateMockSearchResults(for query: String) -> [LocationItem] {
        let query = query.lowercased()
        
        // 모의 데이터
        let allLocations = [
            LocationItem(name: "강남역 10번출구", address: "서울 강남구 강남대로 지하396", category: "지하철역"),
            LocationItem(name: "강남역 2번출구", address: "서울 강남구 강남대로 지하390", category: "지하철역"),
            LocationItem(name: "강남CGV", address: "서울 강남구 강남대로 456", category: "영화관"),
            LocationItem(name: "강남구청", address: "서울 강남구 학동로 426", category: "관공서"),
            LocationItem(name: "강남세브란스병원", address: "서울 강남구 언주로 211", category: "병원"),
            LocationItem(name: "영등포역", address: "서울 영등포구 영등포동", category: "지하철역"),
            LocationItem(name: "영등포시장", address: "서울 영등포구 영등포로 지하", category: "전통시장"),
            LocationItem(name: "영등포타임스퀘어", address: "서울 영등포구 영중로 15", category: "쇼핑몰"),
            LocationItem(name: "홍대입구역", address: "서울 마포구 양화로 지하", category: "지하철역"),
            LocationItem(name: "홍대클럽", address: "서울 마포구 홍익로 3길", category: "클럽"),
        ]
        
        let filteredResults = allLocations.filter { location in
            location.name.lowercased().contains(query) ||
            location.address?.lowercased().contains(query) == true ||
            location.category?.lowercased().contains(query) == true
        }
        
        return Array(filteredResults.prefix(5))
    }
}
