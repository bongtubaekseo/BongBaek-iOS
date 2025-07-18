import SwiftUI

// MARK: - ViewModel
class RecommendationAmountViewModel: ObservableObject {
    @Published var selectedAmount: Int = 100000
    @Published var minAmount: Int = 50000
    @Published var maxAmount: Int = 200000
    @Published var customAmount: String = ""
    
    let recommendedAmounts = [100000, 150000, 200000]
    
    var sliderProgress: Double {
        Double(selectedAmount - minAmount) / Double(maxAmount - minAmount)
    }
    
    var formattedSelectedAmount: String {
        NumberFormatter.decimalFormatter.string(from: NSNumber(value: selectedAmount)) ?? "0"
    }
    
    var formattedMinAmount: String {
        NumberFormatter.decimalFormatter.string(from: NSNumber(value: minAmount)) ?? "0"
    }
    
    var formattedMaxAmount: String {
        NumberFormatter.decimalFormatter.string(from: NSNumber(value: maxAmount)) ?? "0"
    }
    
    func updateAmount(to amount: Int) {
        selectedAmount = amount
    }
    
    func updateSliderAmount(to value: Double) {
        selectedAmount = Int(value)
    }
}

// MARK: - View
struct RecommendCostView: View {
    @StateObject private var viewModel = RecommendationAmountViewModel()
    @State private var showSuccessView = false
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                //emptyRecommendationBox
                
                amountRangeSection
                
                categorySection
                
                noticeSection
                
                participationSection
                
                bottomButtons
                    .padding(.horizontal,20)
            }

            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color("gray900"))
        .foregroundColor(.white)
    }
    
    // MARK: - Header Section
    var headerSection: some View {
       VStack() {
           VStack(spacing: 20) {
               
               HStack {
                   Text("금액 추천")
                       .titleSemiBold18()
                       .foregroundColor(.white)
                       .padding(.top, 12)

                       
               }

               Text("결혼식")
                   .bodyMedium14()
                   .foregroundColor(.white)
                   .padding(.horizontal, 16)
                   .padding(.vertical, 8)
                   .background(
                       RoundedRectangle(cornerRadius: 6)
                        .stroke(.primaryNormal, lineWidth: 1)
                        .background(.gray750)
                   )

               VStack(spacing: 24) {
                   Text("추천 금액")
                       .captionRegular12()
                       .foregroundColor(.white)
                       .padding(.horizontal, 8)
                       .padding(.vertical, 2)
                       .background(
                           RoundedRectangle(cornerRadius: 4)
                            .fill(.primaryNormal)
                       )
                   
                   HStack(alignment: .bottom, spacing: 4) {
                       Text("100,000")
                           .font(.system(size: 46, weight: .bold))
                           .foregroundStyle(
                               LinearGradient(
                                   colors: [
                                       Color(hex: "#4E62FF"),
                                       Color(hex: "#502EFF")
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
                   
                   VStack(spacing: 6) {
                       Text("적절한 금액이에요!")
                           .bodyMedium16()
                           .foregroundColor(.white)
                       
                       Text("알려주신 정보를 고려한 추천입니다")
                           .bodyRegular14()
                           .foregroundColor(.gray200)
                   }
                   .padding(.horizontal, 24)
                   .padding(.vertical, 10)
                   .background(
                       RoundedRectangle(cornerRadius: 10)
                        .fill(.gray750.opacity(0.6))
                   )
               }
               .padding(.horizontal, 30)
               .padding(.vertical, 30)
               .background(
                   RoundedRectangle(cornerRadius: 12)
                       .fill(
                           LinearGradient(
                               colors: [
                                   Color(hex: "#A6BEF3"),
                                   Color(hex: "#D3D9FF")
                               ],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing
                           )
                       )
               )
           }
           .transition(.opacity.combined(with: .scale))
       }
    }
    
    // MARK: - Empty Recommendation Box
//    private var emptyRecommendationBox: some View {
//        VStack(spacing: 16) {
//            
//            RoundedRectangle(cornerRadius: 16)
//                .fill(Color.gray.opacity(0.2))
//                .frame(height: 120)
//            
//        }
//        .padding(20)
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.white.opacity(0.1))
//        )
//    }
    
    // MARK: - Amount Range Section
    var amountRangeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("적정 범위")
                .titleSemiBold18()
                .foregroundColor(.white)
            
            //MARK: - 커스텀 슬라이더, (필요 없으면 삭제해도 됨.)
            VStack(spacing: 8) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex:"#292929"))
                        .frame(width: 300, height: 12)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                               LinearGradient(
                                   colors: [
                                       Color(hex: "#502EFF"),
                                       Color(hex: "#807FFF")
                                   ],
                                   startPoint: .leading,
                                   endPoint: .trailing
                               )
                           )
                        .frame(width: CGFloat(viewModel.sliderProgress) * 300, height: 12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let progress = min(max(0, value.location.x / 300), 1)
                            let newAmount = Int(progress * Double(viewModel.maxAmount - viewModel.minAmount)) + viewModel.minAmount
                            viewModel.updateSliderAmount(to: Double(newAmount))
                        }
                )
                
                HStack {
                    Text("\(viewModel.formattedMinAmount)원")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                    
                    Spacer()
                    
                    Text("\(viewModel.formattedMaxAmount)원")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
        )
    }
    
    // MARK: - Category Section
    var categorySection: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
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
                    Text("결혼식")
                        .bodyMedium16()
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(width: 163, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("gray750"))
            )
            
            HStack(spacing: 12) {
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
                    Text("강남 웨딩홀")
                        .bodyMedium16()
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(width: 164, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("gray750"))
            )
        }
    }
    
    // MARK: - Notice Section
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
                Text("• 친구 관계 (친밀도 보통)")
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
    
    // MARK: - Participation Section
    var participationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("icon_colorcheck")
                Text("참고해주세요!")
                    .bodyRegular16()
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
    
    // MARK: - Bottom Buttons
    var bottomButtons: some View {
        VStack(spacing: 12) {
            Button("이 금액으로 결정하기") {
                // 결정 액션
                router.push(to: .recommendSuccessView)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color("primary_normal"))
            .foregroundColor(.white)
            .font(.title_semibold_18)
            .cornerRadius(10)
            
            Button("추천받은 금액 수정하기") {
                // 수정 액션
                router.push(to: .modifyEventView(mode: .edit, eventDetailData: nil))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color("gray700"))
            .foregroundColor(.gray200)
            .font(.title_semibold_18)
            .cornerRadius(10)
        }
    }
}

// MARK: - NumberFormatter Extension
extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

// MARK: - Preview
#Preview {
    @Previewable @StateObject var stepManager = GlobalStepManager()
    
    RecommendCostView()
        .environmentObject(stepManager)
}
