//
//  RecommendLottie.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI

struct RecommendLottie: View {
    @StateObject private var lottieviewModel = RecommendCostViewModel()
    @State private var showRectangle = false
    @State private var progressWidth: CGFloat = 5
    @State private var recommendedAmount: Int = 100000
    @State private var minAmount: Int = 80000
    @State private var maxAmount: Int = 120000
    @State private var category: String = "경조사"
    @State private var eventLocation: String = "없음"
    @State private var eventCategory: String = "해당없음"
    @State private var progressScale: CGFloat = 0
    
    @State private var isSubmitting = false

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager

    var body: some View {
        VStack(spacing: 30) {

            if !showRectangle {
                LottieView(
                    animationFileName: "envelope",
                    loopMode: .playOnce,
                    completion: { finished in
                        if finished {
                            showRectangle = true
                        }
                    }
                )
                .offset(y: -20)

                VStack(spacing: 24) {
                    VStack(spacing: 40) {
                        amountRangeSection
                        categorySection
                    }
                    .padding(.horizontal, 20)
                }
                .offset(y: -40)
                .padding(.bottom, 40)
            }

            if showRectangle {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("추천 금액")
                            .titleSemiBold18()
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 16)
                    .background(Color.gray900)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            headerSection
                            
                            VStack(spacing: 40) {
                                amountLottieSection
                                categorySection
                            }
                            .padding(.horizontal, 20)
                            
                            noticeSection
                                .padding(.horizontal, 20)
                            
                            participationSection
                                .padding(.horizontal, 20)
                                .padding(.top, -10)
                            
                            bottomButtons
                                .padding(.top, 60)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }

        }
        .onAppear {
            if let data = eventManager.recommendationResponse?.data {
                print("추천 데이터 확인:")
                print("추천 금액: \(data.cost)원")
                print("범위: \(data.range.min)원 ~ \(data.range.max)원")
                print("카테고리: \(data.category)")
                print("장소: \(data.location)")
                
                recommendedAmount = data.cost
                minAmount = data.range.min
                maxAmount = data.range.max
                category = data.category
                eventLocation = data.location
                eventCategory = data.category
                
                lottieviewModel.updateFromServerData(
                    recommended: data.cost,
                    min: data.range.min,
                    max: data.range.max
                )

            } else {
                print("추천 데이터 없음")
            }
            print("RecommendLottie 나타남 - path.count: \(router.path.count)")
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
    }

    var headerSection: some View {
        VStack {
            VStack(spacing: 20) {
                Text(eventCategory)
                    .bodyMedium14()
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.primaryNormal, lineWidth: 1)
                            .background(.gray750)
                    )

                VStack(spacing: 0) {
                    Text("추천 금액")
                        .captionRegular12()
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.primaryNormal)
                        )

                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(recommendedAmount)")
                            .font(.system(size: 46, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#4E62FF"),
                                        Color(hex: "#502EFF"),
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("원")
                            .titleSemiBold22()
                            .foregroundColor(.gray600)
                            .padding(.bottom, 8)
                    }
                    .padding(.top, 6)

                    VStack(spacing: 6) {
                        Text("적절한 금액이에요!")
                            .bodyMedium16()
                            .foregroundColor(.white)

                        Text("알려주신 정보를 고려한 추천입니다")
                            .bodyRegular14()
                            .foregroundColor(.gray200)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray750.opacity(0.6))
                    )
                    .padding(.top, 20)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#A6BEF3"),
                                    Color(hex: "#D3D9FF"),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20) // 고정 헤더와의 간격
            .transition(.opacity.combined(with: .scale))
        }
    }
    
    var amountLottieSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("적정 범위")
                .titleSemiBold18()
                .foregroundColor(.white)

            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(hex: "#292929"))
                            .frame(height: 12)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#502EFF"),
                                        Color(hex: "#807FFF"),
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progressScale, height: 12)
                            .animation(.easeInOut(duration: 1.5), value: progressScale)
                    }
                }
                .frame(height: 12)

                HStack {
                    Text("\(minAmount)원")
                        .captionRegular12()
                        .foregroundColor(.gray400)

                    Spacer()

                    Text("\(maxAmount)원")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
        )
    }
    
    var amountRangeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("적정 범위")
                .titleSemiBold18()
                .foregroundColor(.white)

            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(hex: "#292929"))
                            .frame(height: 12)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#502EFF"),
                                        Color(hex: "#807FFF"),
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progressScale, height: 12)
                            .animation(.easeInOut(duration: 1.5), value: progressScale)
                    }
                }
                .frame(height: 12)

                HStack {
                    Text("\(minAmount)원")
                        .captionRegular12()
                        .foregroundColor(.gray400)

                    Spacer()

                    Text("\(maxAmount)원")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let progress = Double(recommendedAmount - minAmount) / Double(maxAmount - minAmount)
                progressScale = progress
            }
        }
    }

    var noticeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("icon_info")
                Text("이렇게 계산했어요")
                    .titleSemiBold18()
                    .foregroundColor(.white)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("• 월 수입 고려")
                    .bodyRegular16()
                    .foregroundColor(.gray400)
                Text("• 식사 참석 여부")
                    .bodyRegular16()
                    .foregroundColor(.gray400)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("gray750"))
        )
    }

    var participationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("icon_colorcheck")
                Text("참고해주세요!")
                    .titleSemiBold18()
                    .foregroundColor(.white)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("• 홀수 금액으로 준비해주세요")
                    .bodyRegular16()
                    .foregroundColor(.gray400)
                Text("• 새 지폐로 준비하는게 좋아요")
                    .bodyRegular16()
                    .foregroundColor(.gray400)
                Text("• 봉투에 정성스럽게 마음을 표현해보세요")
                    .bodyRegular16()
                    .foregroundColor(.gray400)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("gray750"))
        )
    }

    var bottomButtons: some View {
        VStack(spacing: 12) {
            Button {
                guard !isSubmitting else { return }
                isSubmitting = true
                
                Task {
                    let success = await eventManager.submitEventWithRecommendedAmount()
                    
                    if success {
                        await MainActor.run {
                            router.push(to: .recommendSuccessView)
                        }
                    } else {
                        print("이벤트 생성 실패: \(eventManager.submitError ?? "알 수 없는 오류")")
                    }
                    
                    await MainActor.run {
                                isSubmitting = false
                            }
                }
            } label: {
                Text("이 금액으로 결정하기")
                    .font(.title_semibold_18)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .background(Color("primary_normal"))
            .cornerRadius(10)
            .disabled(isSubmitting)

            Button {
                router.push(to: .modifyEventView(
                    mode: .edit, eventDetailData: nil
                ))
            } label: {
                Text("추천받은 금액 수정하기")
                    .font(.title_semibold_18)
                    .foregroundColor(.gray200)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .background(Color("gray700"))
            .cornerRadius(10)
        }
        .padding(.horizontal, 20)
    }

    var categorySection: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(.gray900)
                        .frame(width: 40, height: 40)
                    Image("icon_star")
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("경조사 종류")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                    Text(eventCategory)
                        .bodyMedium16()
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("gray750"))
            )

            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(.gray900)
                        .frame(width: 40, height: 40)
                    Image("icon_location 2")
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("장소")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                    Text(eventLocation)
                        .bodyMedium16()
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .frame(height: 70)

            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("gray750"))
            )
        }
        .frame(maxWidth: .infinity)
    }
}
