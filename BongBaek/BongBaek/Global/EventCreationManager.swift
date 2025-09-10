//
//  EventCreationManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/15/25.
//

import Foundation
import Combine

@MainActor
class EventCreationManager: ObservableObject {
    
    // MARK: - Published Properties (각 화면별 바인딩용)
    
    // Step 1: RecommendView 데이터
    @Published var hostName: String = ""
    @Published var hostNickname: String = ""
    @Published var relationship: String = ""
    @Published var detailSelected: Bool = false
    @Published var contactFrequency: Double = 2.0
    @Published var meetFrequency: Double = 2.0
    @Published var isHostNameValid: Bool = false
    @Published var isHostNicknameValid: Bool = false
    
    // Step 2: EventInformationView 데이터
    @Published var eventCategory: String = ""
    @Published var selectedEventType: String = ""
    
    // Step 3: EventDateView 데이터
    @Published var eventDate: Date = Date()
    @Published var isAttend: Bool = true
    @Published var selectedAttendance: AttendanceType? = nil
    
    // Step 4: EventLocationView 데이터 (선택적)
    @Published var hasLocationData: Bool = false
    @Published var selectedLocation: KLDocument?
    @Published var locationName: String = ""
    @Published var locationAddress: String = ""
    @Published var locationRoadAddress: String = ""
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    // MARK: - API 관련 상태
    @Published var isSubmitting: Bool = false
    @Published var submitError: String?
    @Published var submitSuccess: Bool = false
    @Published var apiResponse: CreateEventResponse?
    
    // MARK: - 추천 금액 관련 상태
    @Published var recommendationResponse: AmountRecommendationResponse?
    @Published var isLoadingRecommendation: Bool = false
    @Published var recommendationError: String?
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
       
       init() {
           self.eventService = DIContainer.shared.eventService
       }
       
    
    
    // MARK: - Computed Properties (검증용)
    
    /// Step 1 검증: RecommendView 완료 가능 여부
    var canCompleteRecommendStep: Bool {
        let nameValid = hostName.count >= 2 && hostName.count <= 10
        let nicknameValid = hostNickname.isEmpty || (hostNickname.count >= 2 && hostNickname.count <= 10)
        let relationshipValid = !relationship.isEmpty
        return nameValid && nicknameValid && relationshipValid
    }
    
    /// Step 2 검증: EventInformationView 완료 가능 여부
    var canCompleteEventInfoStep: Bool {
        return !eventCategory.isEmpty && !selectedEventType.isEmpty
    }
    
    /// Step 3 검증: EventDateView 완료 가능 여부
    var canCompleteDateStep: Bool {
        return selectedAttendance != nil
    }
    
    /// Step 4 검증: EventLocationView 완료 가능 여부 (참석하는 경우만)
    var canCompleteLocationStep: Bool {
        // 불참이면 장소 정보 없어도 OK
        if selectedAttendance == .no {
            return true
        }
        
        // 참석이어도 위치 정보는 선택적 (건너뛰기 가능)
        return true  // 항상 true 반환하도록 변경
    }
    
    var hasRequiredLocationData: Bool {
        if selectedAttendance == .no {
            return true  // 불참이면 위치 정보 불필요
        }
        return hasLocationData && !locationName.isEmpty
    }
    
    /// 전체 폼 완성 여부
    var isFormComplete: Bool {
        return canCompleteRecommendStep &&
               canCompleteEventInfoStep &&
               canCompleteDateStep &&
               canCompleteLocationStep
    }
    
    // MARK: - Public Methods
    
    /// RecommendView 데이터 업데이트
    func updateRecommendData(
        hostName: String,
        hostNickname: String,
        relationship: String,
        detailSelected: Bool,
        contactFrequency: Double = 3.0,
        meetFrequency: Double = 3.0
    ) {
        self.hostName = hostName
        self.hostNickname = hostNickname
        self.relationship = relationship
        self.detailSelected = detailSelected
        self.contactFrequency = contactFrequency
        self.meetFrequency = meetFrequency
        
        print("EventCreationManager: RecommendView 데이터 업데이트")
        printCurrentStatus()
    }
    
    /// EventInformationView 데이터 업데이트
    func updateEventInfoData(
        eventCategory: String,
        selectedEventType: String
    ) {
        self.eventCategory = eventCategory
        self.selectedEventType = selectedEventType
        
        print("EventCreationManager: EventInformationView 데이터 업데이트")
        printCurrentStatus()
    }
    
