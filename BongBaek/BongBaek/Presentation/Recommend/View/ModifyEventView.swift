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
    
    @State private var selectedLocation: KLDocument?
    @State private var showLargeMapView = false
    
    // 원본 위치 데이터 백업용 변수들
    @State private var originalSelectedLocation: KLDocument?
    @State private var originalLocationName: String = ""
    @State private var originalLocationAddress: String = ""
    @State private var originalLongitude: Double = 0.0
    @State private var originalLatitude: Double = 0.0
   
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
    
    private var isAttending: Bool {
        selectedAttend?.title == "참석"
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
        print("ModifyEventView init - mode: \(mode)")
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
                        .onChange(of: selectedAttend) { _, newValue in
                            if newValue?.title == "미참석" {
                                // 미참석으로 변경 시: 현재 위치를 백업하고 임시로 클리어
                                if selectedLocation != nil {
                                    backupLocationData()
                                }
                                clearCurrentLocationData()
                            } else if newValue?.title == "참석" {
                                // 참석으로 변경 시: 백업된 위치가 있으면 복원
                                if originalSelectedLocation != nil {
                                    restoreLocationData()
                                }
                            }
                        }
                        
                        CustomTextField(
                            title: "날짜",
                            icon: "icon_calendar_16",
                            placeholder: "생년월일을 입력하세요",
                            text: $selectedDate,
                            isReadOnly: true,
                            isRequired: true) {
                                
                                guard !isRecommendationEdit else { return }
                                print("생년월일 필드 터치됨")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showDatePicker = true
                                }
                            }
                            .padding(.top, 16)
                        
                       locationSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
                .background(.gray800)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                EventMemoView(memo: $memo, isDisabled: isRecommendationEdit)
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
                DatePickerBottomSheetView.unlimited(
                    onComplete: { selectedDateString in
                        selectedDate = selectedDateString
                        print("선택된 날짜: \(selectedDateString)")
                    }
                )
                .presentationDetents([.height(359)])
            }
            .fullScreenCover(isPresented: $showLargeMapView) {
                LargeMapView(selectedLocation: $selectedLocation)
            }
        }
        .background(.gray900)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            setupInitialValues()
        }
        .onChange(of: selectedLocation) { _, newLocation in
            if let location = newLocation {
                locationName = location.placeName
                locationAddress = location.addressName
                longitude = Double(location.x) ?? 0.0
                latitude = Double(location.y) ?? 0.0
                
                // 새로운 위치가 설정되면 백업도 업데이트 (참석 상태일 때만)
                if isAttending {
                    backupLocationData()
                }
                
                // 지도 위치 업데이트
                updateMapLocation()
            }
        }
    }
    
    private var locationSection: some View {
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
                    showLargeMapView = true
                } label: {
                    Text("수정하기")
                        .bodyRegular14()
                        .foregroundStyle(
                            (isAttending && !isRecommendationEdit) ? .gray300 : .gray600
                        )
                }
                .disabled(!isAttending || isRecommendationEdit)
            }
            
            // 참석할 때만 지도 섹션 표시
            if isAttending {
                VStack(alignment: .leading, spacing: 8) {
                    // 지도 표시
                    mapSection
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .cornerRadius(12)
                    
                    // 위치 정보 표시
                    if hasLocationData {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(locationName)
                                .bodyMedium16()
                                .foregroundStyle(.white)
                            
                            Text(locationAddress)
                                .bodyMedium16()
                                .foregroundStyle(.gray300)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.gray750)
                        .cornerRadius(8)
                    }
                }
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.3), value: isAttending)
            }
        }
        .padding(.top, 16)
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
         print("지도 위치 업데이트: \(locationName)")
         print("좌표: \(longitude), \(latitude)")
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
   
    // MARK: - 초기값 설정
    private func setupInitialValues() {
        print("초기값 설정 시작...")
        
        if let eventDetail = eventDetailData {
            // AllRecordsView에서 온 경우: EventDetailData 사용
            setupFromEventDetail(eventDetail)
        } else {
            // 추천 플로우에서 온 경우: EventCreationManager 사용
            setupFromRecommendation()
        }
        
        print("초기값 설정 완료")
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
        memo = eventDetail.eventInfo.note ?? "노트를 입력해주세요"
        
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
        
        // 위치 정보 설정
        locationName = eventDetail.locationInfo.location
        locationAddress = eventDetail.locationInfo.address
        longitude = eventDetail.locationInfo.longitude
        latitude = eventDetail.locationInfo.latitude
        
        // selectedLocation 설정
        if hasLocationData {
            selectedLocation = KLDocument(
                placeName: locationName,
                addressName: locationAddress,
                roadAddressName: "",
                x: String(longitude),
                y: String(latitude),
                distance: "0"
            )
            
            // 🆕 초기 데이터를 백업으로 저장
            backupLocationData()
        }
        
        // 관계
        if let relationItem = relationItems.first(where: { $0.title == eventDetail.eventInfo.relationship }) {
            selectedRelation = relationItem
        }
        
        // 이벤트 카테고리
        if let eventItem = eventItems.first(where: { $0.title == eventDetail.eventInfo.eventCategory }) {
            selectedEvent = eventItem
        }
        
        print("위치 정보 설정 완료")
        print("  - 위치명: \(locationName)")
        print("  - 위치 주소: \(locationAddress)")
        print("  - 좌표: (\(longitude), \(latitude))")
    }
    
    private func setupFromRecommendation() {
        print("EventCreationManager로부터 초기값 설정...")
        
        // EventCreationManager에서 기존 입력 데이터 가져오기
        nickname = eventManager.hostName
        alias = eventManager.hostNickname
        
        // 추천받은 금액 설정 (있는 경우)
        if let recommendation = eventManager.recommendationResponse,
           let data = recommendation.data {
            money = "\(data.cost)"
            print("추천 금액 설정: \(data.cost)원")
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
        
        if hasLocationData {
            selectedLocation = KLDocument(
                placeName: locationName,
                addressName: locationAddress,
                roadAddressName: "",
                x: String(longitude),
                y: String(latitude),
                distance: "0"
            )
            
            // 초기 데이터를 백업으로 저장
            backupLocationData()
        }
        
        print("위치 정보 설정 완료")
        print("  - 위치명: \(locationName)")
        print("  - 위치 주소: \(locationAddress)")
        print("  - 좌표: (\(longitude), \(latitude))")
        
        // 이벤트 카테고리
        if let eventItem = eventItems.first(where: { $0.title == eventManager.eventCategory }) {
            selectedEvent = eventItem
        }
    }

    // MARK: - 백업 관련 함수들
    private func backupLocationData() {
        originalSelectedLocation = selectedLocation
        originalLocationName = locationName
        originalLocationAddress = locationAddress
        originalLongitude = longitude
        originalLatitude = latitude
        
        print("위치 데이터 백업됨: \(originalLocationName)")
    }
    
    private func clearCurrentLocationData() {
        selectedLocation = nil
        locationName = ""
        locationAddress = ""
        longitude = 0.0
        latitude = 0.0
        
        print("현재 위치 데이터 클리어됨")
    }

    private func restoreLocationData() {
        selectedLocation = originalSelectedLocation
        locationName = originalLocationName
        locationAddress = originalLocationAddress
        longitude = originalLongitude
        latitude = originalLatitude
        
        print("위치 데이터 복원됨: \(locationName)")
        
        // 지도 위치 업데이트
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            updateMapLocation()
        }
    }

    // MARK: - 날짜 포맷 변환
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
    
    private func formatDateForAPI(_ uiDateString: String) -> String {
        print("입력된 날짜: \(uiDateString)")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        // 1. "yyyy년 M월 d일" 형식 시도
        let koreanFormatter = DateFormatter()
        koreanFormatter.dateFormat = "yyyy년 M월 d일"
        koreanFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = koreanFormatter.date(from: uiDateString) {
            return outputFormatter.string(from: date)
        }
        
        // 2. "yyyy.MM.dd" 형식 시도 (DatePicker에서 오는 형식)
        let dotFormatter = DateFormatter()
        dotFormatter.dateFormat = "yyyy.MM.dd"
        
        if let date = dotFormatter.date(from: uiDateString) {
            let result = outputFormatter.string(from: date)
            print("변환 결과: \(result)")
            return result
        }
        
        // 변환 실패시 원본 반환
        return uiDateString
    }
    
    // MARK: - 이벤트 처리
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
        }
    }
    
    private func submitGeneralUpdate() {
        guard isFormValid else {
            submitError = "모든 필수 정보를 입력해주세요."
            return
        }
        
        isSubmitting = true
        submitError = nil
        
        Task {
            do {
                let eventData = createEventData()
                
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
                        print("경조사 수정 성공!")
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
    
    private func submitModifiedRecommendation() {
        guard isFormValid else {
            submitError = "모든 필수 정보를 입력해주세요."
            return
        }
        
        print("수정된 추천 데이터로 이벤트 생성 시작...")
        
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
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
