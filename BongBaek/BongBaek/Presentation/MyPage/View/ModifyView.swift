//
//  MyPageView.swift
//  BongBaek
//
//  Created by hyunwoo on 8/28/25.
//

import SwiftUI
import Combine

struct ModifyView: View {
    @StateObject private var viewModel = ModifyViewModel()
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showDatePicker = false
    @FocusState private var focusedField: FocusField?
    //@Environment(\.dismiss) private var dismiss
    @State private var previousFocusedField: FocusField? = nil
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var stepManager = GlobalStepManager()
    
    let initialProfileData: UpdateProfileData?
    
    init(initialProfileData: UpdateProfileData? = nil) {
        self.initialProfileData = initialProfileData
    }
    
    enum FocusField {
        case nickname
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "프로필 수정") {
                router.pop()
            }
            
            ScrollView {
                VStack {
                    textFieldSection
                    incomeToggleSection
                    
                    incomeSelectionSection
                        .opacity(viewModel.hasIncome ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.4), value: viewModel.hasIncome)
                    
                    updateButton
                        .padding(.bottom, 60.adjustedH)
                    
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
        .onAppear {
            viewModel.initializeState()
            setupInitialValues()
        }
        .onChange(of: viewModel.updateSuccess) { oldValue, newValue in
            print("updateSuccess 변화: \(oldValue) → \(newValue)")
            if newValue {
                print("프로필 업데이트 성공! 이전 화면으로 이동")
                viewModel.resetUpdateSuccess()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    print("router.pop() 실행")
                    router.pop()
                    print("updateSuccess 리셋 완료")
                }
            }
        }
        .onDisappear {
            if viewModel.updateSuccess {
                viewModel.resetUpdateSuccess()
                print("onDisappear: 남은 상태 정리 완료")
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
                    customMessage: "특수문자는 기입할 수 없어요"
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
    
    private func incomeButton(for selection: ModifyViewModel.IncomeSelection) -> some View {
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

    private var updateButton: some View {
        Button("수정하기") {
            print("수정하기 버튼 클릭")
            viewModel.logCurrentSelection()
            viewModel.performProfileUpdate()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(viewModel.isUpdateButtonEnabled ? .primaryNormal : .primaryBg)
        .foregroundColor(viewModel.isUpdateButtonEnabled ? .white : .gray500)
        .cornerRadius(12)
        .padding(.top, 20)
        .disabled(!viewModel.isUpdateButtonEnabled)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isUpdateButtonEnabled)
        .overlay(
            viewModel.isUpdating ?
            ProgressView()
                .tint(.white)
                .scaleEffect(0.8) : nil
        )
    }
    
    private func setupInitialValues() {
        guard let profileData = initialProfileData else { return }
        
        viewModel.nickname = profileData.memberName
        viewModel.selectedDate = formatBirthdayForInput(profileData.memberBirthday)
        setupIncomeData(profileData.memberIncome)
        
        print("초기값 설정 완료: \(profileData)")
    }
    
    private func formatBirthdayForInput(_ birthday: String) -> String {
        // "2011-09-06" → "2011.09.06"
        return birthday.replacingOccurrences(of: "-", with: ".")
    }
    
    private func setupIncomeData(_ income: String) {
        switch income {
        case "NONE":
            viewModel.hasIncome = false
            viewModel.currentSelection = .none
        case "UNDER200":
            viewModel.hasIncome = true
            viewModel.currentSelection = .under200
        case "OVER200":
            viewModel.hasIncome = true
            viewModel.currentSelection = .over200
        default:
            viewModel.hasIncome = false
            viewModel.currentSelection = .none
        }
    }
}
