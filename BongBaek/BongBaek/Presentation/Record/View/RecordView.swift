//
//  RecordView.swift
//  BongBaek
//
//  Created by 임재현 on 6/28/25.
//

import SwiftUI

enum EventsCategory: String, CaseIterable {
    case all = "전체"
    case wedding = "결혼식"
    case babyParty = "돌잔치"
    case birthday = "생일"
    case funeral = "장례식"
    
    var display: String {
        return self.rawValue
    }
}

struct RecordView: View {
    @State private var isDeleteMode = false
    @State private var selectedSection: RecordSection = .attended
    @State private var selectedCategory: EventsCategory = .all

    var attendedRecords: [ScheduleModel] {

        return Array(scheduleDummy.prefix(2))
    }
    
    var notAttendedRecords: [ScheduleModel] {

        return Array(scheduleDummy.suffix(1))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                RecordsHeaderView(isDeleteMode: $isDeleteMode)
                
//                CategoryFilterView(selectedCategory: $selectedCategory)
                
                RecordSectionHeaderView(
                    selectedSection: $selectedSection,
                    attendedCount: attendedRecords.count,
                    notAttendedCount: notAttendedRecords.count
                )
                .padding(.bottom, 20)
                
                CategoryFilterView(selectedCategory: $selectedCategory)
                    .padding(.leading, 20)
                
                RecordContentView(
                    selectedSection: selectedSection,
                    attendedRecords: attendedRecords,
                    notAttendedRecords: notAttendedRecords,
                    isDeleteMode: isDeleteMode
                )
            }
        }
        .background(Color.background)
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: EventsCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10){
                ForEach(EventsCategory.allCases, id: \.self) { category in
                    Button(action : {
                        selectedCategory = category
                    }){
                        Text(category.display)
                            .bodyMedium14()
                            .foregroundColor(selectedCategory == category ? .black : .gray300)
                            .frame(height : 40)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedCategory == category ? .gray100 : .gray700)
                            )
                    }
                }
            }
        }
    }
}


struct RecordsHeaderView: View {
    @Binding var isDeleteMode: Bool
    @State private var showModifyView = false
    
    var body: some View {
        HStack {
            Text("경조사 전체 기록")
                .titleSemiBold18()
                .foregroundStyle(.white)
            
            Spacer()
            
            HStack(spacing: 0) {
                NavigationLink(destination: ModifyEventView(mode: .create)) {
                   Image(systemName: "plus")
                       .font(.system(size: 18, weight: .medium))
                       .foregroundColor(.white)
               }
               .frame(width: 44, height: 44)
               .contentShape(Rectangle())
            

                Button(action: {
                    print("삭제하기 버튼 클릭됨")
                    isDeleteMode.toggle()
                }) {
                    Image(systemName: isDeleteMode ? "checkmark" : "trash")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isDeleteMode ? .blue : .white)
                }
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}


struct RecordSectionHeaderView: View {
    @Binding var selectedSection: RecordSection
    let attendedCount: Int
    let notAttendedCount: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // 참석했어요 탭
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedSection = .attended
                }
            }) {
                VStack(spacing: 8) {
                    HStack {
                        Text("참석했어요")
                            .titleSemiBold16()
                            .foregroundColor(selectedSection == .attended ? .white : .gray)

                    }
                    
                    Rectangle()
                        .fill(selectedSection == .attended ? .blue : .clear)
                        .frame(height: 1)
                }
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedSection = .notAttended
                }
            }) {
                VStack(spacing: 8) {
                    HStack {
                        Text("불참했어요")
                            .titleSemiBold16()
                            .foregroundColor(selectedSection == .notAttended ? .white : .gray)
                    }
                    
                    Rectangle()
                        .fill(selectedSection == .notAttended ? .blue : .clear)
                        .frame(height: 1)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

struct RecordContentView: View {
    let selectedSection: RecordSection
    let attendedRecords: [ScheduleModel]
    let notAttendedRecords: [ScheduleModel]
    let isDeleteMode: Bool
    
    var body: some View {
        VStack {
            switch selectedSection {
            case .attended:
                if attendedRecords.isEmpty {
                    RecordsEmptyView(message: "참석한 경조사가 없습니다")
                } else {
                    ForEach(attendedRecords, id: \.id) { record in
                        RecordCellView(record: record, isDeleteMode: isDeleteMode)
                    }
                }
                
            case .notAttended:
                if notAttendedRecords.isEmpty {
                    RecordsEmptyView(message: "불참한 경조사가 없습니다")
                } else {
                    ForEach(notAttendedRecords, id: \.id) { record in
                        RecordCellView(record: record, isDeleteMode: isDeleteMode)
                    }
                }
            }
        }
        .padding(.top, 20)
        .animation(.easeInOut(duration: 0.2), value: selectedSection)
    }
}

struct RecordsEmptyView: View {
    let message: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(message)
                .headBold24()
                .foregroundColor(.white)
            
            Text("지금 경조사를 기록하고")
                .bodyRegular14()
                .foregroundColor(.gray300)
                .padding(.top, 16)
            
            Text("상황에 어울리는 경조사비까지 추천받으세요")
                .bodyRegular14()
                .foregroundColor(.gray300)
            
            Image("Mask Group 5")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding(.top, 16)
            
            NavigationLink(destination: ModifyEventView(mode: .create)) {
                Text("지금 기록하기")
                    .titleSemiBold16()
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.primaryNormal)
            .cornerRadius(12)
            .padding(.horizontal, 40)
            .padding(.top, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
}

struct RecordCellView: View {
    let record: ScheduleModel
    let isDeleteMode: Bool
    @State private var isSelected = false
    
    var body: some View {
        HStack(spacing: 12) { // spacing을 0에서 12로 변경
            if isDeleteMode {
                Button(action: {
                    isSelected.toggle()
                }) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .red : .gray)
                        .font(.system(size: 20))
                }
                .frame(width: 30)
                .transition(.move(edge: .leading).combined(with: .opacity))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("nickname")
                    .captionRegular12()
                    .foregroundColor(.primaryNormal)

                HStack {
                    Text(record.name)
                        .titleSemiBold18()
                        .foregroundColor(.white)
                    Spacer()
                    Text(record.money)
                        .titleSemiBold18()
                        .foregroundColor(.white)
                }

                HStack {
                    HStack(spacing: 8) {
                        Text(record.type)
                            .captionRegular12()
                            .foregroundColor(.primaryNormal)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.primaryNormal.opacity(0.1))
                            .cornerRadius(4)
                        Text(record.relation)
                            .captionRegular12()
                            .foregroundColor(.primaryNormal)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.primaryNormal.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    Text(record.date)
                        .captionRegular12()
                        .foregroundColor(.gray400)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.gray750)
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .animation(.easeInOut(duration: 0.3), value: isDeleteMode)
    }
}

enum RecordSection {
    case attended
    case notAttended
}

struct RecordModel: Identifiable {
    let id = UUID()
    let eventName: String
    let date: String
    let amount: Int
    let isAttended: Bool
    let location: String
    let relation: String
    let type: String
}
