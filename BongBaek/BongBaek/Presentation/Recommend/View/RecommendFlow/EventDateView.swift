//
//  EventDateView.swift
//  BongBaek
//
//  Created by 김현우 on 7/4/25.
//

import SwiftUI

// MARK: - AttendanceType Model
enum AttendanceType: String, CaseIterable {
    case yes = "예"
    case no = "아니오"
}

// MARK: - EventDateView
struct EventDateView: View {
    // EventCreationManager 바인딩
    @EnvironmentObject var stepManager: GlobalStepManager
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager
    @Environment(\.dismiss) private var dismiss
    
    // UI 전용 상태
    @State private var isDatePickerVisible = false
    @State private var isPastDate = false
    
    // 기존 검증 로직 유지 (UI 반응용)
    private var isNextButtonEnabled: Bool {
        return eventManager.selectedAttendance != nil && !isPastDate
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "날짜 정보") {
                dismiss()
            }

            StepProgressBar(currentStep: stepManager.currentStep, totalSteps: stepManager.totalSteps)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            
            EventDateTitleView()
                .padding(.top, 12)
            
            EventDateFormView()
                .padding(.horizontal, 24)
                .padding(.top, 30)
            
            Spacer()
            
            NextButton(
                isEnabled: isNextButtonEnabled,
                action: {
                    handleFormSubmission()
                }
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    stepManager.currentStep = 3
                }
            }
            print("EventDateView 나타남 - path.count: \(router.path.count)")
        }
        .onChange(of: eventManager.eventDate) { _, newDate in
            checkDateAndUpdateUI(newDate)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background"))
        .sheet(isPresented: $isDatePickerVisible) {
            DatePickerBottomSheet(
                selectedDate: $eventManager.eventDate,
                onDismiss: { isDatePickerVisible = false }
            )
        }
    }
    
    // MARK: - Methods
    
    private func handleFormSubmission() {
        guard isNextButtonEnabled else {
            print("EventDateView: UI 검증 실패")
            return
        }
        
        // 현재 선택된 모든 데이터 출력
        printCurrentSelections()
        
        // 다음 화면으로 이동
        handleNextNavigation()
    }
    
    private func handleNextNavigation() {
        switch eventManager.selectedAttendance {
        case .yes:
            // 참석 → 장소 선택 필요
            print("참석 예정 → EventLocationView로 이동")
            router.push(to: .eventLocationView)
            
        case .no:
            // 불참 → 장소 건너뛰고 바로 추천으로
            print("불참 → EventLocationView 건너뛰고 RecommendLoadingView로 이동")
            eventManager.clearLocationData() // 불참 시 위치 데이터 초기화
            router.push(to: .recommendLoadingView)
            
        case nil:
            // 선택 안함 (일반적으로 버튼이 비활성화되어야 함)
            print("참석 여부 미선택")
        }
    }
    
    private func checkDateAndUpdateUI(_ date: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: date)
        
        isPastDate = selectedDay < today
        
        if isPastDate {
            print("과거 날짜 선택됨: \(date)")
        }
    }
    
    private func printCurrentSelections() {
        print("EventDateView 현재 선택된 값들:")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        
        print("선택된 날짜: \(formatter.string(from: eventManager.eventDate))")
        print("참석 여부: \(eventManager.selectedAttendance?.rawValue ?? "미선택")")
        print("과거 날짜 여부: \(isPastDate)")
        print("다음 단계 진행 가능: \(eventManager.canCompleteDateStep)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}

// MARK: - Supporting Views
struct EventDateTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("행사 날짜와 참석여부를")
                .headBold24()
                .foregroundColor(.white)
            
            Text("알려주세요")
                .headBold24()
                .foregroundColor(.white)
            
            Text("봉투백서가 경조사 일정을 관리해드릴게요!")
                .bodyRegular14()
                .foregroundColor(Color(hex: "#7A7F8A"))
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
}

struct EventDateFormView: View {
    @EnvironmentObject var eventManager: EventCreationManager
    @State private var isDatePickerVisible = false
    @State private var isPastDate = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 날짜 선택 섹션
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image("icon_calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    
                    Text("행사 날짜를 알려주세요")
                        .titleSemiBold18()
                        .foregroundColor(.white)
                }
                
                EventDatePickerView()
                
                if isPastDate {
                    HStack(spacing: 2) {
                        Image("icon_caution")
                            .foregroundColor(.secondaryRed)
                        
                        Text("앞으로 다가올 일정만 입력할 수 있어요")
                            .captionRegular12()
                            .foregroundColor(.secondaryRed)
                    }
                    .padding(.top, -8)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.gray750)
            )
            
            // 참석 여부 섹션
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image("icon_check2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    
                    Text("참석 여부")
                        .titleSemiBold18()
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 12) {
                    ForEach(AttendanceType.allCases, id: \.self) { attendance in
                        AttendanceButton(
                            attendanceType: attendance,
                            isSelected: eventManager.selectedAttendance == attendance,
                            action: {
                                eventManager.selectedAttendance = attendance
                                eventManager.isAttend = (attendance == .yes)
                                print("참석 여부 선택: \(attendance.rawValue)")
                            }
                        )
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.gray750)
            )
        }
        .onChange(of: eventManager.eventDate) { _, newDate in
            checkDateAndUpdateUI(newDate)
        }
    }
    
    private func checkDateAndUpdateUI(_ date: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: date)
        
        isPastDate = selectedDay < today
    }
}

struct EventDatePickerView: View {
    @EnvironmentObject var eventManager: EventCreationManager
    @State private var isDatePickerVisible = false
    @State private var isPastDate = false
    
    var body: some View {
        Button(action: {
            isDatePickerVisible.toggle()
        }) {
            HStack {
                Text(DateFormatter.displayFormatter.string(from: eventManager.eventDate))
                    .bodyRegular16()
                    .foregroundColor(isPastDate ? .secondaryRed : .white)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray800)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isPastDate ? Color.secondaryRed : Color.lineNormal, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onChange(of: eventManager.eventDate) { _, newDate in
            checkDateAndUpdateUI(newDate)
        }
        .sheet(isPresented: $isDatePickerVisible) {
            DatePickerBottomSheet(
                selectedDate: $eventManager.eventDate,
                onDismiss: { isDatePickerVisible = false }
            )
        }
    }
    
    private func checkDateAndUpdateUI(_ date: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: date)
        
        isPastDate = selectedDay < today
    }
}

struct AttendanceButton: View {
    let attendanceType: AttendanceType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(attendanceType.rawValue)
                .bodyMedium16()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color("primary_normal") : Color.black.opacity(0.4))
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.196, green: 0.196, blue: 0.196))
            )
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .regular))
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}

struct DatePickerBottomSheet: View {
    @Binding var selectedDate: Date
    let onDismiss: () -> Void
    @State private var tempDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray)
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                
                Text("날짜 선택")
                    .titleSemiBold18()
                    .foregroundColor(.white)
                
                DatePicker(
                    "날짜를 선택해주세요",
                    selection: $tempDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .colorScheme(.dark)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray750)
                )
                .labelsHidden()
                .onAppear {
                    tempDate = selectedDate
                }
                
                Spacer()
                
                Button("선택 완료") {
                    selectedDate = tempDate
                    onDismiss()
                }
                .font(.title_semibold_18)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("primary_normal"))
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 34)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.gray750)
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
