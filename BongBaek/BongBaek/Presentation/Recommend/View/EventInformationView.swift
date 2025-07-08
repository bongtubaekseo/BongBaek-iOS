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
    @StateObject private var viewModel = EventInformationViewModel()
    @EnvironmentObject var stepManager: GlobalStepManager
    
    @State private var showEventDateView = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {

            CustomNavigationBar(title: "관계정보") {
                dismiss()
            }
            .padding(.top, 40)
            
            StepProgressBar(currentStep: stepManager.currentStep, totalSteps: stepManager.totalSteps)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            
            EventInformationTitleView()
            
            Spacer()
                .frame(height: 60)
            
            EventTypeOptionsView(viewModel: viewModel)
                .padding(.horizontal, 24)
            
            Spacer()
            
            NextButton(
                isEnabled: viewModel.isNextButtonEnabled,
                action: viewModel.proceedToNext
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background"))
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    stepManager.currentStep = 2
                }
            }
        }
        .onDisappear {
            if !viewModel.showEventDateView {
                stepManager.previousStep()
            }
        }
        .navigationDestination(isPresented: $viewModel.showEventDateView) {
            EventDateView().environmentObject(stepManager)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Supporting Views
struct EventInformationTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("어떤 경조사에")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("참여하시나요?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("상황에 맞는 봉투를 준비해드릴게요")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
}

struct EventTypeOptionsView: View {
    @ObservedObject var viewModel: EventInformationViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(EventType.allCases, id: \.self) { eventType in
                EventTypeButton(
                    eventType: eventType,
                    isSelected: viewModel.selectedEventType == eventType,
                    action: { viewModel.selectEventType(eventType) }
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color("primary_normal") : Color(red: 0.196, green: 0.196, blue: 0.196))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color("primary_normal") : Color.clear, lineWidth: 2)
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
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isEnabled ? Color("primary_normal") : Color.gray.opacity(0.3))
                )
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

#Preview {
    EventInformationView()
}
