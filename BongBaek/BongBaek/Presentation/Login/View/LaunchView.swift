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
            Image("Frame 2087329064")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customBackgroundGradient)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LaunchView()
}
