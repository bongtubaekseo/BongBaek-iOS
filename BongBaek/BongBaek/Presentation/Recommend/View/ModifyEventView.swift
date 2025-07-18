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
    @State private var mapView: KakaoMapView?
    @State var longitude: Double = 0.0
    @State var latitude: Double = 0.0
   
    @State var nickname: String = ""
    @State var alias: String = ""
    @State var money: String = ""
    @State var memo: String = ""
    @State private var selectedAttend: TextDropdownItem?
    @State private var selectedEvent: TextDropdownItem?
    @State private var selectedRelation: TextDropdownItem?
    @State var locationName: String = ""
    @State var locationAddress: String = ""
    @State private var showDatePicker = false
    @State var selectedDate: String = ""
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSubmitting = false
    @State private var submitError: String?
    
    private var isRecommendationEdit: Bool {
           return mode == .edit && eventDetailData == nil && eventManager.recommendationResponse != nil
       }
    
    private var isFormValid: Bool {
        !nickname.isEmpty &&
        !alias.isEmpty &&
        !money.isEmpty &&
        selectedAttend != nil &&
        selectedEvent != nil &&
        selectedRelation != nil &&
        !selectedDate.isEmpty
    }
    
   
    private var hasLocationData: Bool {
         return !locationName.isEmpty && longitude != 0.0 && latitude != 0.0
     }
    
    let attendItems = [
        TextDropdownItem(title: "참석"),
        TextDropdownItem(title: "미참석"),
    ]
    
    let eventItems = [
            TextDropdownItem(title: "결혼식"),
            TextDropdownItem(title: "장례식"),
            TextDropdownItem(title: "돌잔치"),
            TextDropdownItem(title: "생일")
        ]
        
        let relationItems = [
            TextDropdownItem(title: "가족/친척"),
            TextDropdownItem(title: "친구"),
            TextDropdownItem(title: "직장"),
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
                
                VStack(spacing: 0) {
                    VStack {
                        CustomTextField(
                            title: "이름",
                            icon: "icon_person_16",
                            placeholder: "닉네임을 입력하세요",
                            text: $nickname,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10
                            ),isReadOnly: isRecommendationEdit,isRequired: true
                        )
                        
                        CustomTextField(
                            title: "별명",
                            icon: "icon_event_16",
                            placeholder: "별명을 입력하세요",
                            text: $alias,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10
                            ),isReadOnly: isRecommendationEdit,isRequired: true
                        )
                        .padding(.top, 32)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    dropdownSection
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            CustomTextField(
                                title: "경조사비",
                                icon: "icon_coin_16",
                                placeholder: "금액을 입력하세요",
                                text: $money,
                                validationRule: ValidationRule(
                                    minLength: 1,
                                    maxLength: 10
                                ),keyboardType: .numberPad
                            )
                            
                            Text("원")
                                .bodyRegular16()
                                .foregroundColor(.white)
                        }
                        
                        CustomDropdown(
                            title: "참석여부",
                            icon: "icon_check 1",
                            placeholder: "경조사를 선택하세요",
                            items: attendItems,
                            selectedItem: $selectedAttend,
                            isDisabled: isRecommendationEdit
                        )
                        .padding(.top, 16)
                        
                        CustomTextField(
                            title: "날짜",
                            icon: "icon_calendar_16",
                            placeholder: "생년월일을 입력하세요",
                            text: $selectedDate,
                            isReadOnly: true,
                            isRequired: true) {
                                print("생년월일 필드 터치됨")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showDatePicker = true
                                }
                            }
                            .padding(.top, 16)
                        
                        VStack(spacing: 16) {
                            HStack {
                                HStack {
                                    Image("icon_location_16")
                                    Text("행사장")
                                        .bodyMedium14()
                                        .foregroundStyle(.gray300)
                                }
                                
                                Spacer()
                                
                                Button {
                                    print("수정하기")
                                } label: {
                                    Text("수정하기")
                                        .bodyRegular14()
                                        .foregroundStyle(.gray300)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                mapSection
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 180)
                                    .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(locationName)
                                        .bodyMedium16()
                                        .foregroundStyle(.white)
                                    
                                    Text(locationAddress)
                                        .bodyMedium16()
                                        .foregroundStyle(.gray300)
                                }
                            }
                        }
                            .padding(.top, 16)
                        

                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
                .background(.gray800)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                EventMemoView(memo: $memo)
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
                
                Button {
                    if mode == .create {
                        createEvent()
                    } else {
                        updateEvent()
                    }
                } label: {
                    if isSubmitting {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text(mode == .create ? "기록 중..." : "수정 중...")
                                .titleSemiBold18()
                                .foregroundColor(.white)
                        }
                    } else {
                        Text(mode == .create ? "기록하기" : "수정하기")
                            .titleSemiBold18()
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(isFormValid ? .primaryNormal : .gray600)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .disabled(!isFormValid || isSubmitting)
                
                if let error = submitError {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerBottomSheetView2(
                    onComplete: { selectedDateString in
                        selectedDate = selectedDateString
                        print("선택된 날짜: \(selectedDateString)")
                    }

                )
                .presentationDetents([.height(359)])
            }
        }
        .background(.gray900)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            setupInitialValues()
        }
    }
    
    private var mapSection: some View {
           Group {
               // 위치 정보가 있는 경우 지도 표시
               if hasLocationData {
                   if let mapView = mapView {
                       mapView
                           .frame(height: 180)
                           .cornerRadius(12)
                           .onAppear {
                               updateMapLocation()
                           }
                   } else {
                       Rectangle()
                           .foregroundStyle(.gray750)
                           .frame(maxWidth: .infinity)
                           .frame(height: 180)
                           .cornerRadius(12)
                           .onAppear {
                               mapView = KakaoMapView(draw: .constant(true))
                               // 지도 생성 후 위치 업데이트
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                   updateMapLocation()
                               }
                           }
                   }
               } else {
                   // 위치 정보가 없는 경우 빈 Rectangle 표시
                   VStack {
                       Image(systemName: "location.slash")
                           .font(.system(size: 30))
                           .foregroundColor(.gray500)
                       
                       Text("위치 정보가 없습니다")
                           .bodyRegular14()
                           .foregroundColor(.gray500)
                           .padding(.top, 8)
                   }
                   .frame(maxWidth: .infinity)
                   .frame(height: 180)
                   .background(.gray750)
                   .cornerRadius(12)
               }
           }
       }
    
    private func updateMapLocation() {
         guard hasLocationData else { return }
         
         mapView?.updateLocation(longitude: longitude, latitude: latitude)
         print("🗺️ 지도 위치 업데이트: \(locationName)")
         print("📍 좌표: \(longitude), \(latitude)")
     }
    
    private func handleLocationSelection(_ document: KLDocument) {
        // EventCreationManager에 위치 데이터 저장
        eventManager.updateLocationData(selectedLocation: document)
        
        locationName = document.placeName
         locationAddress = document.addressName
        
        // 지도 위치 업데이트
        if let longitude = Double(document.x),
           let latitude = Double(document.y) {
            mapView?.updateLocation(longitude: longitude, latitude: latitude)
            print("지도 위치 업데이트: \(document.placeName)")
            print("좌표: \(longitude), \(latitude)")
        }

    }
   
    
    private var dropdownSection: some View {
        VStack(spacing: 24) {
            CustomDropdown(
                title: "관계",
                icon: "icon_relation",
                placeholder: "관계를 선택하세요",
                items: relationItems,
                selectedItem: $selectedRelation,
                isDisabled: isRecommendationEdit
            )
            
            CustomDropdown(
                title: "경조사",
                icon: "icon_event_16",
                placeholder: "경조사를 선택하세요",
                items: eventItems,
                selectedItem: $selectedEvent,
                isDisabled: isRecommendationEdit
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
    
//    private func setupFromEventDetail(_ eventDetail: EventDetailData) {
//        print("EventDetailData로부터 초기값 설정...")
//        
//        // 개인 정보
//        nickname = eventDetail.hostInfo.hostName
//        alias = eventDetail.hostInfo.hostNickname
//        
//        // 금액 (EventDetailData의 cost 사용)
//        money = "\(eventDetail.eventInfo.cost)"
//        print("기존 기록 금액 설정: \(eventDetail.eventInfo.cost)원")
//        
//        // 참석 여부
//        let attendanceText = eventDetail.eventInfo.isAttend ? "참석" : "미참석"
//        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
//            selectedAttend = attendItem
//        }
//        
//        // 날짜 설정 (API 형식: "2025-01-18" → "2025년 1월 18일")
//        selectedDate = formatDateForDisplay(eventDetail.eventInfo.eventDate)
//        
//        // 관계
//        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
//            selectedRelation = relationItem
//        }
//        
//        // 이벤트 카테고리
//        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
//            selectedEvent = eventItem
//        }
//    }
    
    private func setupFromEventDetail(_ eventDetail: EventDetailData) {
        print("EventDetailData로부터 초기값 설정...")
        
        // 개인 정보
        nickname = eventDetail.hostInfo.hostName
        alias = eventDetail.hostInfo.hostNickname
        
        // 금액
        money = "\(eventDetail.eventInfo.cost)"
        print("기존 기록 금액 설정: \(eventDetail.eventInfo.cost)원")
        
        // 참석 여부
        let attendanceText = eventDetail.eventInfo.isAttend ? "참석" : "미참석"
        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
            selectedAttend = attendItem
        }
        
        // 날짜 설정
        selectedDate = formatDateForDisplay(eventDetail.eventInfo.eventDate)
        
        // 위치 정보 설정 (추가)
        locationName = eventDetail.locationInfo.location
          locationAddress = eventDetail.locationInfo.location
          
          // 위경도 설정 (EventDetailData에 위경도가 있다고 가정)
        longitude = eventDetail.locationInfo.longitude
        latitude = eventDetail.locationInfo.latitude
          
        
          
          print("✅ 위치 정보 설정 완료")
          print("  - 위치명: \(locationName)")
          print("  - 위치 주소: \(locationAddress)")
          print("  - 좌표: (\(longitude), \(latitude))")
        
        // 관계
        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
            selectedRelation = relationItem
        }
        
        // 이벤트 카테고리
        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
            selectedEvent = eventItem
        }
        
        print("✅ 위치 정보 설정 완료")
        print("  - 위치명: \(locationName)")
        print("  - 위치 주소: \(locationAddress)")
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
        
        locationName = eventManager.locationName
        locationAddress = eventManager.locationAddress
        longitude = eventManager.longitude
        latitude = eventManager.latitude
        
        print("✅ 위치 정보 설정 완료")
        print("  - 위치명: \(locationName)")
        print("  - 위치 주소: \(locationAddress)")
        print("  - 좌표: (\(longitude), \(latitude))")
        
        
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
            submitGeneralUpdate()
//            router.pop()
        }
    }
    
    private func submitGeneralUpdate() {
        Task {
            do {
                let eventData = createEventData() // CreateEventView와 동일한 로직
                
                // 수정 API 호출 (eventId 필요)
                guard let eventId = eventDetailData?.eventId else {
                    await MainActor.run {
                        submitError = "이벤트 ID를 찾을 수 없습니다."
                        isSubmitting = false
                    }
                    return
                }
                
                let response = try await DIContainer.shared.eventService.updateEvent(
                    eventId: eventId,
                    eventData: eventData
                ).async()
                
                if response.isSuccess {
                    await MainActor.run {
                        print("✅ 경조사 수정 성공!")
                        router.pop() // 이전 화면으로 돌아가기
                    }
                } else {
                    await MainActor.run {
                        submitError = response.message
                        isSubmitting = false
                    }
                }
            } catch {
                await MainActor.run {
                    submitError = "수정에 실패했습니다: \(error.localizedDescription)"
                    isSubmitting = false
                }
            }
        }
    }
    
    private func createEventData() -> UpdateEventData {
        // 날짜 변환 (UI 형식 → API 형식)
        let apiDateString = formatDateForAPI(selectedDate)
        
        let hostInfo = HostInfo(
            hostName: nickname,
            hostNickname: alias
        )
        
        let eventInfo = UpdateEventInfo(
            eventCategory: selectedEvent?.title ?? "",
            relationship: selectedRelation?.title ?? "",
            cost: Int(money) ?? 0,
            isAttend: selectedAttend?.title == "참석",
            eventDate: apiDateString,
            note: memo
        )
        
        // 위치 정보 설정
        let locationInfo = LocationDetailInfo(
            location: locationName.isEmpty ? "미정" : locationName,
            address: locationAddress.isEmpty ? "미정" : locationAddress,
            latitude: latitude,
            longitude: longitude
        )
        
        
        return UpdateEventData(
            hostInfo: hostInfo,
            eventInfo: eventInfo,
            locationInfo: locationInfo
   
        )
    }
    
    private func formatDateForAPI(_ uiDateString: String) -> String {
        // "2025년 7월 17일" → "2025-07-17"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy년 M월 d일"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: uiDateString) {
            return outputFormatter.string(from: date)
        } else {
            // 이미 API 형식인 경우 그대로 반환
            return uiDateString
        }
    }

    
    /// 🆕 수정된 추천 데이터로 이벤트 생성
    ///
    /// 
