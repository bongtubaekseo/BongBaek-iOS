//
//  ModifyEventView.swift
//  BongBaek
//
//  Created by 임재현 on 7/6/25.
//

import SwiftUI

enum ModifyMode {
   case create
   case edit
}

struct ModifyEventView: View {
    let mode: ModifyMode
    @EnvironmentObject var eventManager: EventCreationManager
    @EnvironmentObject var router: NavigationRouter
    let eventDetailData: EventDetailData?
   
    @State var nickname: String = ""
    @State var alias: String = ""
    @State var money: String = ""
    @State private var selectedAttend: TextDropdownItem?
    @State private var selectedEvent: TextDropdownItem?
    @State private var selectedRelation: TextDropdownItem?
    @State private var showDatePicker = false
    @State var selectedDate: String = ""
    @Environment(\.dismiss) private var dismiss
   
    let attendItems = [
        TextDropdownItem(title: "참석"),
        TextDropdownItem(title: "미참석"),
    ]
    
    let eventItems = [
            TextDropdownItem(title: "결혼"),
            TextDropdownItem(title: "장례"),
            TextDropdownItem(title: "생일"),
            TextDropdownItem(title: "돌잔치"),
            TextDropdownItem(title: "승진"),
            TextDropdownItem(title: "개업")
        ]
        
        let relationItems = [
            TextDropdownItem(title: "가족"),
            TextDropdownItem(title: "친구"),
            TextDropdownItem(title: "직장동료"),
            TextDropdownItem(title: "선후배"),
            TextDropdownItem(title: "이웃"),
            TextDropdownItem(title: "기타")
        ]
   
    init(mode: ModifyMode, eventDetailData: EventDetailData? = nil) {
        self.mode = mode
        self.eventDetailData = eventDetailData
        print("🔧 ModifyEventView init - mode: \(mode)")
    }
   
