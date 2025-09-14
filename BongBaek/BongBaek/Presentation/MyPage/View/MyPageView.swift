//
//  ModifyView.swift
//  BongBaek
//
//  Created by hyunwoo on 8/28/25.
//
import SwiftUI

struct ServiceItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String?
    let showChevron: Bool
    let url: String?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        showChevron: Bool = false,
        url: String? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.showChevron = showChevron
        self.url = url
    }
}

struct MyPageView: View {
    @StateObject private var stepManager = GlobalStepManager()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: NavigationRouter
    @StateObject private var mypageViewModel = MyPageViewModel()
    @State private var showLogoutAlert = false
    
    private let serviceItems: [ServiceItem] = [
        ServiceItem(icon: "icon_intersect", title: "앱 버전", subtitle: "v 1.0.0", showChevron: false),
        ServiceItem(icon: "icon_information", title: "문의하기", showChevron: true,url: "https://www.notion.so/bongtubaekseo/264f06bb0d3480aa8badeba07a68b944"),
        ServiceItem(icon: "icon_book", title: "서비스 이용약관", showChevron: true,url: "https://www.notion.so/bongtubaekseo/264f06bb0d348036b260f175a236ec7c"),
        ServiceItem(icon: "icon_key", title: "개인정보 처리방침", showChevron: true,url: "https://www.notion.so/bongtubaekseo/264f06bb0d3480d0b1eafa217b306105")
    ]
    
   
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            router.pop()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("마이페이지")
                            .titleSemiBold18()
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            Image(.myPageLogo)
                                .frame(width: 110, height: 110)
                                .padding(.top, 40)
                            
                            Text(mypageViewModel.profileData?.memberName ?? "봉투백서의겸손한야수")
                                .headBold24()
                                .foregroundStyle(.gray100)
                            
                            Button(action: {
                                router.push(to: .ModifyView(profileData: mypageViewModel.profileData))
                            }) {
                                Text("내 정보 수정")
                                    .captionRegular12()
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(.primaryNormal)
                                    .cornerRadius(20)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("생년월일")
                                    .bodyMedium14()
                                    .foregroundStyle(.gray200)
                                Text("수입")
                                    .bodyMedium14()
                                    .foregroundStyle(.gray200)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 20) {
                                Text(formatBirthday(mypageViewModel.profileData?.memberBirthday) ?? "2000년 01월 05일")
                                    .bodyMedium14()
                                    .foregroundStyle(.gray100)
                                Text(formatIncome(mypageViewModel.profileData?.memberIncome) ?? "없음")
                                    .bodyMedium14()
                                    .foregroundStyle(.gray100)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(.gray750)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("서비스")
                                    .titleSemiBold18()
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                            
                            VStack(spacing: 0) {
                                ForEach(serviceItems) { item in
                                    ServiceRow(
                                        icon: item.icon,
                                        title: item.title,
                                        subtitle: item.subtitle,
                                        showChevron: item.showChevron,
                                        url: item.url
                                    )
                                }
                            }
                        }

                        HStack {
                            Button(action: {
                                showLogoutAlert = true
                            }) {
                                Text("로그아웃")
                                    .foregroundColor(.gray400)
                                    .bodyRegular14()
                                    .padding(.leading, 68)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                router.push(to: .accountDeletionView)
                            }) {
                                Text("서비스 탈퇴")
                                    .foregroundColor(.gray400)
                                    .bodyRegular14()
                                    .padding(.trailing, 68)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            print("MyPageView 나타남 - 데이터 로드 시작")
            mypageViewModel.loadprofile()
        }
        .navigationBarHidden(true)
        .alert("로그아웃하시겠습니까?", isPresented: $showLogoutAlert) {
            Button("취소", role: .cancel) {
            }
            Button("로그아웃", role: .destructive) {
                AuthManager.shared.logout()
            }
        } message: {
            Text("로그아웃 시 서비스 이용을 위해 다시 로그인해야 합니다.")
        }
    }
    
    private func formatBirthday(_ birthday: String?) -> String? {
        guard let birthday = birthday else { return nil }
        // "2011-09-06" → "2011년 09월 06일"
        let components = birthday.split(separator: "-")
        if components.count == 3 {
            return "\(components[0])년 \(components[1])월 \(components[2])일"
        }
        return birthday
    }

    private func formatIncome(_ income: String?) -> String? {
        guard let income = income else { return nil }
        switch income {
        case "NONE": return "없음"
        case "UNDER200": return "200만원 미만"
        case "OVER200": return "200만원 이상"
        default: return income
        }
    }
}

struct ServiceRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let showChevron: Bool
    let url: String?
    
    @Environment(\.openURL) private var openURL
    
    init(icon: String, title: String, subtitle: String? = nil, showChevron: Bool = false, url: String? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.showChevron = showChevron
        self.url = url
    }
    
    var body: some View {
        Button(action: {
            handleServiceItemTap(url: url)
        }) {
            HStack(spacing: 16) {
                Image(icon)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .foregroundColor(.gray400)
                    .font(.body1_medium_16)
                
                Spacer()
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .foregroundColor(.gray400)
                        .font(.body1_medium_16)
                }
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray400)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func handleServiceItemTap(url: String?) {
        guard let urlString = url,
              let url = URL(string: urlString) else {
            print("유효하지 않은 URL: \(url ?? "nil")")
            return
        }
        
        openURL(url)
    }
}
