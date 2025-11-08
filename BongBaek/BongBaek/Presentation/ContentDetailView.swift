//
//  ContentDetailView.swift
//  BongBaek
//
//  Created by 임재현 on 11/8/25.
//

import SwiftUI

struct ContentDetailView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "") {
                router.pop()
            }
            
            ScrollView {
                // Content
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.bgDisplayPrimary)
    }
}

