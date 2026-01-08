//
//  LaunchView.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack {
            Image("logo")
                .frame(width: 143,height: 45)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundLaunch)
        .ignoresSafeArea(.all)
    }
}
