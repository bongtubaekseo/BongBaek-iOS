//
//  RecommendView.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI

struct RecommendView: View {
    @State var nameTexts: String = ""
    @State var nicknameTexts: String = ""
    @State private var selectedRelation = ""
    @State private var detailSelected: Bool = false
    @EnvironmentObject var stepManager: GlobalStepManager
    @EnvironmentObject var router: NavigationRouter
    @State private var navigateToEventInfo = false
    @Environment(\.dismiss) private var dismiss
    @State private var showEventInformation = false
   let relationships = [
       ("icon_family", "가족"),
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
    
    private var isNextButtonEnabled: Bool {
        // 1. 이름 필수 입력 + 유효성 검사 (2-10자)
        let nameValid = nameTexts.count >= 2 && nameTexts.count <= 10
        
        // 2. 별명 유효성 검사 (비어있거나, 입력된 경우 2-10자)
        let nicknameValid = nicknameTexts.isEmpty || (nicknameTexts.count >= 2 && nicknameTexts.count <= 10)
        
        // 3. 관계 선택 필수
        let relationSelected = !selectedRelation.isEmpty
        
        return nameValid && nicknameValid && relationSelected
    }
   
   var body: some View {
       VStack(spacing: 0) {
           CustomNavigationBar(title: "관계정보") {
               dismiss()
           }
           .padding(.top, 40)
           
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
                       
                       VStack(alignment: .leading) {
                           VStack(alignment: .leading, spacing: 0) {
                               HStack {
                                   Image("icon_person_16")
                                       .renderingMode(.template)
                                       .foregroundColor(.blue)
                                   
                                   Text("상대방의 이름과 별명을 알려주세요")
                                       .titleSemiBold18()
                                       .foregroundStyle(.white)
                               }
                               .padding(.bottom, 20)
                               
                               VStack(spacing: 12) {
                                   BorderTextField(placeholder: "이름을 적어주세요", text: $nameTexts, validationRule: ValidationRule(minLength: 2, maxLength: 10))
                                   BorderTextField(placeholder: "별명을 적어주세요", text: $nicknameTexts, validationRule: ValidationRule(minLength: 2, maxLength: 10))
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
                           
                           HStack {
                               Image("icon_person_16")
                                   .renderingMode(.template)
                                   .foregroundColor(.blue)
                               
                               Text("관계를 선택해주세요.")
                                   .titleSemiBold18()
                                   .foregroundStyle(.white)
                           }
                           .padding(.leading, 20)
                           .padding(.top, 20)
                       }
                       
                       LazyVGrid(columns: columns, spacing: 10) {
                           ForEach(relationships, id: \.1) { relationship in
                               RelationshipButton(
                                   image: relationship.0,
                                   text: relationship.1,
                                   isSelected: selectedRelation == relationship.1
                               ) {
                                   selectedRelation = relationship.1
                               }
                               .background(.gray750)
                           }
                       }
                       .padding(.horizontal, 20)
                       .padding(.top, 16)
                       
                       DetailRecommendButton(isSelected: detailSelected) {
                           detailSelected.toggle()
                       }
                       .padding(.horizontal, 20)
                       .padding(.top, 16)
                       
                       if detailSelected {
                           RelationshipSliderView()
                               .id("sliderView")
                       }
                       
                       Button {
                           if isNextButtonEnabled {
                               router.push(to: .eventInformationView)
                           }
                       } label: {
                           Text("금액 추천 시작하기")
                               .titleSemiBold18()
                               .foregroundStyle(isNextButtonEnabled ? .white : .gray400)
                       }
                       
//                       NavigationLink(destination: EventInformationView()
//                        .environmentObject(stepManager)
//                        .environmentObject(pathManager)
//                       ) {
//                           Text("금액 추천 시작하기")
//                               .titleSemiBold18()
//                               .foregroundStyle(isNextButtonEnabled ? .white : .gray400)
//                       }
                       .disabled(!isNextButtonEnabled)
                       .frame(maxWidth: .infinity)
                       .frame(height: 60)
                       .background(isNextButtonEnabled ? .primaryNormal : .gray600)
                       .cornerRadius(12)
                       .padding(.horizontal, 20)
                       .padding(.top, 8)
                       .padding(.bottom, 24)
                       .animation(.easeInOut(duration: 0.2), value: isNextButtonEnabled)


                       Spacer(minLength: 0)
                   }
               }
               .onTapGesture {
                   hideKeyboard()
               }
               .onChange(of: detailSelected) {_ , newValue in
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
       .ignoresSafeArea()
       .onAppear {
           stepManager.currentStep = 1
           print("👤 RecommendView 나타남 - path.count: \(router.path.count)")
       }
       .onDisappear {

        }
       .toolbar(.hidden, for: .navigationBar)
       .navigationBarBackButtonHidden(true)
   }
}