//    private func submitModifiedRecommendation() {
//        print("📝 수정된 추천 데이터로 이벤트 생성 시작...")
//        
//        Task {
//            // 수정된 데이터로 EventCreationManager 업데이트
//            updateEventManagerWithModifiedData()
//            
//            // 수정된 금액으로 이벤트 생성
//            let modifiedAmount = Int(money) ?? 0
//            let success = await eventManager.submitEventWithModifiedAmount(modifiedAmount: modifiedAmount)
//            
//            if success {
//                await MainActor.run {
//                    router.push(to: .recommendSuccessView)
//                }
//            } else {
//                print("수정된 이벤트 생성 실패: \(eventManager.submitError ?? "알 수 없는 오류")")
//                // TODO: 에러 처리
//            }
//        }
//    }
    
    private func submitModifiedRecommendation() {
        guard isFormValid else {
            submitError = "모든 필수 정보를 입력해주세요."
            return
        }
        
        print("📝 수정된 추천 데이터로 이벤트 생성 시작...")
        
        isSubmitting = true
        submitError = nil
        
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
                await MainActor.run {
                    submitError = eventManager.submitError ?? "수정에 실패했습니다."
                    isSubmitting = false
                }
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




//struct ModifyEventView2: View {
//    let mode: ModifyMode
//    @EnvironmentObject var eventManager: EventCreationManager
//    @EnvironmentObject var router: NavigationRouter
//    let eventDetailData: EventDetailData?
//   
//    @State var nickname: String = ""
//    @State var alias: String = ""
//    @State var money: String = ""
//    @State var memo: String = ""
//    @State private var selectedAttend: TextDropdownItem?
//    @State private var selectedEvent: TextDropdownItem?
//    @State private var selectedRelation: TextDropdownItem?
//    @State private var showDatePicker = false
//    @State var selectedDate: String = ""
//    @Environment(\.dismiss) private var dismiss
//    
//    private var isRecommendationEdit: Bool {
//           return mode == .edit && eventDetailData == nil && eventManager.recommendationResponse != nil
//       }
//   
//    let attendItems = [
//        TextDropdownItem(title: "참석"),
//        TextDropdownItem(title: "미참석"),
//    ]
//    
//    let eventItems = [
//            TextDropdownItem(title: "결혼식"),
//            TextDropdownItem(title: "장례식"),
//            TextDropdownItem(title: "돌잔치"),
//            TextDropdownItem(title: "생일")
//        ]
//        
//        let relationItems = [
//            TextDropdownItem(title: "가족/친척"),
//            TextDropdownItem(title: "친구"),
//            TextDropdownItem(title: "직장"),
//            TextDropdownItem(title: "선후배"),
//            TextDropdownItem(title: "이웃"),
//            TextDropdownItem(title: "기타")
//        ]
//   
//    init(mode: ModifyMode, eventDetailData: EventDetailData? = nil) {
//        self.mode = mode
//        self.eventDetailData = eventDetailData
//        print("🔧 ModifyEventView init - mode: \(mode)")
//    }
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Text("취소")
//                            .bodyRegular16()
//                            .foregroundStyle(.gray200)
//                    }
//                    .frame(width: 44, height: 44)
//                    .padding(.leading, -8)
//                    
//                    Spacer()
//                    
//                    Text(mode == .create ? "경조사 기록하기" : "경조사 수정하기")
//                        .titleSemiBold18()
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                    
//                    Color.clear
//                        .frame(width: 44, height: 44)
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 4)
//                .padding(.bottom, 16)
//                .background(.gray900)
//                
//                VStack(spacing: 0) {
//                    VStack {
//                        CustomTextField(
//                            title: "이름",
//                            icon: "icon_person_16",
//                            placeholder: "닉네임을 입력하세요",
//                            text: $nickname,
//                            validationRule: ValidationRule(
//                                minLength: 2,
//                                maxLength: 10
//                            ),isReadOnly: isRecommendationEdit,isRequired: true
//                        )
//                        
//                        CustomTextField(
//                            title: "별명",
//                            icon: "icon_event_16",
//                            placeholder: "별명을 입력하세요",
//                            text: $alias,
//                            validationRule: ValidationRule(
//                                minLength: 2,
//                                maxLength: 10
//                            ),isReadOnly: isRecommendationEdit,isRequired: true
//                        )
//                        .padding(.top, 32)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 24)
//
//                    dropdownSection
//                        .padding(.top, 16)
//
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack(spacing: 8) {
//                            CustomTextField(
//                                title: "경조사비",
//                                icon: "icon_coin_16",
//                                placeholder: "금액을 입력하세요",
//                                text: $money,
//                                validationRule: ValidationRule(
//                                    minLength: 1,
//                                    maxLength: 10
//                                ),keyboardType: .numberPad
//                            )
//                            
//                            Text("원")
//                                .bodyRegular16()
//                                .foregroundColor(.white)
//                        }
//                        
//                        CustomDropdown(
//                            title: "참석여부",
//                            icon: "icon_check 1",
//                            placeholder: "경조사를 선택하세요",
//                            items: attendItems,
//                            selectedItem: $selectedAttend,
//                            isDisabled: isRecommendationEdit
//                        )
//                        .padding(.top, 16)
//                        
//                        CustomTextField(
//                            title: "날짜",
//                            icon: "icon_calendar_16",
//                            placeholder: "생년월일을 입력하세요",
//                            text: $selectedDate,
//                            isReadOnly: true,
//                            isRequired: true) {
//                                print("생년월일 필드 터치됨")
//                                
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                    showDatePicker = true
//                                }
//                            }
//                            .padding(.top, 16)
//                        
//                        EventMapView()
//                            .padding(.top, 16)
//                        
//
//                        
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 16)
//                    .padding(.bottom, 24)
//                }
//                .background(.gray800)
//                .cornerRadius(12)
//                .padding(.horizontal, 20)
//                .padding(.top, 16)
//                
//                EventMemoView(memo: $memo)
//                    .padding(.top, 16)
//                    .padding(.horizontal, 20)
//                
//                Button {
//                    if mode == .create {
//                        createEvent()
//                    } else {
//                        updateEvent()
//                    }
//                } label: {
//                    Text(mode == .create ? "기록하기" : "수정하기")
//                        .titleSemiBold18()
//                        .foregroundColor(.white)
//                }
//                .frame(maxWidth: .infinity)
//                .frame(height: 55)
//                .background(.primaryNormal)
//                .cornerRadius(12)
//                .padding(.horizontal, 20)
//                .padding(.top, 8)
//            }
//            .onTapGesture {
//                hideKeyboard()
//            }
//            .sheet(isPresented: $showDatePicker) {
//                DatePickerBottomSheetView3(
//                    onComplete: { selectedDateString in
//                        selectedDate = selectedDateString
//                        print("선택된 날짜: \(selectedDateString)")
//                    }
//
//                )
//                .presentationDetents([.height(359)])
//            }
//        }
//        .sheet(isPresented: $showDatePicker) {
//            DatePickerBottomSheetView2 { selectedDateString in
//                selectedDate = selectedDateString
//                print("선택된 날짜: \(selectedDateString)")
//            }
//            .presentationDetents([.height(359)])
//        }
//
//        .background(.gray900)
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden()
//        .toolbar(.hidden, for: .navigationBar)
//        .onAppear {
//            setupInitialValues()
//        }
//    }
//   
//    
//    private var dropdownSection: some View {
//        VStack(spacing: 24) {
//            CustomDropdown(
//                title: "관계",
//                icon: "icon_relation",
//                placeholder: "관계를 선택하세요",
//                items: relationItems,
//                selectedItem: $selectedRelation,
//                isDisabled: isRecommendationEdit
//            )
//            
//            CustomDropdown(
//                title: "경조사",
//                icon: "icon_event_16",
//                placeholder: "경조사를 선택하세요",
//                items: eventItems,
//                selectedItem: $selectedEvent,
//                isDisabled: isRecommendationEdit
//            )
//        }
//        .padding(.horizontal, 20)
//    }
//   
//    /// 🆕 초기값 설정 메서드 - EventCreationManager에서 직접 접근
//    private func setupInitialValues() {
//        print("🔧 초기값 설정 시작...")
//        
//        if let eventDetail = eventDetailData {
//            // AllRecordsView에서 온 경우: EventDetailData 사용
//            setupFromEventDetail(eventDetail)
//        } else {
//            // 추천 플로우에서 온 경우: EventCreationManager 사용
//            setupFromRecommendation()
//        }
//        
//        print("✅ 초기값 설정 완료")
//        print("  - 닉네임: \(nickname)")
//        print("  - 별명: \(alias)")
//        print("  - 금액: \(money)원")
//        print("  - 참석: \(selectedAttend?.title ?? "없음")")
//        print("  - 날짜: \(selectedDate)")
//    }
//    
//    private func setupFromEventDetail(_ eventDetail: EventDetailData) {
//        print("EventDetailData로부터 초기값 설정...")
//        
//        // 개인 정보
//        nickname = eventDetail.hostInfo.hostName
//        alias = eventDetail.hostInfo.hostNickname
//        
//        // 금액 (EventDetailData의 cost 사용)
//        money = "\(eventDetail.eventInfo.cost)"
//        print("기존 기록 금액 설정: \(eventDetail.eventInfo.cost)원")
//        
//        // 참석 여부
//        let attendanceText = eventDetail.eventInfo.isAttend ? "참석" : "미참석"
//        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
//            selectedAttend = attendItem
//        }
//        
//        // 날짜 설정 (API 형식: "2025-01-18" → "2025년 1월 18일")
//        selectedDate = formatDateForDisplay(eventDetail.eventInfo.eventDate)
//        
//        // 관계
//        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
//            selectedRelation = relationItem
//        }
//        
//        // 이벤트 카테고리
//        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
//            selectedEvent = eventItem
//        }
//    }
//    
//    private func setupFromRecommendation() {
//        print("🎯 EventCreationManager로부터 초기값 설정...")
//        
//        // EventCreationManager에서 기존 입력 데이터 가져오기
//        nickname = eventManager.hostName
//        alias = eventManager.hostNickname
//        
//        // 추천받은 금액 설정 (있는 경우)
//        if let recommendation = eventManager.recommendationResponse,
//           let data = recommendation.data {
//            money = "\(data.cost)"
//            print("💰 추천 금액 설정: \(data.cost)원")
//        }
//        
//        // 참석 여부 설정
//        let attendanceText = eventManager.isAttend ? "참석" : "미참석"
//        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
//            selectedAttend = attendItem
//        }
//        
//        // 날짜 설정
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy년 M월 d일"
//        formatter.locale = Locale(identifier: "ko_KR")
//        selectedDate = formatter.string(from: eventManager.eventDate)
//        
//        // 관계
//        if let relationItem = relationItems.first(where: { $0.title == eventManager.relationship }) {
//            selectedRelation = relationItem
//        }
//        
//        // 이벤트 카테고리
//        if let eventItem = eventItems.first(where: { $0.title == eventManager.eventCategory }) {
//            selectedEvent = eventItem
//        }
//    }
//
//    /// 날짜 포맷 변환 헬퍼 메서드
//    private func formatDateForDisplay(_ apiDateString: String) -> String {
//        // API 형식: "2025-01-18" → UI 형식: "2025년 1월 18일"
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "yyyy년 M월 d일"
//        outputFormatter.locale = Locale(identifier: "ko_KR")
//        
//        if let date = inputFormatter.date(from: apiDateString) {
//            return outputFormatter.string(from: date)
//        } else {
//            return apiDateString // 변환 실패 시 원본 반환
//        }
//    }
//    
//    
//    
//    
//    private func createEvent() {
//        // 새 이벤트 생성 로직 (기존과 동일)
//    }
//    
//    private func updateEvent() {
//        // 수정된 이벤트 생성 로직
//        if mode == .edit && eventManager.recommendationResponse != nil {
//            // 추천 금액 수정 모드
//            submitModifiedRecommendation()
//        } else {
//            // 일반 수정 모드
//            router.pop()
//        }
//    }
//    
//    /// 🆕 수정된 추천 데이터로 이벤트 생성
//    private func submitModifiedRecommendation() {
//        print("📝 수정된 추천 데이터로 이벤트 생성 시작...")
//        
//        Task {
//            // 수정된 데이터로 EventCreationManager 업데이트
//            updateEventManagerWithModifiedData()
//            
//            // 수정된 금액으로 이벤트 생성
//            let modifiedAmount = Int(money) ?? 0
//            let success = await eventManager.submitEventWithModifiedAmount(modifiedAmount: modifiedAmount)
//            
//            if success {
//                await MainActor.run {
//                    router.push(to: .recommendSuccessView)
//                }
//            } else {
//                print("수정된 이벤트 생성 실패: \(eventManager.submitError ?? "알 수 없는 오류")")
//                // TODO: 에러 처리
//            }
//        }
//    }
//    
//    ///  수정된 데이터로 EventCreationManager 업데이트
//    private func updateEventManagerWithModifiedData() {
//        // 수정된 개인 정보 업데이트
//        eventManager.updateRecommendData(
//            hostName: nickname,
//            hostNickname: alias,
//            relationship: eventManager.relationship,
//            detailSelected: eventManager.detailSelected,
//            contactFrequency: eventManager.contactFrequency,
//            meetFrequency: eventManager.meetFrequency
//        )
//        
//        // 참석 여부 업데이트
//        let isAttending = selectedAttend?.title == "참석"
//        let attendanceType: AttendanceType = isAttending ? .yes : .no
//        
//        eventManager.updateDateData(
//            eventDate: eventManager.eventDate,
//            selectedAttendance: attendanceType
//        )
//        
//        print("EventCreationManager 데이터 업데이트 완료")
//    }
//    
//}