    /// EventDateView 데이터 업데이트
    func updateDateData(
        eventDate: Date,
        selectedAttendance: AttendanceType?
    ) {
        self.eventDate = eventDate
        self.selectedAttendance = selectedAttendance
        self.isAttend = (selectedAttendance == .yes)
        
        print("EventCreationManager: EventDateView 데이터 업데이트")
        printCurrentStatus()
    }
    
    /// EventLocationView 데이터 업데이트
    func updateLocationData(
        selectedLocation: KLDocument
    ) {
        self.selectedLocation = selectedLocation
        self.locationName = selectedLocation.placeName
        self.locationAddress = selectedLocation.addressName
        self.locationRoadAddress = selectedLocation.roadAddressName
        
        // 좌표 변환
        if let longitude = Double(selectedLocation.x),
           let latitude = Double(selectedLocation.y) {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        self.hasLocationData = true
        
        print("EventCreationManager: EventLocationView 데이터 업데이트")
        print("  - 장소: \(locationName)")
        print("  - 주소: \(locationAddress)")
        print("  - 좌표: \(longitude), \(latitude)")
        printCurrentStatus()
    }
    
    /// 위치 데이터 직접 설정 (테스트용)
    func setLocationData(
        name: String,
        address: String,
        roadAddress: String = "",
        latitude: Double,
        longitude: Double
    ) {
        self.locationName = name
        self.locationAddress = address
        self.locationRoadAddress = roadAddress
        self.latitude = latitude
        self.longitude = longitude
        self.hasLocationData = true
        
        print("EventCreationManager: 위치 데이터 직접 설정")
        printCurrentStatus()
    }
    
    /// 위치 데이터 초기화 (불참 선택 시)
    func clearLocationData() {
        self.selectedLocation = nil
        self.locationName = ""
        self.locationAddress = ""
        self.locationRoadAddress = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.hasLocationData = false
        
        print("EventCreationManager: 위치 데이터 초기화")
    }
    
    // MARK: - API 관련 메서드
    
    /// API 요청용 데이터 생성
    func createAPIRequestData() -> CreateEventData? {
        guard isFormComplete else {
            print("EventCreationManager: 폼이 완성되지 않음")
            return nil
        }
        
        // HostInfo 생성
        let hostInfo = HostInfo(
            hostName: hostName,
            hostNickname: hostNickname.isEmpty ? hostName : hostNickname
        )
        
        // CreateEventInfo 생성
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let eventDateString = formatter.string(from: eventDate)
        
        let eventInfo = CreateEventInfo(
            eventCategory: eventCategory,
            relationship: relationship,
            cost: 0, // 서버에서 계산
            isAttend: isAttend,
            eventDate: eventDateString,
            note: ""
        )
        
        // LocationDetailInfo 생성
        let locationInfo = LocationDetailInfo(
            location: hasLocationData ? locationName : "미정",
            address: hasLocationData ? locationAddress : "미정",
            latitude: latitude,
            longitude: longitude
        )
        
        // HighAccuracyInfo 생성
        let highAccuracy = HighAccuracyInfo(
            contactFrequency: detailSelected ? Int(contactFrequency) : 3,
            meetFrequency: detailSelected ? Int(meetFrequency) : 3
        )
        
        let requestData = CreateEventData(
            hostInfo: hostInfo,
            eventInfo: eventInfo,
            locationInfo: locationInfo,
            highAccuracy: highAccuracy
        )
        
        print("EventCreationManager: API 요청 데이터 생성 완료")
        return requestData
    }
    
    /// 금액 추천 API 호출
    func getAmountRecommendation() async {
        guard let requestData = createRecommendationRequestData() else {
            recommendationError = "입력 정보가 완전하지 않습니다."
            return
        }
        
        isLoadingRecommendation = true
        recommendationError = nil
        
        do {
            let response = try await eventService.getAmountRecommendation(request: requestData)
                .async()
            
            if response.isSuccess, let data = response.data {
                recommendationResponse = response
                print("금액 추천 성공: \(data.cost)원")
            } else {
                recommendationError = response.message
                print("금액 추천 실패: \(response.message)")
            }
            
        } catch {
            recommendationError = "금액 추천 요청에 실패했습니다: \(error.localizedDescription)"
            print("금액 추천 에러: \(error)")
        }
        
        isLoadingRecommendation = false
    }
    
    /// 금액 추천 요청 데이터 생성
      private func createRecommendationRequestData() -> AmountRecommendationRequest? {
          guard canCompleteRecommendStep && canCompleteEventInfoStep && canCompleteDateStep else {
              print("금액 추천: 필수 정보가 부족함")
              return nil
          }
          
          // 위치 정보 생성
          let locationInfo = RecommendationLocationInfo(
              location: hasLocationData ? locationName : "미정"
          )
          
          // 상세 정보 생성
          let highAccuracy = HighAccuracyInfo(
              contactFrequency: detailSelected ? Int(contactFrequency) : 3,
              meetFrequency: detailSelected ? Int(meetFrequency) : 3
          )
          
          // 참석 여부 결정
          let isAttended = selectedAttendance == .yes
          
          let request = AmountRecommendationRequest(
              category: eventCategory,
              relationship: relationship,
              attended: isAttended,
              locationInfo: locationInfo,
              highAccuracy: highAccuracy
          )
          
          print("금액 추천 요청 데이터 생성 완료")
          print("  - 카테고리: \(eventCategory)")
          print("  - 관계: \(relationship)")
          print("  - 참석: \(isAttended)")
          print("  - 장소: \(locationInfo.location)")
          print("  - 연락빈도: \(highAccuracy.contactFrequency), 만남빈도: \(highAccuracy.meetFrequency)")
          
          return request
      }
    
    /// 이벤트 생성 API 호출
    func submitEvent() async {
        guard let requestData = createAPIRequestData() else {
            submitError = "입력 정보가 완전하지 않습니다."
            return
        }
        
        isSubmitting = true
        submitError = nil
        
        do {
            let response = try await eventService.createEvent(eventData: requestData)
                .async()
            
            if response.isSuccess {
                apiResponse = response
                submitSuccess = true
                print("이벤트 생성 성공!")
                logAPIRequestData(requestData)
            } else {
                submitError = response.message
                print("이벤트 생성 실패: \(response.message)")
            }
            
        } catch {
            submitError = "이벤트 생성에 실패했습니다: \(error.localizedDescription)"
            print("이벤트 생성 에러: \(error)")
        }
        
        isSubmitting = false
    }
    
    // MARK: - 데이터 관리 메서드
    
    /// 모든 데이터 초기화
    func resetAllData() {
        // Step 1 데이터 초기화
        hostName = ""
        hostNickname = ""
        relationship = ""
        detailSelected = false
        contactFrequency = 3.0
        meetFrequency = 3.0
        
        // Step 2 데이터 초기화
        eventCategory = ""
        selectedEventType = ""
        
        // Step 3 데이터 초기화
        eventDate = Date()
        isAttend = true
        selectedAttendance = nil
        
        // Step 4 데이터 초기화
        clearLocationData()
        
        // API 상태 초기화
        isSubmitting = false
        submitError = nil
        submitSuccess = false
        apiResponse = nil
        
        print("EventCreationManager: 모든 데이터 초기화 완료")
    }
    
    /// 특정 단계 데이터만 초기화
    func resetStepData(_ step: Int) {
        switch step {
        case 1:
            hostName = ""
            hostNickname = ""
            relationship = ""
            detailSelected = false
            contactFrequency = 3
            meetFrequency = 3
            
        case 2:
            eventCategory = ""
            selectedEventType = ""
            
        case 3:
            eventDate = Date()
            isAttend = true
            selectedAttendance = nil
            
        case 4:
            clearLocationData()
            
        default:
            break
        }
        
        print("EventCreationManager: Step \(step) 데이터 초기화")
    }
    
    
    /// 현재 폼 상태 출력
    func printCurrentStatus() {
        print("EventCreationManager 현재 상태:")
        print("  - Step 1 (추천): \(canCompleteRecommendStep ? "완성" : "미완성")")
        print("  - Step 2 (이벤트): \(canCompleteEventInfoStep ? "완성" : "미완성")")
        print("  - Step 3 (날짜): \(canCompleteDateStep ? "완성" : "미완성")")
        print("  - Step 4 (위치): \(canCompleteLocationStep ? "완성" : "미완성")")
        print("  - 전체 완성: \(isFormComplete ? "완성" : "미완성")")
        print("  - 참석 여부: \(String(describing: selectedAttendance?.rawValue))")
        print("  - 위치 데이터: \(hasLocationData ? "있음" : "없음")")
    }
    
    /// API 요청 데이터 로깅
    private func logAPIRequestData(_ data: CreateEventData) {
        print("API 요청 데이터:")
        print("  - 호스트: \(data.hostInfo.hostName) (\(data.hostInfo.hostNickname))")
        print("  - 관계: \(data.eventInfo.relationship)")
        print("  - 이벤트: \(data.eventInfo.eventCategory)")
        print("  - 날짜: \(data.eventInfo.eventDate)")
        print("  - 참석: \(data.eventInfo.isAttend)")
        print("  - 장소: \(data.locationInfo.location)")
        print("  - 주소: \(data.locationInfo.address)")
        print("  - 상세정보: 연락(\(data.highAccuracy.contactFrequency)), 만남(\(data.highAccuracy.meetFrequency))")
    }
    
    /// JSON 형태로 현재 데이터 내보내기 (백업/복원용)
    func exportData() -> [String: Any] {
        return [
            "hostName": hostName,
            "hostNickname": hostNickname,
            "relationship": relationship,
            "detailSelected": detailSelected,
            "contactFrequency": contactFrequency,
            "meetFrequency": meetFrequency,
            "eventCategory": eventCategory,
            "selectedEventType": selectedEventType,
            "eventDate": eventDate.timeIntervalSince1970,
            "selectedAttendance": selectedAttendance?.rawValue ?? "selectedAttendance 없음",
            "locationName": locationName,
            "locationAddress": locationAddress,
            "latitude": latitude,
            "longitude": longitude,
            "hasLocationData": hasLocationData
        ]
    }
    
    /// JSON 데이터로부터 복원 (백업/복원용)
    func importData(from dict: [String: Any]) {
        hostName = dict["hostName"] as? String ?? ""
        hostNickname = dict["hostNickname"] as? String ?? ""
        relationship = dict["relationship"] as? String ?? ""
        detailSelected = dict["detailSelected"] as? Bool ?? false
        contactFrequency = dict["contactFrequency"] as? Double ?? 2.0
        meetFrequency = dict["meetFrequency"] as? Double ?? 2.0
        
        eventCategory = dict["eventCategory"] as? String ?? ""
        selectedEventType = dict["selectedEventType"] as? String ?? ""
        
        if let timestamp = dict["eventDate"] as? TimeInterval {
            eventDate = Date(timeIntervalSince1970: timestamp)
        }
        
        if let attendanceRaw = dict["selectedAttendance"] as? String {
            selectedAttendance = AttendanceType(rawValue: attendanceRaw)
            isAttend = (selectedAttendance == .yes)
        }
        
        locationName = dict["locationName"] as? String ?? ""
        locationAddress = dict["locationAddress"] as? String ?? ""
        latitude = dict["latitude"] as? Double ?? 0.0
        longitude = dict["longitude"] as? Double ?? 0.0
        hasLocationData = dict["hasLocationData"] as? Bool ?? false
        
        print("EventCreationManager: 데이터 복원 완료")
    }
    


    /// 추천받은 금액으로 이벤트 생성
    func submitEventWithRecommendedAmount() async -> Bool {
        // 1. 추천 응답이 있는지 확인
        guard let recommendationResponse = recommendationResponse,
              let recommendedData = recommendationResponse.data else {
            submitError = "추천 금액 정보가 없습니다."
            print("추천 응답 데이터 없음")
            return false
        }
        
        // 2. API 요청 데이터 생성 (추천받은 금액 포함)
        guard let requestData = createAPIRequestDataWithRecommendedAmount(recommendedAmount: recommendedData.cost) else {
            submitError = "이벤트 생성 데이터를 만들 수 없습니다."
            return false
        }
        
        isSubmitting = true
        submitError = nil
        
        do {
            print("추천받은 금액(\(recommendedData.cost)원)으로 이벤트 생성 시작...")
            
            let response = try await eventService.createEvent(eventData: requestData)
                .async()
            
            if response.isSuccess {
                apiResponse = response
                submitSuccess = true
                print("이벤트 생성 성공!")
                logAPIRequestData(requestData)
                isSubmitting = false
                return true
            } else {
                submitError = response.message
                print("이벤트 생성 실패: \(response.message)")
                isSubmitting = false
                return false
            }
            
        } catch {
            submitError = "이벤트 생성에 실패했습니다: \(error.localizedDescription)"
            print("이벤트 생성 에러: \(error)")
            isSubmitting = false
            return false
        }
    }

    /// 추천받은 금액을 포함한 API 요청용 데이터 생성
    private func createAPIRequestDataWithRecommendedAmount(recommendedAmount: Int) -> CreateEventData? {
        guard isFormComplete else {
            print("EventCreationManager: 폼이 완성되지 않음")
            return nil
        }
        
        // HostInfo 생성
        let hostInfo = HostInfo(
            hostName: hostName,
            hostNickname: hostNickname.isEmpty ? hostName : hostNickname
        )
        
        // CreateEventInfo 생성 (추천받은 금액 사용)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let eventDateString = formatter.string(from: eventDate)
        
        let eventInfo = CreateEventInfo(
            eventCategory: eventCategory,
            relationship: relationship,
            cost: recommendedAmount,
            isAttend: isAttend,
            eventDate: eventDateString,
            note: ""
        )
        
        // LocationDetailInfo 생성
        let locationInfo = LocationDetailInfo(
            location: hasLocationData ? locationName : "미정",
            address: hasLocationData ? locationAddress : "미정",
            latitude: latitude,
            longitude: longitude
        )
        
        // HighAccuracyInfo 생성
        let highAccuracy = HighAccuracyInfo(
            contactFrequency: detailSelected ? Int(contactFrequency) : 3,
            meetFrequency: detailSelected ? Int(meetFrequency) : 3
        )
        
        let requestData = CreateEventData(
            hostInfo: hostInfo,
            eventInfo: eventInfo,
            locationInfo: locationInfo,
            highAccuracy: highAccuracy
        )
        
        print("추천받은 금액(\(recommendedAmount)원)으로 API 요청 데이터 생성 완료")
        return requestData
    }
    
    // EventCreationManager에 추가할 메서드들

    /// 수정된 금액으로 이벤트 생성
    func submitEventWithModifiedAmount(modifiedAmount: Int) async -> Bool {
        guard isFormComplete else {
            submitError = "입력 정보가 완전하지 않습니다."
            print("폼이 완성되지 않음")
            return false
        }
        
        // API 요청 데이터 생성 (수정된 금액 사용)
        guard let requestData = createAPIRequestDataWithModifiedAmount(modifiedAmount: modifiedAmount) else {
            submitError = "이벤트 생성 데이터를 만들 수 없습니다."
            return false
        }
        
        isSubmitting = true
        submitError = nil
        
        do {
            print("수정된 금액(\(modifiedAmount)원)으로 이벤트 생성 시작...")
            
            let response = try await eventService.createEvent(eventData: requestData)
                .async()
            
            if response.isSuccess {
                apiResponse = response
                submitSuccess = true
                print("수정된 금액으로 이벤트 생성 성공!")
                logAPIRequestData(requestData)
                isSubmitting = false
                return true
            } else {
                submitError = response.message
                print("이벤트 생성 실패: \(response.message)")
                isSubmitting = false
                return false
            }
            
        } catch {
            submitError = "이벤트 생성에 실패했습니다: \(error.localizedDescription)"
            print("이벤트 생성 에러: \(error)")
            isSubmitting = false
            return false
        }
    }

    /// 수정된 금액을 포함한 API 요청용 데이터 생성
    private func createAPIRequestDataWithModifiedAmount(modifiedAmount: Int) -> CreateEventData? {
        guard isFormComplete else {
            print("EventCreationManager: 폼이 완성되지 않음")
            return nil
        }
        
        // HostInfo 생성
        let hostInfo = HostInfo(
            hostName: hostName,
            hostNickname: hostNickname.isEmpty ? hostName : hostNickname
        )
        
        // CreateEventInfo 생성 (수정된 금액 사용)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let eventDateString = formatter.string(from: eventDate)
        
        let eventInfo = CreateEventInfo(
            eventCategory: eventCategory,
            relationship: relationship,
            cost: modifiedAmount, // 수정된 금액 사용
            isAttend: isAttend,
            eventDate: eventDateString,
            note: ""
        )
        
        // LocationDetailInfo 생성
        let locationInfo = LocationDetailInfo(
            location: hasLocationData ? locationName : "미정",
            address: hasLocationData ? locationAddress : "미정",
            latitude: latitude,
            longitude: longitude
        )
        
        // HighAccuracyInfo 생성
        let highAccuracy = HighAccuracyInfo(
            contactFrequency: detailSelected ? Int(contactFrequency) : 3,
            meetFrequency: detailSelected ? Int(meetFrequency) : 3
        )
        
        let requestData = CreateEventData(
            hostInfo: hostInfo,
            eventInfo: eventInfo,
            locationInfo: locationInfo,
            highAccuracy: highAccuracy
        )
        
        print("수정된 금액(\(modifiedAmount)원)으로 API 요청 데이터 생성 완료")
        if let originalAmount = recommendationResponse?.data?.cost {
            print(" 원래 추천 금액: \(originalAmount)원")
            print(" 수정된 금액: \(modifiedAmount)원")
            print(" 차이: \(modifiedAmount - originalAmount)원")
        }
        
        return requestData
    }
}


extension Publisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = first()
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                    }
                )
        }
    }
}
