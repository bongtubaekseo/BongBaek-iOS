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
    @StateObject private var viewModel = EventDateViewModel()
    @EnvironmentObject var stepManager: GlobalStepManager
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "날짜 정보") {
                           dismiss()
                       }
                       .padding(.top, 40)
                       
                       StepProgressBar(currentStep: stepManager.currentStep, totalSteps: stepManager.totalSteps)
                           .padding(.horizontal, 20)
                           .padding(.bottom, 10)
            
            EventDateTitleView()
                .padding(.top, 12)
            
            
            EventDateFormView(viewModel: viewModel)
                .padding(.horizontal, 24)
                .padding(.top, 30)
            
            Spacer()
            
            NextButton(
                isEnabled: viewModel.isNextButtonEnabled,
                action: {
                    router.push(to: .eventLocationView)
                }
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
        .onAppear {
              print("📅 EventDateView 나타남 - path.count: \(router.path.count)")
          }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background"))
        .ignoresSafeArea()
        .sheet(isPresented: $viewModel.isDatePickerVisible) {
            DatePickerBottomSheet(
                selectedDate: Binding(
                    get: { viewModel.selectedDate ?? Date() },
                    set: { newDate in
                        viewModel.selectedDate = newDate
                        viewModel.checkDateAndUpdateUI()
                    }
                ),
                onDismiss: { viewModel.isDatePickerVisible = false }
            )
        }
//        .navigationDestination(isPresented: $viewModel.showEventLocationView) {
//            EventLocationView()
//                .environmentObject(stepManager)
//                .environmentObject(router)
//        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    stepManager.currentStep = 3
                }
            }
        }
        .onDisappear {
            if !viewModel.showEventLocationView {
                stepManager.previousStep()
            }
        }
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
    @ObservedObject var viewModel: EventDateViewModel
    
    var body: some View {
        VStack(spacing: 20) {
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
                
                EventDatePickerView(viewModel: viewModel)
                
                if viewModel.isPastDate {
                    HStack(spacing: 8) {
                        Image("icon_caution")
                            .foregroundColor(.secondaryRed)
                            //.font(.system(size: 14))
                        
                        Text("앞으로 다가올 일정만 입력할 수 있어요")
                            .captionRegular12()
                            .foregroundColor(.secondaryRed)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.28))
            )
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image("icon_check")
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
                            isSelected: viewModel.selectedAttendance == attendance,
                            action: { viewModel.selectAttendance(attendance) }
                        )
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.28))
            )
        }
    }
}

struct EventDatePickerView: View {
    @ObservedObject var viewModel: EventDateViewModel
    
    var body: some View {
        Button(action: {
            viewModel.isDatePickerVisible.toggle()
        }) {
            HStack {
                Text(viewModel.selectedDate != nil ?
                     DateFormatter.displayFormatter.string(from: viewModel.selectedDate!) :
                     "날짜를 입력해주세요")
                    .bodyRegular16()
                    .foregroundColor(
                        viewModel.selectedDate != nil ?
                        (viewModel.isPastDate ? .secondaryRed : .white) :
                        .gray500
                    )
                
                Spacer()
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewModel.isPastDate ? Color.secondaryRed : Color.clear, lineWidth: 2)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
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

#Preview {
    EventDateView()
}