//struct ModifyEventView2: View {
//    let mode: ModifyMode
//    @EnvironmentObject var eventManager: EventCreationManager
//    @EnvironmentObject var router: NavigationRouter
//    let eventDetailData: EventDetailData?
//    @State private var mapView: KakaoMapView?
//    @State var longitude: Double = 0.0
//    @State var latitude: Double = 0.0
//   
//    @State var nickname: String = ""
//    @State var alias: String = ""
//    @State var money: String = ""
//    @State var memo: String = ""
//    @State private var selectedAttend: TextDropdownItem?
//    @State private var selectedEvent: TextDropdownItem?
//    @State private var selectedRelation: TextDropdownItem?
//    @State var locationName: String = ""
//    @State var locationAddress: String = ""
//    @State private var showDatePicker = false
//    @State var selectedDate: String = ""
//    @Environment(\.dismiss) private var dismiss
//    
//    private var isRecommendationEdit: Bool {
//           return mode == .edit && eventDetailData == nil && eventManager.recommendationResponse != nil
//       }
//   
//    private var hasLocationData: Bool {
//         return !locationName.isEmpty && longitude != 0.0 && latitude != 0.0
//     }
//    
//    let attendItems = [
//        TextDropdownItem(title: "참석"),
//        TextDropdownItem(title: "미참석"),
//    ]
//    
//    let eventItems = [
//            TextDropdownItem(title: "결혼식"),
//            TextDropdownItem(title: "장례식"),
//            TextDropdownItem(title: "돌잔치"),
//            TextDropdownItem(title: "생일")
//        ]
//        
//        let relationItems = [
//            TextDropdownItem(title: "가족/친척"),
//            TextDropdownItem(title: "친구"),
//            TextDropdownItem(title: "직장"),
//            TextDropdownItem(title: "선후배"),
//            TextDropdownItem(title: "이웃"),
//            TextDropdownItem(title: "기타")
//        ]
//   
//    init(mode: ModifyMode, eventDetailData: EventDetailData? = nil) {
//        self.mode = mode
//        self.eventDetailData = eventDetailData
//        print("🔧 ModifyEventView init - mode: \(mode)")
//    }
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Text("취소")
//                            .bodyRegular16()
//                            .foregroundStyle(.gray200)
//                    }
//                    .frame(width: 44, height: 44)
//                    .padding(.leading, -8)
//                    
//                    Spacer()
//                    
//                    Text(mode == .create ? "경조사 기록하기" : "경조사 수정하기")
//                        .titleSemiBold18()
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                    
//                    Color.clear
//                        .frame(width: 44, height: 44)
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 4)
//                .padding(.bottom, 16)
//                .background(.gray900)
//                
//                VStack(spacing: 0) {
//                    VStack {
//                        CustomTextField(
//                            title: "이름",
//                            icon: "icon_person_16",
//                            placeholder: "닉네임을 입력하세요",
//                            text: $nickname,
//                            validationRule: ValidationRule(
//                                minLength: 2,
//                                maxLength: 10
//                            ),isReadOnly: isRecommendationEdit,isRequired: true
//                        )
//                        
//                        CustomTextField(
//                            title: "별명",
//                            icon: "icon_event_16",
//                            placeholder: "별명을 입력하세요",
//                            text: $alias,
//                            validationRule: ValidationRule(
//                                minLength: 2,
//                                maxLength: 10
//                            ),isReadOnly: isRecommendationEdit,isRequired: true
//                        )
//                        .padding(.top, 32)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 24)
//
//                    dropdownSection
//                        .padding(.top, 16)
//
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack(spacing: 8) {
//                            CustomTextField(
//                                title: "경조사비",
//                                icon: "icon_coin_16",
//                                placeholder: "금액을 입력하세요",
//                                text: $money,
//                                validationRule: ValidationRule(
//                                    minLength: 1,
//                                    maxLength: 10
//                                ),keyboardType: .numberPad
//                            )
//                            
//                            Text("원")
//                                .bodyRegular16()
//                                .foregroundColor(.white)
//                        }
//                        
//                        CustomDropdown(
//                            title: "참석여부",
//                            icon: "icon_check 1",
//                            placeholder: "경조사를 선택하세요",
//                            items: attendItems,
//                            selectedItem: $selectedAttend,
//                            isDisabled: isRecommendationEdit
//                        )
//                        .padding(.top, 16)
//                        
//                        CustomTextField(
//                            title: "날짜",
//                            icon: "icon_calendar_16",
//                            placeholder: "생년월일을 입력하세요",
//                            text: $selectedDate,
//                            isReadOnly: true,
//                            isRequired: true) {
//                                print("생년월일 필드 터치됨")
//                                
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                    showDatePicker = true
//                                }
//                            }
//                            .padding(.top, 16)
//                        
//                        VStack(spacing: 16) {
//                            HStack {
//                                HStack {
//                                    Image("icon_location_16")
//                                    Text("행사장")
//                                        .bodyMedium14()
//                                        .foregroundStyle(.gray300)
//                                }
//                                
//                                Spacer()
//                                
//                                Button {
//                                    print("수정하기")
//                                } label: {
//                                    Text("수정하기")
//                                        .bodyRegular14()
//                                        .foregroundStyle(.gray300)
//                                }
//                            }
//                            
//                            VStack(alignment: .leading, spacing: 8) {
//                                mapSection
//                                    .frame(maxWidth: .infinity)
//                                    .frame(height: 180)
//                                    .cornerRadius(12)
//                                
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(locationName)
//                                        .bodyMedium16()
//                                        .foregroundStyle(.white)
//                                    
//                                    Text(locationAddress)
//                                        .bodyMedium16()
//                                        .foregroundStyle(.gray300)
//                                }
//                            }
//                        }
//                            .padding(.top, 16)
//                        
//
//                        
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 16)
//                    .padding(.bottom, 24)
//                }
//                .background(.gray800)
//                .cornerRadius(12)
//                .padding(.horizontal, 20)
//                .padding(.top, 16)
//                
//                EventMemoView(memo: $memo)
//                    .padding(.top, 16)
//                    .padding(.horizontal, 20)
//                
//                Button {
//                    if mode == .create {
//                        createEvent()
//                    } else {
//                        updateEvent()
//                    }
//                } label: {
//                    Text(mode == .create ? "기록하기" : "수정하기")
//                        .titleSemiBold18()
//                        .foregroundColor(.white)
//                }
//                .frame(maxWidth: .infinity)
//                .frame(height: 55)
//                .background(.primaryNormal)
//                .cornerRadius(12)
//                .padding(.horizontal, 20)
//                .padding(.top, 8)
//            }
//            .onTapGesture {
//                hideKeyboard()
//            }
//            .sheet(isPresented: $showDatePicker) {
//                DatePickerBottomSheetView3(
//                    onComplete: { selectedDateString in
//                        selectedDate = selectedDateString
//                        print("선택된 날짜: \(selectedDateString)")
//                    }
//
//                )
//                .presentationDetents([.height(359)])
//            }
//        }
//        .background(.gray900)
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden()
//        .toolbar(.hidden, for: .navigationBar)
//        .onAppear {
//            setupInitialValues()
//        }
//    }
//    
//    private var mapSection: some View {
//           Group {
//               // 위치 정보가 있는 경우 지도 표시
//               if hasLocationData {
//                   if let mapView = mapView {
//                       mapView
//                           .frame(height: 180)
//                           .cornerRadius(12)
//                           .onAppear {
//                               updateMapLocation()
//                           }
//                   } else {
//                       Rectangle()
//                           .foregroundStyle(.gray750)
//                           .frame(maxWidth: .infinity)
//                           .frame(height: 180)
//                           .cornerRadius(12)
//                           .onAppear {
//                               mapView = KakaoMapView(draw: .constant(true))
//                               // 지도 생성 후 위치 업데이트
//                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                   updateMapLocation()
//                               }
//                           }
//                   }
//               } else {
//                   // 위치 정보가 없는 경우 빈 Rectangle 표시
//                   VStack {
//                       Image(systemName: "location.slash")
//                           .font(.system(size: 30))
//                           .foregroundColor(.gray500)
//                       
//                       Text("위치 정보가 없습니다")
//                           .bodyRegular14()
//                           .foregroundColor(.gray500)
//                           .padding(.top, 8)
//                   }
//                   .frame(maxWidth: .infinity)
//                   .frame(height: 180)
//                   .background(.gray750)
//                   .cornerRadius(12)
//               }
//           }
//       }
//    
//    private func updateMapLocation() {
//         guard hasLocationData else { return }
//         
//         mapView?.updateLocation(longitude: longitude, latitude: latitude)
//         print("🗺️ 지도 위치 업데이트: \(locationName)")
//         print("📍 좌표: \(longitude), \(latitude)")
//     }
//    
//    private func handleLocationSelection(_ document: KLDocument) {
//        // EventCreationManager에 위치 데이터 저장
//        eventManager.updateLocationData(selectedLocation: document)
//        
//        locationName = document.placeName
//         locationAddress = document.addressName
//        
//        // 지도 위치 업데이트
//        if let longitude = Double(document.x),
//           let latitude = Double(document.y) {
//            mapView?.updateLocation(longitude: longitude, latitude: latitude)
//            print("지도 위치 업데이트: \(document.placeName)")
//            print("좌표: \(longitude), \(latitude)")
//        }
//
//    }
//   
//    
//    private var dropdownSection: some View {
//        VStack(spacing: 24) {
//            CustomDropdown(
//                title: "관계",
//                icon: "icon_relation",
//                placeholder: "관계를 선택하세요",
//                items: relationItems,
//                selectedItem: $selectedRelation,
//                isDisabled: isRecommendationEdit
//            )
//            
//            CustomDropdown(
//                title: "경조사",
//                icon: "icon_event_16",
//                placeholder: "경조사를 선택하세요",
//                items: eventItems,
//                selectedItem: $selectedEvent,
//                isDisabled: isRecommendationEdit
//            )
//        }
//        .padding(.horizontal, 20)
//    }
//   
//    /// 🆕 초기값 설정 메서드 - EventCreationManager에서 직접 접근
//    private func setupInitialValues() {
//        print("🔧 초기값 설정 시작...")
//        
//        if let eventDetail = eventDetailData {
//            // AllRecordsView에서 온 경우: EventDetailData 사용
//            setupFromEventDetail(eventDetail)
//        } else {
//            // 추천 플로우에서 온 경우: EventCreationManager 사용
//            setupFromRecommendation()
//        }
//        
//        print("✅ 초기값 설정 완료")
//        print("  - 닉네임: \(nickname)")
//        print("  - 별명: \(alias)")
//        print("  - 금액: \(money)원")
//        print("  - 참석: \(selectedAttend?.title ?? "없음")")
//        print("  - 날짜: \(selectedDate)")
//    }
//    
////    private func setupFromEventDetail(_ eventDetail: EventDetailData) {
////        print("EventDetailData로부터 초기값 설정...")
////
////        // 개인 정보
////        nickname = eventDetail.hostInfo.hostName
////        alias = eventDetail.hostInfo.hostNickname
////
////        // 금액 (EventDetailData의 cost 사용)
////        money = "\(eventDetail.eventInfo.cost)"
////        print("기존 기록 금액 설정: \(eventDetail.eventInfo.cost)원")
////
////        // 참석 여부
////        let attendanceText = eventDetail.eventInfo.isAttend ? "참석" : "미참석"
////        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
////            selectedAttend = attendItem
////        }
////
////        // 날짜 설정 (API 형식: "2025-01-18" → "2025년 1월 18일")
////        selectedDate = formatDateForDisplay(eventDetail.eventInfo.eventDate)
////
////        // 관계
////        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
////            selectedRelation = relationItem
////        }
////
////        // 이벤트 카테고리
////        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
////            selectedEvent = eventItem
////        }
////    }
//    
//    private func setupFromEventDetail(_ eventDetail: EventDetailData) {
//        print("EventDetailData로부터 초기값 설정...")
//        
//        // 개인 정보
//        nickname = eventDetail.hostInfo.hostName
//        alias = eventDetail.hostInfo.hostNickname
//        
//        // 금액
//        money = "\(eventDetail.eventInfo.cost)"
//        print("기존 기록 금액 설정: \(eventDetail.eventInfo.cost)원")
//        
//        // 참석 여부
//        let attendanceText = eventDetail.eventInfo.isAttend ? "참석" : "미참석"
//        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
//            selectedAttend = attendItem
//        }
//        
//        // 날짜 설정
//        selectedDate = formatDateForDisplay(eventDetail.eventInfo.eventDate)
//        
//        // 위치 정보 설정 (추가)
//        locationName = eventDetail.locationInfo.location
//          locationAddress = eventDetail.locationInfo.location
//          
//          // 위경도 설정 (EventDetailData에 위경도가 있다고 가정)
//        longitude = eventDetail.locationInfo.longitude
//        latitude = eventDetail.locationInfo.latitude
//          
//        
//          
//          print("✅ 위치 정보 설정 완료")
//          print("  - 위치명: \(locationName)")
//          print("  - 위치 주소: \(locationAddress)")
//          print("  - 좌표: (\(longitude), \(latitude))")
//        
//        // 관계
//        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
//            selectedRelation = relationItem
//        }
//        
//        // 이벤트 카테고리
//        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
//            selectedEvent = eventItem
//        }
//        
//        print("✅ 위치 정보 설정 완료")
//        print("  - 위치명: \(locationName)")
//        print("  - 위치 주소: \(locationAddress)")
//    }
//    
//    private func setupFromRecommendation() {
//        print("🎯 EventCreationManager로부터 초기값 설정...")
//        
//        // EventCreationManager에서 기존 입력 데이터 가져오기
//        nickname = eventManager.hostName
//        alias = eventManager.hostNickname
//        
//        // 추천받은 금액 설정 (있는 경우)
//        if let recommendation = eventManager.recommendationResponse,
//           let data = recommendation.data {
//            money = "\(data.cost)"
//            print("💰 추천 금액 설정: \(data.cost)원")
//        }
//        
//        // 참석 여부 설정
//        let attendanceText = eventManager.isAttend ? "참석" : "미참석"
//        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
//            selectedAttend = attendItem
//        }
//        
//        // 날짜 설정
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy년 M월 d일"
//        formatter.locale = Locale(identifier: "ko_KR")
//        selectedDate = formatter.string(from: eventManager.eventDate)
//        
//        // 관계
//        if let relationItem = relationItems.first(where: { $0.title == eventManager.relationship }) {
//            selectedRelation = relationItem
//        }
//        
//        locationName = eventManager.locationName
//        locationAddress = eventManager.locationAddress
//        longitude = eventManager.longitude
//        latitude = eventManager.latitude
//        
//        print("✅ 위치 정보 설정 완료")
//        print("  - 위치명: \(locationName)")
//        print("  - 위치 주소: \(locationAddress)")
//        print("  - 좌표: (\(longitude), \(latitude))")
//        
//        
//        // 이벤트 카테고리
//        if let eventItem = eventItems.first(where: { $0.title == eventManager.eventCategory }) {
//            selectedEvent = eventItem
//        }
//    }
//
//    /// 날짜 포맷 변환 헬퍼 메서드
//    private func formatDateForDisplay(_ apiDateString: String) -> String {
//        // API 형식: "2025-01-18" → UI 형식: "2025년 1월 18일"
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "yyyy년 M월 d일"
//        outputFormatter.locale = Locale(identifier: "ko_KR")
//        
//        if let date = inputFormatter.date(from: apiDateString) {
//            return outputFormatter.string(from: date)
//        } else {
//            return apiDateString // 변환 실패 시 원본 반환
//        }
//    }
//    
//    
//    
//    
//    private func createEvent() {
//        // 새 이벤트 생성 로직 (기존과 동일)
//    }
//    
//    private func updateEvent() {
//        // 수정된 이벤트 생성 로직
//        if mode == .edit && eventManager.recommendationResponse != nil {
//            // 추천 금액 수정 모드
//            submitModifiedRecommendation()
//        } else {
//            // 일반 수정 모드
//            router.pop()
//        }
//    }
//    
//    /// 🆕 수정된 추천 데이터로 이벤트 생성
//    private func submitModifiedRecommendation() {
//        print("📝 수정된 추천 데이터로 이벤트 생성 시작...")
//        
//        Task {
//            // 수정된 데이터로 EventCreationManager 업데이트
//            updateEventManagerWithModifiedData()
//            
//            // 수정된 금액으로 이벤트 생성
//            let modifiedAmount = Int(money) ?? 0
//            let success = await eventManager.submitEventWithModifiedAmount(modifiedAmount: modifiedAmount)
//            
//            if success {
//                await MainActor.run {
//                    router.push(to: .recommendSuccessView)
//                }
//            } else {
//                print("수정된 이벤트 생성 실패: \(eventManager.submitError ?? "알 수 없는 오류")")
//                // TODO: 에러 처리
//            }
//        }
//    }
//    
//    ///  수정된 데이터로 EventCreationManager 업데이트
//    private func updateEventManagerWithModifiedData() {
//        // 수정된 개인 정보 업데이트
//        eventManager.updateRecommendData(
//            hostName: nickname,
//            hostNickname: alias,
//            relationship: eventManager.relationship,
//            detailSelected: eventManager.detailSelected,
//            contactFrequency: eventManager.contactFrequency,
//            meetFrequency: eventManager.meetFrequency
//        )
//        
//        // 참석 여부 업데이트
//        let isAttending = selectedAttend?.title == "참석"
//        let attendanceType: AttendanceType = isAttending ? .yes : .no
//        
//        eventManager.updateDateData(
//            eventDate: eventManager.eventDate,
//            selectedAttendance: attendanceType
//        )
//        
//        print("EventCreationManager 데이터 업데이트 완료")
//    }
//    
//}