   var body: some View {
       VStack {
           ScrollView {
               HStack {
                   Button(action: {
                       dismiss()
                   }) {
                       Text("취소")
                           .bodyRegular16()
                           .foregroundStyle(.gray200)
                   }
                   .frame(width: 44, height: 44)
                   .padding(.leading, -8)
                   
                   Spacer()
                   
                   Text(mode == .create ? "경조사 기록하기" : "경조사 수정하기")
                       .titleSemiBold18()
                       .foregroundColor(.white)
                   
                   Spacer()
                   
                   Color.clear
                       .frame(width: 44, height: 44)
               }
               .padding(.horizontal, 20)
               .padding(.top, 4)
               .padding(.bottom, 16)
               .background(.gray900)
               
               VStack {
                   VStack {
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
                       
                       CustomTextField(
                           title: "별명",
                           icon: "icon_nickname_16",
                           placeholder: "별명을 입력하세요",
                           text: $alias,
                           validationRule: ValidationRule(
                               minLength: 2,
                               maxLength: 10
                           )
                       )
                       .padding(.top, 32)
                   }
                   .padding(.horizontal, 20)

                   dropdownSection
                       .padding(.top, 16)

                   VStack(alignment: .leading, spacing: 8) {
                       HStack(spacing: 8) {
                           CustomTextField(
                               title: "경조사",
                               icon: "icon_event_16",
                               placeholder: "금액을 입력하세요",
                               text: $money,
                               validationRule: ValidationRule(
                                   minLength: 1,
                                   maxLength: 10
                               )
                           )
                           
                           Text("원")
                               .bodyRegular16()
                               .foregroundColor(.white)
                       }
                       
                       CustomDropdown(
                           title: "참석여부",
                           icon: "icon_come_16",
                           placeholder: "경조사를 선택하세요",
                           items: attendItems,
                           selectedItem: $selectedAttend
                       )
                       .padding(.top, 16)
                       
                       CustomTextField(
                           title: "날짜",
                           icon: "icon_calendar_16",
                           placeholder: "생년월일을 입력하세요",
                           text: $selectedDate,
                           isReadOnly: true) {
                               print("생년월일 필드 터치됨")
                               
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                   showDatePicker = true
                               }
                           }
                           .padding(.top, 16)
                       
                   }
                   .padding(.horizontal, 20)
                   .padding(.top, 16)
                   
                   EventMapView()
                       .padding(.top, 16)
                   
                   Button {
                       if mode == .create {
                           createEvent()
                       } else {
                           updateEvent()
                       }
                   } label: {
                       Text(mode == .create ? "기록하기" : "수정하기")
                           .titleSemiBold18()
                           .foregroundColor(.white)
                   }
                   .frame(maxWidth: .infinity)
                   .frame(height: 55)
                   .background(.primaryNormal)
                   .cornerRadius(12)
                   .padding(.horizontal, 20)
                   .padding(.top, 8)
               }
           }
       }
       .background(Color.background)
       .navigationBarHidden(true)
       .navigationBarBackButtonHidden()
       .toolbar(.hidden, for: .navigationBar)
       .onAppear {
           setupInitialValues() // 🆕 초기값 설정
       }
   }
    
    private var dropdownSection: some View {
        VStack(spacing: 24) {
            CustomDropdown(
                title: "관계",
                icon: "person.2.circle",
                placeholder: "관계를 선택하세요",
                items: relationItems,
                selectedItem: $selectedRelation
            )
            
            CustomDropdown(
                title: "경조사",
                icon: "icon_event_16",
                placeholder: "경조사를 선택하세요",
                items: eventItems,
                selectedItem: $selectedEvent
            )
        }
        .padding(.horizontal, 20)
    }
   
    /// 🆕 초기값 설정 메서드 - EventCreationManager에서 직접 접근
    private func setupInitialValues() {
        print("🔧 초기값 설정 시작...")
        
        if let eventDetail = eventDetailData {
            // AllRecordsView에서 온 경우: EventDetailData 사용
            setupFromEventDetail(eventDetail)
        } else {
            // 추천 플로우에서 온 경우: EventCreationManager 사용
            setupFromRecommendation()
        }
        
        print("✅ 초기값 설정 완료")
        print("  - 닉네임: \(nickname)")
        print("  - 별명: \(alias)")
        print("  - 금액: \(money)원")
        print("  - 참석: \(selectedAttend?.title ?? "없음")")
        print("  - 날짜: \(selectedDate)")
    }
    
    private func setupFromEventDetail(_ eventDetail: EventDetailData) {
        print("EventDetailData로부터 초기값 설정...")
        
        // 개인 정보
        nickname = eventDetail.hostInfo.hostName
        alias = eventDetail.hostInfo.hostNickname
        
        // 금액 (EventDetailData의 cost 사용)
        money = "\(eventDetail.eventInfo.cost)"
        print("기존 기록 금액 설정: \(eventDetail.eventInfo.cost)원")
        
        // 참석 여부
        let attendanceText = eventDetail.eventInfo.isAttend ? "참석" : "미참석"
        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
            selectedAttend = attendItem
        }
        
        // 날짜 설정 (API 형식: "2025-01-18" → "2025년 1월 18일")
        selectedDate = formatDateForDisplay(eventDetail.eventInfo.eventDate)
        
        // 관계
        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
            selectedRelation = relationItem
        }
        
        // 이벤트 카테고리
        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
            selectedEvent = eventItem
        }
    }
    
    private func setupFromRecommendation() {
        print("🎯 EventCreationManager로부터 초기값 설정...")
        
        // EventCreationManager에서 기존 입력 데이터 가져오기
        nickname = eventManager.hostName
        alias = eventManager.hostNickname
        
        // 추천받은 금액 설정 (있는 경우)
        if let recommendation = eventManager.recommendationResponse,
           let data = recommendation.data {
            money = "\(data.cost)"
            print("💰 추천 금액 설정: \(data.cost)원")
        }
        
        // 참석 여부 설정
        let attendanceText = eventManager.isAttend ? "참석" : "미참석"
        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
            selectedAttend = attendItem
        }
        
        // 날짜 설정
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        selectedDate = formatter.string(from: eventManager.eventDate)
        
        // 관계
        if let relationItem = relationItems.first(where: { $0.title == eventManager.relationship }) {
            selectedRelation = relationItem
        }
        
        // 이벤트 카테고리
        if let eventItem = eventItems.first(where: { $0.title == eventManager.eventCategory }) {
            selectedEvent = eventItem
        }
    }

    /// 날짜 포맷 변환 헬퍼 메서드
    private func formatDateForDisplay(_ apiDateString: String) -> String {
        // API 형식: "2025-01-18" → UI 형식: "2025년 1월 18일"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 M월 d일"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = inputFormatter.date(from: apiDateString) {
            return outputFormatter.string(from: date)
        } else {
            return apiDateString // 변환 실패 시 원본 반환
        }
    }
    
    
    
    
    private func createEvent() {
        // 새 이벤트 생성 로직 (기존과 동일)
    }
    
    private func updateEvent() {
        // 수정된 이벤트 생성 로직
        if mode == .edit && eventManager.recommendationResponse != nil {
            // 추천 금액 수정 모드
            submitModifiedRecommendation()
        } else {
            // 일반 수정 모드
            router.push(to: .recommendSuccessView)
        }
    }
    
    /// 🆕 수정된 추천 데이터로 이벤트 생성
    private func submitModifiedRecommendation() {
        print("📝 수정된 추천 데이터로 이벤트 생성 시작...")
        
        Task {
            // 수정된 데이터로 EventCreationManager 업데이트
            updateEventManagerWithModifiedData()
            
            // 수정된 금액으로 이벤트 생성
            let modifiedAmount = Int(money) ?? 0
            let success = await eventManager.submitEventWithModifiedAmount(modifiedAmount: modifiedAmount)
            
            if success {
                await MainActor.run {
                    router.push(to: .recommendSuccessView)
                }
            } else {
                print("수정된 이벤트 생성 실패: \(eventManager.submitError ?? "알 수 없는 오류")")
                // TODO: 에러 처리
            }
        }
    }
    
    ///  수정된 데이터로 EventCreationManager 업데이트
    private func updateEventManagerWithModifiedData() {
        // 수정된 개인 정보 업데이트
        eventManager.updateRecommendData(
            hostName: nickname,
            hostNickname: alias,
            relationship: eventManager.relationship,
            detailSelected: eventManager.detailSelected,
            contactFrequency: eventManager.contactFrequency,
            meetFrequency: eventManager.meetFrequency
        )
        
        // 참석 여부 업데이트
        let isAttending = selectedAttend?.title == "참석"
        let attendanceType: AttendanceType = isAttending ? .yes : .no
        
        eventManager.updateDateData(
            eventDate: eventManager.eventDate,
            selectedAttendance: attendanceType
        )
        
        print("EventCreationManager 데이터 업데이트 완료")
    }
    
}

