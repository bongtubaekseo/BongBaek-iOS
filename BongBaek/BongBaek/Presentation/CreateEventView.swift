//
//  CreateEventView.swift
//  BongBaek
//
//  Created by 임재현 on 7/17/25.
//

import SwiftUI

struct CreateEventView: View {
    @EnvironmentObject var router: NavigationRouter
    @State private var mapView: KakaoMapView?
    @State private var selectedLocation: KLDocument? // 기존 변수 활용
    
    // 단순한 State 변수들
    @State private var nickname: String = ""
    @State private var alias: String = ""
    @State private var money: String = ""
    @State private var memo: String = ""
    @State private var selectedAttend: TextDropdownItem?
    @State private var selectedEvent: TextDropdownItem?
    @State private var selectedRelation: TextDropdownItem?
    @State private var showDatePicker = false
    @State private var selectedDate: String = ""
    @State private var showLargeMapView = false // Sheet 제어용
    
    // API 상태
    @State private var isSubmitting = false
    @State private var submitError: String?
    
    @Environment(\.dismiss) private var dismiss
   
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
                    
                    Text("경조사 기록하기")
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
                            placeholder: "이름을 입력하세요",
                            text: $nickname,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10,
                                regex: "^[가-힣a-zA-Z0-9\\s]+$",
                                customMessage: "한글, 영문, 숫자, 공백만 입력 가능합니다"
                            ),
                            isRequired: true
                        )
                        
                        CustomTextField(
                            title: "별명",
                            icon: "icon_event_16",
                            placeholder: "별명을 입력하세요",
                            text: $alias,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10,
                                regex: "^[가-힣a-zA-Z0-9\\s]+$",
                                customMessage: "한글, 영문, 숫자, 공백만 입력 가능합니다"
                            ),
                            isRequired: true
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
                            placeholder: "참석여부를 선택하세요",
                            items: attendItems,
                            selectedItem: $selectedAttend
                        )
                        .padding(.top, 16)
                        .onChange(of: selectedAttend) { _, newValue in
                            // 미참석으로 변경되면 선택된 위치 초기화
                            if newValue?.title == "미참석" {
                                selectedLocation = nil
                            }
                        }
                        
                        CustomTextField(
                            title: "날짜",
                            icon: "icon_calendar_16",
                            placeholder: "날짜를 선택하세요",
                            text: $selectedDate,
                            isReadOnly: true,
                            isRequired: true
                        ) {
                            print("날짜 필드 터치됨")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showDatePicker = true
                            }
                        }
                        .padding(.top, 16)
                        
                        // 행사장 섹션
                        locationSection
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
                    .padding(.horizontal,20)
                
                Button {
                    createEvent()
                } label: {
                    if isSubmitting {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("기록 중...")
                                .titleSemiBold18()
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("기록하기")
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
        }
        .background(.gray900)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showDatePicker) {
            
            DatePickerBottomSheetView.unlimited { selectedDateString in
                selectedDate = selectedDateString
                print("선택된 날짜: \(selectedDateString)")
            }
            .presentationDetents([.height(359)])
        }
        .fullScreenCover(isPresented: $showLargeMapView) {
            LargeMapView(selectedLocation: $selectedLocation)
        }
    }
    

    // 행사장 위치 섹션 수정
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                    Text(selectedLocation != nil ? "위치 변경" : "추가하기")
                        .bodyRegular14()
                        .foregroundStyle(isAttending ? .gray300 : .gray600) // 참석시에만 활성화
                }
                .disabled(!isAttending) // 참석시에만 클릭 가능
            }
            
            // 참석할 때만 지도 섹션 표시
            if isAttending, let location = selectedLocation {
                VStack(spacing: 12) {
                    
                    mapSection
                    // 선택된 위치 정보 표시
                    VStack(alignment: .leading, spacing: 4) {
                        Text(location.placeName)
                            .bodyMedium16()
                            .foregroundColor(.white)
                        
                        Text(location.addressName)
                            .bodyRegular14()
                            .foregroundColor(.gray300)
                        
                        if !location.roadAddressName.isEmpty {
                            Text(location.roadAddressName)
                                .captionRegular12()
                                .foregroundColor(.gray400)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.gray750)
                    .cornerRadius(8)
                    
                    // 지도 표시
               
                }
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.3), value: selectedLocation != nil)
            }
        }
    }

    // 참석 여부 확인하는 computed property 추가
    private var isAttending: Bool {
        selectedAttend?.title == "참석"
    }
    
    private var mapSection: some View {
        Group {
            if let mapView = mapView {
                mapView
                    .frame(height: 200)
                    .cornerRadius(12)
                    .onAppear {
                        updateMapLocation()
                    }
                    .onChange(of: selectedLocation) { _, _ in
                        updateMapLocation()
                    }
            } else {
                Rectangle()
                    .foregroundStyle(.gray700)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .onAppear {
                        mapView = KakaoMapView(draw: .constant(true))
                        // 지도 생성 후 위치 업데이트
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            updateMapLocation()
                        }
                    }
            }
        }
    }
    
    private var dropdownSection: some View {
        VStack(spacing: 24) {
            CustomDropdown(
                title: "관계",
                icon: "icon_relation",
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
    
    // 지도 위치 업데이트
    private func updateMapLocation() {
        guard let location = selectedLocation,
              let longitude = Double(location.x),
              let latitude = Double(location.y) else { return }
        
        mapView?.updateLocation(longitude: longitude, latitude: latitude)
        print("✅ 지도 위치 업데이트: \(location.placeName)")
        print("📍 좌표: \(longitude), \(latitude)")
    }
    
    // 폼 유효성 검사
    private var isFormValid: Bool {
        !nickname.isEmpty &&
        !alias.isEmpty &&
        !money.isEmpty &&
        selectedAttend != nil &&
        selectedEvent != nil &&
        selectedRelation != nil &&
        !selectedDate.isEmpty
    }
    
    // 새 이벤트 생성
    private func createEvent() {
        guard isFormValid else {
            submitError = "모든 필수 정보를 입력해주세요."
            return
        }
        
        isSubmitting = true
        submitError = nil
        
        Task {
            do {
                let eventData = createEventData()
                
                print("전송할 메모: '\(memo)'")
                print("API 데이터의 note: '\(String(describing: eventData.eventInfo.note))'")
                let response = try await DIContainer.shared.eventService.createEvent(eventData: eventData).async()
                
                if response.isSuccess {
                    await MainActor.run {
                        print("경조사 기록 성공!")
                        router.popToRoot() // 홈으로 이동
                    }
                } else {
                    await MainActor.run {
                        submitError = response.message
                        isSubmitting = false
                    }
                }
            } catch {
                await MainActor.run {
                    submitError = "기록 생성에 실패했습니다: \(error.localizedDescription)"
                    isSubmitting = false
                }
            }
        }
    }
    
    // API 요청 데이터 생성
    private func createEventData() -> CreateEventData {
        // 날짜 변환 (UI 형식 → API 형식)
        let apiDateString = formatDateForAPI(selectedDate)
        
        let hostInfo = HostInfo(
            hostName: nickname,
            hostNickname: alias
        )
        
        let eventInfo = CreateEventInfo(
            eventCategory: selectedEvent?.title ?? "",
            relationship: selectedRelation?.title ?? "",
            cost: Int(money) ?? 0,
            isAttend: selectedAttend?.title == "참석",
            eventDate: apiDateString,
            note: memo
        )
        
        // 위치 정보 설정
        let locationInfo: LocationDetailInfo
        if let location = selectedLocation {
            locationInfo = LocationDetailInfo(
                location: location.placeName,
                address: location.addressName,
                latitude: Double(location.y) ?? 0.0,
                longitude: Double(location.x) ?? 0.0
            )
        } else {
            locationInfo = LocationDetailInfo(
                location: "미정",
                address: "미정",
                latitude: 0.0,
                longitude: 0.0
            )
        }
        
        let highAccuracy = HighAccuracyInfo(
            contactFrequency: 3, // 기본값
            meetFrequency: 3     // 기본값
        )
        
        return CreateEventData(
            hostInfo: hostInfo,
            eventInfo: eventInfo,
            locationInfo: locationInfo,
            highAccuracy: highAccuracy
        )
    }
    
    // 날짜 포맷 변환 (UI → API)
    private func formatDateForAPI(_ uiDateString: String) -> String {
        print("날짜 변환 시도: \(uiDateString)")
        
        // "2025년 7월 17일" → "2025-07-17"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy년 M월 d일"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: uiDateString) {
            let result = outputFormatter.string(from: date)
            print("날짜 변환 성공: \(uiDateString) → \(result)")
            return result
        } else {
            // 변환 실패 시 다른 형식으로 시도
            print("첫 번째 변환 실패, 다른 형식 시도...")
            
            // "2025.07.17" 형식 처리
            if uiDateString.contains(".") {
                let result = uiDateString.replacingOccurrences(of: ".", with: "-")
                print("형식 변환: \(uiDateString) → \(result)")
                return result
            }
            
            print("모든 변환 실패, 원본 반환: \(uiDateString)")
            return uiDateString
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct CreateEventViewAfterEvent: View {
    @EnvironmentObject var router: NavigationRouter
    @State private var mapView: KakaoMapView?
    @State private var selectedLocation: KLDocument? // 기존 변수 활용
    
    // 단순한 State 변수들
    @State private var nickname: String = ""
    @State private var alias: String = ""
    @State private var money: String = ""
    @State private var memo: String = ""
    @State private var selectedAttend: TextDropdownItem?
    @State private var selectedEvent: TextDropdownItem?
    @State private var selectedRelation: TextDropdownItem?
    @State private var showDatePicker = false
    @State private var selectedDate: String = ""
    @State private var showLargeMapView = false // Sheet 제어용
    
    // API 상태
    @State private var isSubmitting = false
    @State private var submitError: String?
    
    @Environment(\.dismiss) private var dismiss
   
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
                    
                    Text("경조사 기록하기")
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
                            placeholder: "이름을 입력하세요",
                            text: $nickname,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10,
                                regex: "^[가-힣a-zA-Z0-9\\s]+$",
                                customMessage: "한글, 영문, 숫자, 공백만 입력 가능합니다"
                            ),
                            isRequired: true
                        )
                        
                        CustomTextField(
                            title: "별명",
                            icon: "icon_event_16",
                            placeholder: "별명을 입력하세요",
                            text: $alias,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10,
                                regex: "^[가-힣a-zA-Z0-9\\s]+$",
                                customMessage: "한글, 영문, 숫자, 공백만 입력 가능합니다"
                            ),
                            isRequired: true
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
                            placeholder: "참석여부를 선택하세요",
                            items: attendItems,
                            selectedItem: $selectedAttend
                        )
                        .padding(.top, 16)
                        .onChange(of: selectedAttend) { _, newValue in
                            // 미참석으로 변경되면 선택된 위치 초기화
                            if newValue?.title == "미참석" {
                                selectedLocation = nil
                            }
                        }
                        
                        CustomTextField(
                            title: "날짜",
                            icon: "icon_calendar_16",
                            placeholder: "날짜를 선택하세요",
                            text: $selectedDate,
                            isReadOnly: true,
                            isRequired: true
                        ) {
                            print("날짜 필드 터치됨")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showDatePicker = true
                            }
                        }
                        .padding(.top, 16)
                        
                        // 행사장 섹션
                        locationSection
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
                    .padding(.horizontal,20)
                
                Button {
                    createEvent()
                } label: {
                    if isSubmitting {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("기록 중...")
                                .titleSemiBold18()
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("기록하기")
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
        }
        .background(.gray900)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showDatePicker) {
            DatePickerBottomSheetView.unlimited { selectedDateString in
                selectedDate = selectedDateString
                print("선택된 날짜: \(selectedDateString)")
            }
            .presentationDetents([.height(359)])
        }
        .fullScreenCover(isPresented: $showLargeMapView) {
            LargeMapView(selectedLocation: $selectedLocation)
        }
    }
    

    // 행사장 위치 섹션 수정
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                    Text(selectedLocation != nil ? "위치 변경" : "추가하기")
                        .bodyRegular14()
                        .foregroundStyle(isAttending ? .gray300 : .gray600) // 참석시에만 활성화
                }
                .disabled(!isAttending) // 참석시에만 클릭 가능
            }
            
            // 참석할 때만 지도 섹션 표시
            if isAttending, let location = selectedLocation {
                VStack(spacing: 12) {
                    
                    mapSection
                    // 선택된 위치 정보 표시
                    VStack(alignment: .leading, spacing: 4) {
                        Text(location.placeName)
                            .bodyMedium16()
                            .foregroundColor(.white)
                        
                        Text(location.addressName)
                            .bodyRegular14()
                            .foregroundColor(.gray300)
                        
                        if !location.roadAddressName.isEmpty {
                            Text(location.roadAddressName)
                                .captionRegular12()
                                .foregroundColor(.gray400)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.gray750)
                    .cornerRadius(8)
                    
                    // 지도 표시
               
                }
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.3), value: selectedLocation != nil)
            }
        }
    }

    // 참석 여부 확인하는 computed property 추가
    private var isAttending: Bool {
        selectedAttend?.title == "참석"
    }
    
    private var mapSection: some View {
        Group {
            if let mapView = mapView {
                mapView
                    .frame(height: 200)
                    .cornerRadius(12)
                    .onAppear {
                        updateMapLocation()
                    }
                    .onChange(of: selectedLocation) { _, _ in
                        updateMapLocation()
                    }
            } else {
                Rectangle()
                    .foregroundStyle(.gray700)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .onAppear {
                        mapView = KakaoMapView(draw: .constant(true))
                        // 지도 생성 후 위치 업데이트
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            updateMapLocation()
                        }
                    }
            }
        }
    }
    
    private var dropdownSection: some View {
        VStack(spacing: 24) {
            CustomDropdown(
                title: "관계",
                icon: "icon_relation",
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
    
    // 지도 위치 업데이트
    private func updateMapLocation() {
        guard let location = selectedLocation,
              let longitude = Double(location.x),
              let latitude = Double(location.y) else { return }
        
        mapView?.updateLocation(longitude: longitude, latitude: latitude)
        print("지도 위치 업데이트: \(location.placeName)")
        print("좌표: \(longitude), \(latitude)")
    }
    
    // 폼 유효성 검사
    private var isFormValid: Bool {
        !nickname.isEmpty &&
        !alias.isEmpty &&
        !money.isEmpty &&
        selectedAttend != nil &&
        selectedEvent != nil &&
        selectedRelation != nil &&
        !selectedDate.isEmpty
    }
    
    // 새 이벤트 생성
    private func createEvent() {
        guard isFormValid else {
            submitError = "모든 필수 정보를 입력해주세요."
            return
        }
        
        isSubmitting = true
        submitError = nil
        
        Task {
            do {
                let eventData = createEventData()
                
                print("전송할 메모: '\(memo)'")
                print("API 데이터의 note: '\(String(describing: eventData.eventInfo.note))'")
                let response = try await DIContainer.shared.eventService.createEvent(eventData: eventData).async()
                
                if response.isSuccess {
                    await MainActor.run {
                        print("경조사 기록 성공!")
                        router.popToRoot() // 홈으로 이동
                    }
                } else {
                    await MainActor.run {
                        submitError = response.message
                        isSubmitting = false
                    }
                }
            } catch {
                await MainActor.run {
                    submitError = "기록 생성에 실패했습니다: \(error.localizedDescription)"
                    isSubmitting = false
                }
            }
        }
    }
    
    // API 요청 데이터 생성
    private func createEventData() -> CreateEventData {
        // 날짜 변환 (UI 형식 → API 형식)
        let apiDateString = formatDateForAPI(selectedDate)
        
        let hostInfo = HostInfo(
            hostName: nickname,
            hostNickname: alias
        )
        
        let eventInfo = CreateEventInfo(
            eventCategory: selectedEvent?.title ?? "",
            relationship: selectedRelation?.title ?? "",
            cost: Int(money) ?? 0,
            isAttend: selectedAttend?.title == "참석",
            eventDate: apiDateString,
            note: memo
        )
        
        // 위치 정보 설정
        let locationInfo: LocationDetailInfo
        if let location = selectedLocation {
            locationInfo = LocationDetailInfo(
                location: location.placeName,
                address: location.addressName,
                latitude: Double(location.y) ?? 0.0,
                longitude: Double(location.x) ?? 0.0
            )
        } else {
            locationInfo = LocationDetailInfo(
                location: "미정",
                address: "미정",
                latitude: 0.0,
                longitude: 0.0
            )
        }
        
        let highAccuracy = HighAccuracyInfo(
            contactFrequency: 3, // 기본값
            meetFrequency: 3     // 기본값
        )
        
        return CreateEventData(
            hostInfo: hostInfo,
            eventInfo: eventInfo,
            locationInfo: locationInfo,
            highAccuracy: highAccuracy
        )
    }
    
    // 날짜 포맷 변환 (UI → API)
    private func formatDateForAPI(_ uiDateString: String) -> String {
        print("날짜 변환 시도: \(uiDateString)")
        
        // "2025년 7월 17일" → "2025-07-17"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy년 M월 d일"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: uiDateString) {
            let result = outputFormatter.string(from: date)
            print("날짜 변환 성공: \(uiDateString) → \(result)")
            return result
        } else {
            // 변환 실패 시 다른 형식으로 시도
            print("첫 번째 변환 실패, 다른 형식 시도")
            
            // "2025.07.17" 형식 처리
            if uiDateString.contains(".") {
                let result = uiDateString.replacingOccurrences(of: ".", with: "-")
                print("형식 변환: \(uiDateString) → \(result)")
                return result
            }
            
            print("모든 변환 실패, 원본 반환: \(uiDateString)")
            return uiDateString
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
