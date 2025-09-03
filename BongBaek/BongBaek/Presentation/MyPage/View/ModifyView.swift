//
//  MyPageView.swift
//  BongBaek
//
//  Created by hyunwoo on 8/28/25.
//

import SwiftUI

struct ModifyView: View {
    @StateObject private var viewModel = ProfileSettingViewModel()
    @State private var showDatePicker = false
    @FocusState private var focusedField: FocusField?
    //@Environment(\.dismiss) private var dismiss
    @State private var previousFocusedField: FocusField? = nil
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var stepManager = GlobalStepManager()
    
    enum FocusField {
        case nickname
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "프로필 설정") {
                router.pop()
            }
            
            ScrollView {
                VStack {
                    textFieldSection
                    incomeToggleSection
                    
                    if viewModel.hasIncome {
                        incomeSelectionSection
                    }
                    
                    startButton
                        .padding(.top, 20.adjustedH)
                    
                    Spacer()
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
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
                title: "이름",
                icon: "icon_person_16",
                placeholder: "이름을 입력하세요",
                text: $viewModel.nickname,
                validationRule: ValidationRule(
                    minLength: 2,
                    maxLength: 10,
                    regex: "^[가-힣a-zA-Z0-9\\s]+$",
                    customMessage: "한글, 영문, 숫자, 공백만 입력 가능합니다"
                ),
                isRequired: true
            )
            .focused($focusedField, equals: .nickname)
            
            CustomTextField(
                title: "생년월일",
                icon: "icon_calendar_16",
                placeholder: "생년월일을 입력하세요",
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
        .padding(.top, 30)
    }
    
    private var incomeToggleSection: some View {
        HStack {
            Text("현재 수입 있음")
                .bodyMedium16()
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $viewModel.hasIncome)
                .labelsHidden()
                .tint(.primaryNormal)
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
                .fill(.gray750)
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
                    .foregroundStyle(.white)
                
                Spacer()
                
                if viewModel.isSelected(selection) {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
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
                        viewModel.isSelected(selection) ? .primaryNormal : .gray100,
                        lineWidth: viewModel.isSelected(selection) ? 2 : 1
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.currentSelection)
    }

    private var startButton: some View {
        Button("수정하기") {
            viewModel.logCurrentSelection()
            viewModel.performSignUp()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(viewModel.isStartButtonEnabled ? .primaryNormal : Color.gray.opacity(0.3))
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(.top, 20)
        .disabled(!viewModel.isStartButtonEnabled)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isStartButtonEnabled)
        .overlay(
            viewModel.isSigningUp ?
            ProgressView()
                .tint(.white)
                .scaleEffect(0.8) : nil
        )
    }
}
