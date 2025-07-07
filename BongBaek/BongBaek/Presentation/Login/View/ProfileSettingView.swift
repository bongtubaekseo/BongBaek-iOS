//
//  ProfileSettingView.swift
//  BongBaek
//
//  Created by 임재현 on 7/1/25.
//

import SwiftUI

struct ProfileSettingView: View {
    
    @State var nickname: String = ""
    @State var selectedDate: String = ""
    @State private var showDatePicker = false
    @State private var someBinding = true
    @State private var selectedIncome: String? = nil
    @FocusState private var focusedField: FocusField?
    @Environment(\.dismiss) private var dismiss
    @State private var previousFocusedField: FocusField? = nil
    @State private var navigateToHome = false
    
    enum FocusField {
        case nickname
    }
   
    enum IncomeSelection: Equatable {
        case under200
        case over200
        case none
    }
   
    @State private var currentSelection: IncomeSelection = .none
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "프로필 설정") {
                dismiss()
            }
            
            ScrollView {
                VStack {
                    textFieldSection
                    
                    incomeToggleSection
                    
                    if someBinding {
                        incomeSelectionSection
                    }
                    
                    startButton
                        .padding(.top, 30)
                    
                    Spacer()
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationDestination(isPresented: $navigateToHome) {
              HomeView()
          }
        .toolbar(.hidden, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $showDatePicker, onDismiss: {
            focusedField = nil
            previousFocusedField = nil
        }) {
            DatePickerBottomSheetView { selectedDateString in
                selectedDate = selectedDateString
                print("선택된 날짜: \(selectedDateString)")
                focusedField = nil
            }
            .presentationDetents([.height(359)])
        }
    }
    
    private var customNavigationBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)
            .padding(.leading, -8)
            
            Spacer()
            
            Text("프로필 설정")
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
    }
    
    private var textFieldSection: some View {
        VStack(spacing: 16) {
            CustomTextField(
                title: "닉네임",
                icon: "person.circle",
                placeholder: "닉네임을 입력하세요",
                text: $nickname,
                validationRule: ValidationRule(
                    minLength: 2,
                    maxLength: 10
                )
            )
            .focused($focusedField, equals: .nickname)
            
                CustomTextField(
                    title: "생년월일",
                    icon: "icon_calendar_16",
                    placeholder: "생년월일을 입력하세요",
                    text: $selectedDate,
                    isReadOnly: true) {
                        print("생년월일 필드 터치됨")
                        previousFocusedField = focusedField
                        focusedField = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showDatePicker = true
                        }
                    }
        }
        .padding(.top, 30)
    }
    
    private var incomeToggleSection: some View {
        HStack {
            Text("현재 수입 있음")
                .bodyMedium16()
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $someBinding)
                .labelsHidden()
                .tint(.blue)
                .onChange(of: someBinding) { _, newValue in
                    if !newValue {
                        currentSelection = .none
                        focusedField = nil
                    }
                }
        }
        .frame(maxWidth: .infinity, minHeight: 62)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray750)
        )
        .padding(.top, 20)
    }
    
    private var incomeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("현재 수입은 어느 정도인가요?")
                .titleSemiBold16()
                .foregroundStyle(.white)
                .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                under200Button
                over200Button
            }
        }
        .frame(maxWidth: .infinity, minHeight: 183)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray750)
        )
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        ))
        .animation(.easeInOut(duration: 0.4), value: someBinding)
    }
    
    private var under200Button: some View {
        Button {
            currentSelection = .under200
            focusedField = nil
            print("월 200 이하 선택됨")
        } label: {
            HStack {
                Text("월 200 이하")
                    .foregroundStyle(.white)
                
                Spacer()
                
                if case .under200 = currentSelection {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                isSelected(.under200) ?
                    .blue.opacity(0.3) : .clear.opacity(0.1)
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected(.under200) ? .blue : .gray100,
                        lineWidth: isSelected(.under200) ? 2 : 1
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: currentSelection)
    }
    
    private var over200Button: some View {
        Button {
            currentSelection = .over200
            focusedField = nil
            print("월 200 이상 선택됨")
        } label: {
            HStack {
                Text("월 200 이상")
                    .foregroundStyle(.white)
                
                Spacer()
                
                if case .over200 = currentSelection {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                isSelected(.over200) ?
                    .blue.opacity(0.3) : .clear.opacity(0.1)
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected(.over200) ? .blue : .gray100,
                        lineWidth: isSelected(.over200) ? 2 : 1
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: currentSelection)
    }

    private var startButton: some View {
        Button("봉투백서 시작하기") {
            print("봉투백서 시작하기 버튼 클릭됨")
            
            switch currentSelection {
            case .under200:
                print("선택된 수입: 월 200 이하")
            case .over200:
                print("선택된 수입: 월 200 이상")
            case .none:
                print("수입이 선택되지 않음")
            }
            
            navigateToHome = true
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(.top, 20)
    }
    
    private func isSelected(_ selection: IncomeSelection) -> Bool {
        switch (currentSelection, selection) {
        case (.under200, .under200), (.over200, .over200):
            return true
        default:
            return false
        }
    }
}
