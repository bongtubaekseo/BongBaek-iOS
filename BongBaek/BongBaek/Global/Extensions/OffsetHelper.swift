//
//  OffsetHelper.swift
//  BongBaek
//
//  Created by 임재현 on 12/26/25.
//

import SwiftUI

struct OffsetHelper: ViewModifier {
    var onChange: (CGFloat, CGFloat) -> ()
    @State var currentOffset: CGFloat = 0
    @State var previousOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    let miny = proxy.frame(in: .named("SCROLL")).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: miny)
                        .onPreferenceChange(OffsetKey.self) { value in
                            previousOffset = currentOffset
                            currentOffset = value
                            onChange(previousOffset, currentOffset)
                        }
                }
            }
    }
    
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HeaderBounceKey: PreferenceKey {
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
    
    static var defaultValue: Anchor<CGRect>?
}


enum SwipeDirection {
    case up
    case down
    case none
}
