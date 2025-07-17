//
//  EmptyCardView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/12/25.
//

import SwiftUI

struct EmptyCardView: View {
    @StateObject private var stepManager = GlobalStepManager()
    
    // 더미 데이터 생성
    private let emptySchedule = ScheduleModel(
        type: "새 일정",
        relation: "",
        name: "",
        money: "0원",
        location: "",
        date: ""
    )
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Image("icon_plus")
                    .foregroundColor(.black)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color(hex:"#6E7FFF")))
            }
            .padding(.top, 14)

            Text("예정된 일정이 없습니다")
                .titleSemiBold18()
                .foregroundColor(.white)
                .padding(.bottom, -12)
               
            NavigationLink(destination: AllRecordsView(eventId: "123").environmentObject(stepManager)) {
                HStack(spacing: 4) {
                    Text("일정추가하기 >")
                        .captionRegular12()
                        .foregroundColor(.gray300)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.gray900)
                .cornerRadius(6)
            }
            .padding(.bottom, 14)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.gray800)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

