//
//  View+.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    @ViewBuilder
    func offsetY(completion: @escaping(CGFloat, CGFloat) -> ()) -> some View {
            self
            .modifier(OffsetHelper(onChange: completion))
    }
}

extension View {
    func safeArea() -> UIEdgeInsets {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return .zero}
        guard let safeArea =  scene.windows.first?.safeAreaInsets else {return .zero}
        return  safeArea
    }
}
