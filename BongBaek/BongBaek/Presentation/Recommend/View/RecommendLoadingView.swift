//
//  RecommendLoadingView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI

struct RecommendLoadingView: View {
    @State private var showSuccessView = false
    @State private var username: String = "없음"
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Text("금액추천중")
                        .titleSemiBold18()
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
                
                VStack(spacing: 30) {
                    Spacer()
                    LottieTest(animationFileName: "find_amount", loopMode: .loop)
                        .frame(width: 151, height: 140)
                    
                    Text("봉백님을 위한\n금액을 찾고 있어요")
                        .titleSemiBold18()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray100)
                                    
                    Text("잠시만 기다려주세요")
                        .bodyRegular14()
                        .foregroundColor(.gray400)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                // 모든 선택된 값 출력
                printAllSelectedValues()
                
                // API 요청과 3초 대기를 동시에 시작
                Task {
                    await waitForBothCompletion()
                }
            }
        }
        .onAppear {
            print("⏳ RecommendLoadingView 나타남 - path.count: \(router.path.count)")
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Methods
    
    /// API 요청과 3초 대기를 모두 기다린 후 다음 화면으로 이동
    private func waitForBothCompletion() async {
        print("🚀 API 요청과 3초 대기 시작...")
        
        // 두 작업을 동시에 시작
        async let apiTask: () = eventManager.getAmountRecommendation()
        async let delayTask: () = Task.sleep(nanoseconds: 3_000_000_000) // 3초
        
        // 두 작업이 모두 완료될 때까지 대기
        do {
            _ = try await (apiTask, delayTask)
            print("✅ API 요청과 3초 대기 모두 완료!")
            
            // 메인 스레드에서 화면 전환
            await MainActor.run {
                router.push(to: .recommendLottie)
            }
        } catch {
            print("❌ 에러 발생: \(error)")
            // 에러가 발생해도 3초 후에는 다음 화면으로 이동
            await MainActor.run {
                router.push(to: .recommendLottie)
            }
        }
    }
    
    private func printAllSelectedValues() {
        print("🎉🎉🎉 === 최종 선택된 모든 값들 === 🎉🎉🎉")
        print("")
        
        // Step 1: 추천 정보
        print("📋 Step 1 - 추천 정보:")
        print("  🏷️  호스트 이름: '\(eventManager.hostName)'")
        print("  🏷️  호스트 별명: '\(eventManager.hostNickname.isEmpty ? "없음" : eventManager.hostNickname)'")
        print("  🤝 관계: '\(eventManager.relationship)'")
        print("  🔍 상세 추천 선택: \(eventManager.detailSelected ? "예" : "아니오")")
        
        if eventManager.detailSelected {
            print("    📞 연락 빈도: \(Int(eventManager.contactFrequency)) (0=거의안함, 4=매우자주)")
            print("    🤝 만나는 빈도: \(Int(eventManager.meetFrequency)) (0=거의안만남, 4=매우자주)")
        }
        
        username = eventManager.hostName
        print("")
        
        // Step 2: 이벤트 정보
        print("📋 Step 2 - 이벤트 정보:")
        print("  🎉 이벤트 카테고리: '\(eventManager.eventCategory)'")
        print("  📝 선택된 이벤트 타입: '\(eventManager.selectedEventType)'")
        
        print("")
        
        // Step 3: 날짜 및 참석 정보
        print("📋 Step 3 - 날짜 및 참석 정보:")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        
        print("  📅 이벤트 날짜: \(formatter.string(from: eventManager.eventDate))")
        print("  🎯 참석 여부: \(eventManager.selectedAttendance?.rawValue ?? "미선택")")
        print("  ✅ 참석 여부(Bool): \(eventManager.isAttend)")
        
        print("")
        
        // Step 4: 위치 정보 (조건부)
        print("📋 Step 4 - 위치 정보:")
        if eventManager.hasLocationData {
            print("  🏢 장소명: '\(eventManager.locationName)'")
            print("  📍 주소: '\(eventManager.locationAddress)'")
            print("  🛣️ 도로명 주소: '\(eventManager.locationRoadAddress)'")
            print("  🌍 좌표: (\(eventManager.longitude), \(eventManager.latitude))")
        } else {
            print("  ❌ 위치 정보 없음 (불참 또는 미선택)")
        }
        
        print("")
        
        // 폼 완성도 체크
        print("📊 폼 완성도 체크:")
        print("  - Step 1 완료: \(eventManager.canCompleteRecommendStep ? "✅" : "❌")")
        print("  - Step 2 완료: \(eventManager.canCompleteEventInfoStep ? "✅" : "❌")")
        print("  - Step 3 완료: \(eventManager.canCompleteDateStep ? "✅" : "❌")")
        print("  - Step 4 완료: \(eventManager.canCompleteLocationStep ? "✅" : "❌")")
        print("  - 전체 폼 완성: \(eventManager.isFormComplete ? "✅" : "❌")")
        
        print("")
        
        // API 요청 데이터 미리보기
        if let apiData = eventManager.createAPIRequestData() {
            print("📤 API 요청 데이터 미리보기:")
            print("  - 호스트명: \(apiData.hostInfo.hostName)")
            print("  - 호스트별명: \(apiData.hostInfo.hostNickname)")
            print("  - 관계: \(apiData.eventInfo.relationship)")
            print("  - 이벤트 카테고리: \(apiData.eventInfo.eventCategory)")
            print("  - 이벤트 날짜: \(apiData.eventInfo.eventDate)")
            print("  - 참석 여부: \(apiData.eventInfo.isAttend)")
            print("  - 장소: \(apiData.locationInfo.location)")
            print("  - 주소: \(apiData.locationInfo.address)")
            print("  - 연락 빈도: \(apiData.highAccuracy.contactFrequency)")
            print("  - 만남 빈도: \(apiData.highAccuracy.meetFrequency)")
        } else {
            print("❌ API 요청 데이터 생성 실패")
        }
        
        print("")
        print("🎉🎉🎉 === 선택된 값 출력 완료 === 🎉🎉🎉")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
    }
}

#Preview {
    RecommendLoadingView()
}