struct ModifyEventView2: View {
    let mode: ModifyMode
    @EnvironmentObject var eventManager: EventCreationManager
    @EnvironmentObject var router: NavigationRouter
    let eventDetailData: EventDetailData?
    @State private var mapView: KakaoMapView?
    @State var longitude: Double = 0.0
    @State var latitude: Double = 0.0
   
    @State var nickname: String = ""
    @State var alias: String = ""
    @State var money: String = ""
    @State var memo: String = ""
    @State private var selectedAttend: TextDropdownItem?
    @State private var selectedEvent: TextDropdownItem?
    @State private var selectedRelation: TextDropdownItem?
    @State var locationName: String = ""
    @State var locationAddress: String = ""
    @State private var showDatePicker = false
    @State var selectedDate: String = ""
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSubmitting = false
    @State private var submitError: String?
    
    private var isRecommendationEdit: Bool {
           return mode == .edit && eventDetailData == nil && eventManager.recommendationResponse != nil
       }
    
    private var isFormValid: Bool {
        !nickname.isEmpty &&
        !alias.isEmpty &&
        !money.isEmpty &&
        selectedAttend != nil &&
        selectedEvent != nil &&
        selectedRelation != nil &&
        !selectedDate.isEmpty
    }
    
   
    private var hasLocationData: Bool {
         return !locationName.isEmpty && longitude != 0.0 && latitude != 0.0
     }
    
