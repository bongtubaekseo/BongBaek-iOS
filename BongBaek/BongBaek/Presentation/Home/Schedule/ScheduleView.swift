//
//  ScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct ScheduleView: View {
    let schedules: [ScheduleModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("봉백님의 일정")
                    .font(.title_semibold_20)
                    .foregroundStyle(.white)
                
                Spacer()
                
                NavigationLink(destination: FullScheduleView()) {
                    Text("더보기")
                        .bodyRegular14()
                        .foregroundColor(.gray)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.clear)
                }
            }
            .padding(.bottom, 20)
            
            ForEach(schedules) { schedule in
                ScheduleCellView(schedule: schedule)
            }
        }
        .padding(.horizontal)
        .background(Color.black)
    }
}

#Preview {
    ScheduleView(schedules: scheduleDummy)
}
