//
//  ProfileSettingView.swift
//  BongBaek
//
//  Created by 임재현 on 7/1/25.
//

import SwiftUI

struct ProfileSettingView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = ProfileSettingViewModel()
    @State private var showDatePicker = false
    @FocusState private var focusedField: FocusField?
    @Environment(\.dismiss) private var dismiss
    @State private var previousFocusedField: FocusField? = nil
    
    enum FocusField {
        case nickname
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("프로필 설정")
                    .titleSemiBold18()
                    .foregroundStyle(.txtDisplayPrimary)
                Spacer()
            }
            
            ScrollView {
                VStack {
                    textFieldSection
                    incomeToggleSection
                    
                    incomeSelectionSection
                        .opacity(viewModel.hasIncome ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.4), value: viewModel.hasIncome)
                        .padding(.bottom, 60)
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            
            startButton
                .padding(.bottom, 60)
                .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bgDisplayPrimary)
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $showDatePicker, onDismiss: {
            focusedField = nil
            previousFocusedField = nil
        }) {
            DatePickerBottomSheetView { selectedDateString in
                viewModel.selectedDate = selectedDateString
                print("선택된 날짜: \(selectedDateString)")
                focusedField = nil
            }
            .presentationDetents([.height(359)])
        }
        .alert("회원가입 실패", isPresented: $viewModel.showErrorAlert) {
            Button("확인") {
                viewModel.dismissError()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    private var textFieldSection: some View {
        VStack(spacing: 16) {
            CustomTextField(
                title: "닉네임",
                icon: "icon_person_16",
                placeholder: "닉네임을 입력해주세요",
                text: $viewModel.nickname,
                isValid: $viewModel.isNicknameValid,
                validationRule: ValidationRule(
                    minLength: 2,
                    maxLength: 10,
                    regex: "^[가-힣a-zA-Z0-9\\s]+$",
                    customMessage: "특수문자는 기입할 수 없어요"
                ),
                isRequired: true
            )
            .focused($focusedField, equals: .nickname)
            
            CustomTextField(
                title: "생년월일",
                icon: "icon_calendar_16",
                placeholder: "생년월일을 입력해주세요",
                text: $viewModel.selectedDate,
                isReadOnly: true,
                isRequired: true) {
                    print("생년월일 필드 터치됨")
                    previousFocusedField = focusedField
                    focusedField = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showDatePicker = true
                    }
                }
        }
        .padding(.top, 20)
    }
    
    private var incomeToggleSection: some View {
        HStack {
            Text("현재 수입 있음")
                .bodyMedium16()
                .foregroundColor(.txtDisplayPrimary)
            
            Spacer()
            
            Toggle("", isOn: $viewModel.hasIncome)
                .labelsHidden()
                .tint(.bgStatusFocused)
                .onChange(of: viewModel.hasIncome) { _, newValue in
                    if !newValue {
                        viewModel.selectIncome(.none)
                        focusedField = nil
                    }
                }
        }
        .frame(maxWidth: .infinity, minHeight: 62)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.bgDisplayCard)
        )
        .padding(.top, 20)
    }
    
    private var incomeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("현재 수입은 어느 정도인가요?")
                .titleSemiBold16()
                .foregroundStyle(.txtDisplaySecondary)
                .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                incomeButton(for: .under200)
                incomeButton(for: .over200)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 183)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.bgDisplayCard)
        )
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        ))
        .animation(.easeInOut(duration: 0.4), value: viewModel.hasIncome)
    }
    
    private func incomeButton(for selection: ProfileSettingViewModel.IncomeSelection) -> some View {
        Button {
            viewModel.selectIncome(selection)
            focusedField = nil
            print("\(selection.displayText) 선택됨")
        } label: {
            HStack {
                Text(selection.displayText)
                    .bodyRegular14()
                    .foregroundStyle(.txtInteractivePrimary)
                
                Spacer()
                
                if viewModel.isSelected(selection) {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.txtStatusFocused)
                        .font(.system(size: 12, weight: .semibold))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                viewModel.isSelected(selection) ?
                    .primaryNormal.opacity(0.3) : .clear.opacity(0.1)
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        viewModel.isSelected(selection) ? .borderStatusFocused : .borderFieldDefault,
                        lineWidth: viewModel.isSelected(selection) ? 2 : 1
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.currentSelection)
    }

    private var startButton: some View {
        Button(action: {
            viewModel.logCurrentSelection()
            viewModel.performSignUp()
        }) {
            HStack {
                if viewModel.isSigningUp {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.8)
                        .padding(.trailing, 8)
                }
                
                Text("봉투백서 시작하기")
                    .titleSemiBold18()
                    .foregroundColor(viewModel.isStartButtonEnabled ? .txtInteractiveInverse : .txtStatusDisabled)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isStartButtonEnabled ? .bgStatusFocused : .btnInteractiveDisabled)
            .cornerRadius(12)
            .contentShape(Rectangle())          
        }
        .padding(.top, 20)
        .disabled(!viewModel.isStartButtonEnabled || viewModel.isSigningUp)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isStartButtonEnabled)
    }
}
