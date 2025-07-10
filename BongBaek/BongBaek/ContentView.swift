//
//  ContentView.swift
//  BongBaek
//
//  Created by 임재현 on 6/28/25.
//

import SwiftUI

struct ContentView: View {
    let NATIVEAPPKEY = Bundle.main.infoDictionary?["KAKAONATIVEAPPKEY"] as? String ?? ""
    let APIKEY = Bundle.main.infoDictionary?["KAKAOAPIKEY"] as? String ?? ""
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("\(NATIVEAPPKEY)")
            Text("\(APIKEY)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
