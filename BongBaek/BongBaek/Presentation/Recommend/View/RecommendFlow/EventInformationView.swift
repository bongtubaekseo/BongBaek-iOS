//
//  EventInformationView.swift
//  BongBaek
//
//  Created by 김현우 on 7/3/25.
//

import SwiftUI

// MARK: - EventType Model
enum EventType: String, CaseIterable {
    case wedding = "결혼식"
    case funeral = "장례식"
    case birthday = "돌잔치"
    case celebration = "생일"
}

// MARK: - EventInformationView
struct EventInformationView: View {
    @EnvironmentObject var stepManager: GlobalStepManager
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager
    
    @State private var showEventDateView = false
    @Environment(\.dismiss) private var dismiss
    

    private var isNextButtonEnabled: Bool {
        return !eventManager.eventCategory.isEmpty && !eventManager.selectedEventType.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "경조사 정보") {
                dismiss()
            }
            
            StepProgressBar(currentStep: stepManager.currentStep, totalSteps: stepManager.totalSteps)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            
            EventInformationTitleView()
                .padding(.top, 32)
            
            EventTypeOptionsView()
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
            .padding(.bottom, 36)
        }
        .onAppear {
            print("EventInformationView 나타남 - path.count: \(router.path.count)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    stepManager.currentStep = 2
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // MARK: - Methods
    
    private func handleFormSubmission() {
        guard isNextButtonEnabled else {
            print("EventInformationView: UI 검증 실패")
            return
        }
        
        // 현재 선택된 모든 데이터 출력
        printCurrentSelections()
        
        // 다음 화면으로 이동
        if eventManager.canCompleteEventInfoStep {
            print("EventInformationView: 폼 제출 성공, 다음 화면으로 이동")
            router.push(to: .eventDateView)
        } else {
            print("EventInformationView: EventCreationManager 이중 검증 실패")
        }
    }
    
    private func printCurrentSelections() {
        print("EventInformationView 현재 선택된 값들:")
        print("이벤트 카테고리: '\(eventManager.eventCategory)'")
        print("선택된 이벤트 타입: '\(eventManager.selectedEventType)'")
        print("다음 단계 진행 가능: \(eventManager.canCompleteEventInfoStep)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}

// MARK: - Supporting Views
struct EventInformationTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("어떤 경조사에")
                .headBold24()
                .foregroundColor(.gray100)
            
            Text("참여하시나요?")
                .headBold24()
                .foregroundColor(.gray100)
            
            Text("상황에 맞는 봉투를 준비해드릴게요")
                .bodyRegular14()
                .foregroundColor(.gray400)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
}

struct EventTypeOptionsView: View {
    @EnvironmentObject var eventManager: EventCreationManager
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(EventType.allCases, id: \.self) { eventType in
                EventTypeButton(
                    eventType: eventType,
                    isSelected: eventManager.selectedEventType == eventType.rawValue,
                    action: {
                        // EventCreationManager에 직접 할당
                        eventManager.eventCategory = eventType.rawValue
                        eventManager.selectedEventType = eventType.rawValue
                        print("이벤트 선택: \(eventType.rawValue)")
                    }
                )
            }
        }
    }
}

struct EventTypeButton: View {
    let eventType: EventType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 40, height: 40)
                    
                    switch eventType {
                    case .wedding:
                        Image("icon_gift")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    case .funeral:
                        Image("icon_bookmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    case .birthday:
                        Image("icon_users")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    case .celebration:
                        Image("icon_birth")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                
                Text(eventType.rawValue)
                    .titleSemiBold16()
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 70.adjustedH)
//            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color("primary_normal") : Color.gray750)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color("primary_normal") : Color.gray750, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NextButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("다음")
                .titleSemiBold18()
                .foregroundColor(isEnabled ? .white : .gray500 )
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isEnabled ? .primaryNormal : .primaryBg)
                )
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}