    let attendItems = [
        TextDropdownItem(title: "참석"),
        TextDropdownItem(title: "미참석"),
    ]
    
    let eventItems = [
            TextDropdownItem(title: "결혼식"),
            TextDropdownItem(title: "장례식"),
            TextDropdownItem(title: "돌잔치"),
            TextDropdownItem(title: "생일")
        ]
        
        let relationItems = [
            TextDropdownItem(title: "가족/친척"),
            TextDropdownItem(title: "친구"),
            TextDropdownItem(title: "직장"),
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
                
                VStack(spacing: 0) {
                    VStack {
                        CustomTextField(
                            title: "이름",
                            icon: "icon_person_16",
                            placeholder: "닉네임을 입력하세요",
                            text: $nickname,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10
                            ),isReadOnly: isRecommendationEdit,isRequired: true
                        )
                        
                        CustomTextField(
                            title: "별명",
                            icon: "icon_event_16",
                            placeholder: "별명을 입력하세요",
                            text: $alias,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10
                            ),isReadOnly: isRecommendationEdit,isRequired: true
                        )
                        .padding(.top, 32)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    dropdownSection
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            CustomTextField(
                                title: "경조사비",
                                icon: "icon_coin_16",
                                placeholder: "금액을 입력하세요",
                                text: $money,
                                validationRule: ValidationRule(
                                    minLength: 1,
                                    maxLength: 10
                                ),keyboardType: .numberPad
                            )
                            
                            Text("원")
                                .bodyRegular16()
                                .foregroundColor(.white)
                        }
                        
