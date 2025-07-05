//
//  CustomSlider.swift
//  BongBaek
//
//  Created by 임재현 on 7/4/25.
//

import SwiftUI

 struct CustomSlider<S1: ShapeStyle, S2: ShapeStyle, T: View>: View {
    private var fillBackground: S1
    private var fillTrack: S2
    private var thumbView: T?

    private var barStyle: (height: Double?, cornerRadius: Double)
    private var bounds: ClosedRange<Double>
    private var step: Double?
    @Binding private var value: Double
    
    var body: some View {

        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            RoundedRectangle(cornerRadius: barStyle.cornerRadius)
                .fill(fillBackground)
            
            ThumbView(value: $value, in: bounds, step: step, maxWidth: frame.width, cornerRadius: barStyle.cornerRadius, fill: fillTrack, thumbView: {
                if let thumbView = thumbView {
                    thumbView
                } else {
                    defaultThumb
                }
            })
        }
        .frame(height: barStyle.height == nil ? nil : barStyle.height!)
    }
    
    private var defaultThumb: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 24, height: 24)
            .shadow(color: .black.opacity(0.3), radius: 3, x: 1, y: 1)
    }

}

extension CustomSlider where T == Never, S1 == Color, S2 == Color {
    init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride? = nil, barStyle: (height: Double?, cornerRadius: Double) = (nil, 8)) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        let bindingDouble = Binding<Double>(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self._value = bindingDouble
        self.bounds = Double(bounds.lowerBound)...Double(bounds.upperBound)
        self.step = step == nil ? nil : Double.Stride(step!)
        self.barStyle = barStyle
        self.fillBackground = .gray.opacity(0.3)
        self.fillTrack = .blue
    }
}

extension CustomSlider  {
    init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride? = nil, barStyle: (height: Double?, cornerRadius: Double), fillBackground: S1, fillTrack: S2, @ViewBuilder thumbView: () -> T) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        let bindingDouble = Binding<Double>(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self._value = bindingDouble
        self.bounds = Double(bounds.lowerBound)...Double(bounds.upperBound)
        self.step = step == nil ? nil : Double.Stride(step!)
        self.barStyle = barStyle
        self.fillBackground = fillBackground
        self.fillTrack = fillTrack
        self.thumbView = thumbView()
    }
}


fileprivate struct ThumbView<S: ShapeStyle, T: View>: View {
    private var fillStyle: S
    private var thumbView: T
   
    private var maxWidth: Double
    private var cornerRadius: Double
    private var bounds: ClosedRange<Double>
    private var step: Double?

    @Binding private var value: Double
    @State private var previousWidth: Double = 0
    @State private var thumbWidth: Double = 0
    @State private var isDragging: Bool = false

    @State private var positionX: CGFloat = 0
    
    var body: some View {
        let width = calculateTrackWidth()
        
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(fillStyle)
            .frame(width: width)
            .overlay(
                thumbView
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged { action in
                                isDragging = true
                                let newWidth = previousWidth + action.translation.width
                                let percentage = max(min(newWidth / maxWidth, 1), 0)
                                self.value = roundToStep(percentageToValue(percentage))

                            }
                            .onEnded {_ in
                                isDragging = false
                                previousWidth = width
                            }
                    )
                    .overlay(content: {
                        GeometryReader { geometry in
                            DispatchQueue.main.async {
                                self.thumbWidth = geometry.size.width
                            }
                            return Color.clear
                        }
                    })
                    .offset(x: thumbWidth/2),
                    alignment: .trailing
            )
            .onAppear {
                self.previousWidth = calculateTrackWidth()
            }
            .onChange(of: value, {
                guard !isDragging else { return }
                self.previousWidth = calculateTrackWidth()
            })
    }
     
    private func calculateTrackWidth() -> Double {
        maxWidth * ((value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound))
    }
    
    private func percentageToValue(_ percentage: Double) -> Double {
        (bounds.upperBound - bounds.lowerBound) * percentage + bounds.lowerBound
    }
    
    func roundToStep(_ value: Double) -> Double {
        guard let step = step else { return value }
        let diff = value - bounds.lowerBound
        let remainder = diff.remainder(dividingBy: step)
        let new = if abs(remainder - step) > remainder {
            value - remainder
        } else {
            value + (step - remainder)
        }
        return min(max(new, bounds.lowerBound), bounds.upperBound)
    }
}

extension ThumbView {
    init(value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double.Stride?,  maxWidth: Double, cornerRadius: Double, fill: S, @ViewBuilder thumbView: () -> T) {
        self._value = value
        self.bounds = bounds
        self.step = step
        self.cornerRadius = cornerRadius
        self.fillStyle = fill
        self.maxWidth = maxWidth
        self.thumbView = thumbView()
    }
}
