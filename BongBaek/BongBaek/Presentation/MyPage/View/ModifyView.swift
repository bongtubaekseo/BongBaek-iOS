//
//  ModifyView.swift
//  BongBaek
//
//  Created by hyunwoo on 8/28/25.
//
import SwiftUI

struct ModifyView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: {}) {
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
                                
                                Text("봉투백서의겸손한야수")
                                    .headBold24()
                                    .foregroundStyle(.gray100)
                                
                                Button(action: {}) {
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
                                    Text("2000년 01월 05일")
                                        .bodyMedium14()
                                        .foregroundStyle(.gray100)
                                    Text("없음")
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
                                    ServiceRow(
                                        icon: "square.stack.3d.up",
                                        title: "앱 버전",
                                        subtitle: "v 1.0.0",
                                        showChevron: false
                                    )
                                    
                                    ServiceRow(
                                        icon: "message",
                                        title: "문의하기",
                                        showChevron: true
                                    )
                                    
                                    ServiceRow(
                                        icon: "doc.text",
                                        title: "서비스 이용약관",
                                        showChevron: true
                                    )

                                    ServiceRow(
                                        icon: "magnifyingglass",
                                        title: "개인정보 처리방침",
                                        showChevron: true
                                    )
                                }
                            }

                            HStack {
                                Button(action: {}) {
                                    Text("로그아웃")
                                        .foregroundColor(.gray400)
                                        .bodyRegular14()
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("서비스 탈퇴")
                                        .foregroundColor(.gray400)
                                        .bodyRegular14()
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 40)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ServiceRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let showChevron: Bool
    
    init(icon: String, title: String, subtitle: String? = nil, showChevron: Bool = false) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.showChevron = showChevron
    }
    
    var body: some View {
        Button(action: {
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .frame(width: 20)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                
                Spacer()
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
