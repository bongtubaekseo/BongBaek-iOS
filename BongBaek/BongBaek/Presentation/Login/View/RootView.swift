//
//  RootView.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI

struct RootView: View {
    @State private var showLoginView = false
    
    var body: some View {
        if showLoginView {
            LoginView()
        } else {
            LaunchView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            showLoginView = true
                        }
                    }
                }
        }
    }
}

#Preview {
    RootView()
}
