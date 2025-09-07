//
//  LoadingView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/7/25.
//
import SwiftUI

struct LoadingView: View {
    var body: some View {
        NavigationView {
            VStack {
                LottieTest(animationFileName: "envelope", loopMode: .loop)
                    .frame(width: 250, height: 250)
            }
            .navigationTitle("Lottie 애니메이션")
        }
    }
}