                        CustomDropdown(
                            title: "참석여부",
                            icon: "icon_check 1",
                            placeholder: "경조사를 선택하세요",
                            items: attendItems,
                            selectedItem: $selectedAttend,
                            isDisabled: isRecommendationEdit
                        )
                        .padding(.top, 16)
                        
                        CustomTextField(
                            title: "날짜",
                            icon: "icon_calendar_16",
                            placeholder: "생년월일을 입력하세요",
                            text: $selectedDate,
                            isReadOnly: true,
                            isRequired: true) {
                                print("생년월일 필드 터치됨")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showDatePicker = true
                                }
                            }
                            .padding(.top, 16)
                        
                        VStack(spacing: 16) {
                            HStack {
                                HStack {
                                    Image("icon_location_16")
                                    Text("행사장")
                                        .bodyMedium14()
                                        .foregroundStyle(.gray300)
                                }
                                
                                Spacer()
                                
                                Button {
                                    print("수정하기")
                                } label: {
                                    Text("수정하기")
                                        .bodyRegular14()
                                        .foregroundStyle(.gray300)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                mapSection
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 180)
                                    .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(locationName)
                                        .bodyMedium16()
                                        .foregroundStyle(.white)
                                    
                                    Text(locationAddress)
                                        .bodyMedium16()
                                        .foregroundStyle(.gray300)
                                }
                            }
                        }
                            .padding(.top, 16)
                        

                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
                .background(.gray800)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                EventMemoView(memo: $memo)
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
                
                Button {
                    if mode == .create {
                        createEvent()
                    } else {
                        updateEvent()
                    }
                } label: {
                    if isSubmitting {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text(mode == .create ? "기록 중..." : "수정 중...")
                                .titleSemiBold18()
                                .foregroundColor(.white)
                        }
                    } else {
                        Text(mode == .create ? "기록하기" : "수정하기")
                            .titleSemiBold18()
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(isFormValid ? .primaryNormal : .gray600)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .disabled(!isFormValid || isSubmitting)
                
                if let error = submitError {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerBottomSheetView3(
                    onComplete: { selectedDateString in
                        selectedDate = selectedDateString
                        print("선택된 날짜: \(selectedDateString)")
                    }

                )
                .presentationDetents([.height(359)])
            }
        }
        .background(.gray900)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            setupInitialValues()
        }
    }
    
    private var mapSection: some View {
           Group {
               // 위치 정보가 있는 경우 지도 표시
               if hasLocationData {
                   if let mapView = mapView {
                       mapView
                           .frame(height: 180)
                           .cornerRadius(12)
                           .onAppear {
                               updateMapLocation()
                           }
                   } else {
                       Rectangle()
                           .foregroundStyle(.gray750)
                           .frame(maxWidth: .infinity)
                           .frame(height: 180)
                           .cornerRadius(12)
                           .onAppear {
                               mapView = KakaoMapView(draw: .constant(true))
                               // 지도 생성 후 위치 업데이트
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                   updateMapLocation()
                               }
                           }
                   }
               } else {
                   // 위치 정보가 없는 경우 빈 Rectangle 표시
                   VStack {
                       Image(systemName: "location.slash")
                           .font(.system(size: 30))
                           .foregroundColor(.gray500)
                       
                       Text("위치 정보가 없습니다")
                           .bodyRegular14()
                           .foregroundColor(.gray500)
                           .padding(.top, 8)
                   }
                   .frame(maxWidth: .infinity)
                   .frame(height: 180)
                   .background(.gray750)
                   .cornerRadius(12)
               }
           }
       }
    
    private func updateMapLocation() {
         guard hasLocationData else { return }
         
         mapView?.updateLocation(longitude: longitude, latitude: latitude)
         print("🗺️ 지도 위치 업데이트: \(locationName)")
         print("📍 좌표: \(longitude), \(latitude)")
     }
    
    private func handleLocationSelection(_ document: KLDocument) {
        // EventCreationManager에 위치 데이터 저장
        eventManager.updateLocationData(selectedLocation: document)
        
        locationName = document.placeName
         locationAddress = document.addressName
        
        // 지도 위치 업데이트
        if let longitude = Double(document.x),
           let latitude = Double(document.y) {
            mapView?.updateLocation(longitude: longitude, latitude: latitude)
            print("지도 위치 업데이트: \(document.placeName)")
            print("좌표: \(longitude), \(latitude)")
        }

    }
   
    
    private var dropdownSection: some View {
        VStack(spacing: 24) {
            CustomDropdown(
                title: "관계",
                icon: "icon_relation",
                placeholder: "관계를 선택하세요",
                items: relationItems,
                selectedItem: $selectedRelation,
                isDisabled: isRecommendationEdit
            )
            
            CustomDropdown(
                title: "경조사",
                icon: "icon_event_16",
                placeholder: "경조사를 선택하세요",
                items: eventItems,
                selectedItem: $selectedEvent,
                isDisabled: isRecommendationEdit
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
    
//    private func setupFromEventDetail(_ eventDetail: EventDetailData) {
//        print("EventDetailData로부터 초기값 설정...")
//
//        // 개인 정보
//        nickname = eventDetail.hostInfo.hostName
//        alias = eventDetail.hostInfo.hostNickname
//
//        // 금액 (EventDetailData의 cost 사용)
//        money = "\(eventDetail.eventInfo.cost)"
//        print("기존 기록 금액 설정: \(eventDetail.eventInfo.cost)원")
//
//        // 참석 여부
//        let attendanceText = eventDetail.eventInfo.isAttend ? "참석" : "미참석"
//        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
//            selectedAttend = attendItem
//        }
//
//        // 날짜 설정 (API 형식: "2025-01-18" → "2025년 1월 18일")
//        selectedDate = formatDateForDisplay(eventDetail.eventInfo.eventDate)
//
//        // 관계
//        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
//            selectedRelation = relationItem
//        }
//
//        // 이벤트 카테고리
//        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
//            selectedEvent = eventItem
//        }
//    }
    
    private func setupFromEventDetail(_ eventDetail: EventDetailData) {
        print("EventDetailData로부터 초기값 설정...")
        
        // 개인 정보
        nickname = eventDetail.hostInfo.hostName
        alias = eventDetail.hostInfo.hostNickname
        
        // 금액
        money = "\(eventDetail.eventInfo.cost)"
        print("기존 기록 금액 설정: \(eventDetail.eventInfo.cost)원")
        
        // 참석 여부
        let attendanceText = eventDetail.eventInfo.isAttend ? "참석" : "미참석"
        if let attendItem = attendItems.first(where: { $0.title == attendanceText }) {
            selectedAttend = attendItem
        }
        
        // 날짜 설정
        selectedDate = formatDateForDisplay(eventDetail.eventInfo.eventDate)
        
        // 위치 정보 설정 (추가)
        locationName = eventDetail.locationInfo.location
          locationAddress = eventDetail.locationInfo.location
          
          // 위경도 설정 (EventDetailData에 위경도가 있다고 가정)
        longitude = eventDetail.locationInfo.longitude
        latitude = eventDetail.locationInfo.latitude
          
        
          
          print("✅ 위치 정보 설정 완료")
          print("  - 위치명: \(locationName)")
          print("  - 위치 주소: \(locationAddress)")
          print("  - 좌표: (\(longitude), \(latitude))")
        
        // 관계
        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
            selectedRelation = relationItem
        }
        
        // 이벤트 카테고리
        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
            selectedEvent = eventItem
        }
        
        print("✅ 위치 정보 설정 완료")
        print("  - 위치명: \(locationName)")
        print("  - 위치 주소: \(locationAddress)")
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
        
        locationName = eventManager.locationName
        locationAddress = eventManager.locationAddress
        longitude = eventManager.longitude
        latitude = eventManager.latitude
        
        print("✅ 위치 정보 설정 완료")
        print("  - 위치명: \(locationName)")
        print("  - 위치 주소: \(locationAddress)")
        print("  - 좌표: (\(longitude), \(latitude))")
        
        
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
            submitGeneralUpdate()
//            router.pop()
        }
    }
    
    private func submitGeneralUpdate() {
        Task {
            do {
                let eventData = createEventData() // CreateEventView와 동일한 로직
                
                // 수정 API 호출 (eventId 필요)
                guard let eventId = eventDetailData?.eventId else {
                    await MainActor.run {
                        submitError = "이벤트 ID를 찾을 수 없습니다."
                        isSubmitting = false
                    }
                    return
                }
                
                let response = try await DIContainer.shared.eventService.updateEvent(
                    eventId: eventId,
                    eventData: eventData
                ).async()
                
                if response.isSuccess {
                    await MainActor.run {
                        print("✅ 경조사 수정 성공!")
                        router.pop() // 이전 화면으로 돌아가기
                    }
                } else {
                    await MainActor.run {
                        submitError = response.message
                        isSubmitting = false
                    }
                }
            } catch {
                await MainActor.run {
                    submitError = "수정에 실패했습니다: \(error.localizedDescription)"
                    isSubmitting = false
                }
            }
        }
    }
    
    private func createEventData() -> UpdateEventData {
        // 날짜 변환 (UI 형식 → API 형식)
        let apiDateString = formatDateForAPI(selectedDate)
        
        let hostInfo = HostInfo(
            hostName: nickname,
            hostNickname: alias
        )
        
        let eventInfo = UpdateEventInfo(
            eventCategory: selectedEvent?.title ?? "",
            relationship: selectedRelation?.title ?? "",
            cost: Int(money) ?? 0,
            isAttend: selectedAttend?.title == "참석",
            eventDate: apiDateString,
            note: memo
        )
        
        // 위치 정보 설정
        let locationInfo = LocationDetailInfo(
            location: locationName.isEmpty ? "미정" : locationName,
            address: locationAddress.isEmpty ? "미정" : locationAddress,
            latitude: latitude,
            longitude: longitude
        )
        
        
        return UpdateEventData(
            hostInfo: hostInfo,
            eventInfo: eventInfo,
            locationInfo: locationInfo
   
        )
    }
    
    private func formatDateForAPI(_ uiDateString: String) -> String {
        // "2025년 7월 17일" → "2025-07-17"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy년 M월 d일"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: uiDateString) {
            return outputFormatter.string(from: date)
        } else {
            // 이미 API 형식인 경우 그대로 반환
            return uiDateString
        }
    }

    
    /// 🆕 수정된 추천 데이터로 이벤트 생성
    ///
    ///
//    private func submitModifiedRecommendation() {
//        print("📝 수정된 추천 데이터로 이벤트 생성 시작...")
//
//        Task {
//            // 수정된 데이터로 EventCreationManager 업데이트
//            updateEventManagerWithModifiedData()
//
//            // 수정된 금액으로 이벤트 생성
//            let modifiedAmount = Int(money) ?? 0
//            let success = await eventManager.submitEventWithModifiedAmount(modifiedAmount: modifiedAmount)
//
//            if success {
//                await MainActor.run {
//                    router.push(to: .recommendSuccessView)
//                }
//            } else {
//                print("수정된 이벤트 생성 실패: \(eventManager.submitError ?? "알 수 없는 오류")")
//                // TODO: 에러 처리
//            }
//        }
//    }
    
    private func submitModifiedRecommendation() {
        guard isFormValid else {
            submitError = "모든 필수 정보를 입력해주세요."
            return
        }
        
        print("📝 수정된 추천 데이터로 이벤트 생성 시작...")
        
        isSubmitting = true
        submitError = nil
        
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
                await MainActor.run {
                    submitError = eventManager.submitError ?? "수정에 실패했습니다."
                    isSubmitting = false
                }
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
