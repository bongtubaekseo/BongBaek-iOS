//
//  RecommendView.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI

struct RecommendView: View {
    @State private var navigateToEventInfo = false
    @Environment(\.dismiss) private var dismiss
    @State private var showEventInformation = false
    
    @EnvironmentObject var stepManager: GlobalStepManager
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager
    
    let relationships = [
        ("icon_family", "가족/친척"),
        ("icon_friends", "친구"),
        ("icon_handshakes", "직장"),
        ("icon_colleague", "선후배"),
        ("icon_neighbor", "이웃"),
        ("icon_others", "기타")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    // 기존 검증 로직 유지 (UI 반응용)
    private var isNextButtonEnabled: Bool {
        // 1. 이름 유효성 검사 통과
        let nameValid = eventManager.isHostNameValid
        
        // 2. 별명 유효성 검사 통과
        let nicknameValid = eventManager.isHostNicknameValid
        
        // 3. 관계 선택 필수
        let relationSelected = !eventManager.relationship.isEmpty
        
        return nameValid && nicknameValid && relationSelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "관계정보") {
                dismiss()
            }
            
            StepProgressBar(currentStep: stepManager.currentStep, totalSteps: stepManager.totalSteps)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        RecommendGuideTextView(
                            title1: "먼저, 마음을 전하고 싶은 분의",
                            title2: "정보를 적어주세요,",
                            subtitle1: "상대에 대한 정보와 관계를 말씀해주시면,",
                            subtitle2: "더 정확한 추천을 해드릴께요"
                        )
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        
                        userInfoSection
                        
                        relationshipHeaderSection
                        
                        relationshipGridSection
                            .onTapGesture {
                                hideKeyboard()
                            }
                        
                        detailRecommendSection
                            .padding(.top, 16)
                            .onTapGesture {
                                hideKeyboard()
                            }
                        
                        if eventManager.detailSelected {
                            RelationshipSliderView()
                                .id("sliderView")
                                .onTapGesture {
                                    hideKeyboard()
                                }
                        }
                        
                        submitButton
                            .padding(.top, 60)
                            .padding(.bottom, 60)
                            .onTapGesture {
                                hideKeyboard() 
                            }
                    }
                }
                .onTapGesture {
                    hideKeyboard() // 빈 공간 터치 시 키보드 해제
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged { _ in
                            hideKeyboard() // 스크롤 시작 시 키보드 해제
                        }
                )
                .onChange(of: eventManager.detailSelected) { _, newValue in
                    hideKeyboard() // 상세 선택 변경 시 키보드 해제
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo("sliderView", anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .onTapGesture {
            hideKeyboard() // 전체 화면 터치 시 키보드 해제
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    stepManager.currentStep = 1
                }
            }
            print("RecommendView 나타남 - path.count: \(router.path.count)")
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - View Components
    
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image("icon_person_16")
                    .renderingMode(.template)
                    .foregroundColor(.primaryNormal)
                    .frame(width: 22,height: 22)
                
                Text("상대방의 이름과 별명을 알려주세요")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                BorderTextField(
                    placeholder: "이름을 적어주세요",
                    text: $eventManager.hostName,
                    isValid: $eventManager.isHostNameValid,
                    validationRule: ValidationRule(
                        minLength: 2,
                        maxLength: 10,
                        regex: "^[가-힣a-zA-Z0-9\\s]+$",
                        customMessage: "특수문자는 기입할 수 없어요"
                    )
                )
                BorderTextField(
                    placeholder: "별명을 적어주세요",
                    text: $eventManager.hostNickname,
                    isValid: $eventManager.isHostNicknameValid,
                    validationRule: ValidationRule(
                        minLength: 2,
                        maxLength: 10,
                        regex: "^[가-힣a-zA-Z0-9\\s]+$",
                        customMessage: "특수문자는 기입할 수 없어요"
                    )
                )
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, minHeight: 183)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray750)
                .padding(.horizontal, 20)
        )
        .padding(.top, 12)
    }
    
    private var relationshipHeaderSection: some View {
        HStack {
            Image("icon_relation")
                .frame(width: 20,height: 20)
            
            Text("관계를 선택해주세요.")
                .titleSemiBold18()
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.top, 20)
    }
    
    private var relationshipGridSection: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(relationships, id: \.1) { relationship in
                RelationshipButton(
                    image: relationship.0,
                    text: relationship.1,
                    isSelected: eventManager.relationship == relationship.1
                ) {
                    // EventCreationManager의 relationship에 직접 할당
                    eventManager.relationship = relationship.1
                    print("관계 선택: \(relationship.1)")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var detailRecommendSection: some View {
        DetailRecommendButton(isSelected: eventManager.detailSelected) {
            eventManager.detailSelected.toggle()
            print("상세 추천: \(eventManager.detailSelected ? "활성화" : "비활성화")")
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    

    private var submitButton: some View {
        Button {
            handleFormSubmission()
        } label: {
            Text("다음")
                .titleSemiBold18()
                .foregroundStyle(isNextButtonEnabled ? .white : .gray500)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
        }
        .disabled(!isNextButtonEnabled)
        .frame(maxWidth: .infinity)
        .background(isNextButtonEnabled ? .primaryNormal : .primaryBg)
        .cornerRadius(12)
        .contentShape(Rectangle())
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 24)
        .animation(.easeInOut(duration: 0.2), value: isNextButtonEnabled)
    }
    
    // MARK: - Methods
    
    private func handleFormSubmission() {
        guard isNextButtonEnabled else {
            print("UI 검증 실패")
            return
        }
        
        // 현재 선택된 모든 데이터 출력
        printCurrentSelections()
        
        // 다음 화면으로 이동
        if eventManager.canCompleteRecommendStep {
            print("RecommendView: 폼 제출 성공, 다음 화면으로 이동")
            router.push(to: .eventInformationView)
        } else {
            print("RecommendView: EventCreationManager 이중 검증 실패")
        }
    }
    
    private func printCurrentSelections() {
        print("RecommendView 현재 선택된 값들:")
        print("이름: '\(eventManager.hostName)'")
        print("별명: '\(eventManager.hostNickname)'")
        print("관계: '\(eventManager.relationship)'")
        print("상세 선택: \(eventManager.detailSelected)")
        
        if eventManager.detailSelected {
            print("연락 빈도: \(eventManager.contactFrequency) (0=거의안함, 4=매우자주)")
            print("만나는 빈도: \(eventManager.meetFrequency) (0=거의안함, 4=매우자주)")
        }
        
        print("음 단계 진행 가능: \(eventManager.canCompleteRecommendStep)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}
