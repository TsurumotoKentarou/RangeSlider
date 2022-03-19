//
//  RangeSlider.swift
//
//  Created by 鶴本賢太朗 on 2022/03/13.
//

import SwiftUI

@available(iOS 14.0, *)
public struct RangeSlider: View {
    @Binding public var highValue: Float
    
    @Binding public var lowValue: Float
    
    public let bounds: ClosedRange<CGFloat>
    
    public let tintColor: Color
    
    public let unableTintColor: Color
    
    public let onEditingChanged: (_ isHigh: Bool, _ isEditing: Bool) -> Void
    
    // Slider circle diameter
    private let sliderDiameter: CGFloat = 28
    
    /// Initialization
    /// - Parameters:
    ///   - highValue: high slider value
    ///   - lowValue: low slider value
    ///   - bounds: the range of slider value
    ///   - tintColor: tint color inside the slider range
    ///   - unableTintColor: tint color outside the slider range
    ///   - onEditingChanged: called when Slider value is changed
    public init(highValue: Binding<Float>,
                lowValue: Binding<Float>,
                bounds: ClosedRange<CGFloat>,
                tintColor: Color = Color.blue,
                unableTintColor: Color = Color(UIColor.label.withAlphaComponent(0.15)),
                onEditingChanged: @escaping (_ isHigh: Bool, _ isEditing: Bool) -> Void) {
        _highValue = highValue
        _lowValue = lowValue
        self.bounds = bounds
        self.tintColor = tintColor
        self.unableTintColor = unableTintColor
        self.onEditingChanged = onEditingChanged
    }
    
    public var body: some View {
        GeometryReader { geometry in
            RangeSliderContentView(highValue: $highValue,
                                   lowValue: $lowValue,
                                   width: geometry.size.width,
                                   sliderDiameter: sliderDiameter,
                                   bounds: bounds,
                                   tintColor: tintColor,
                                   unableTintColor: unableTintColor) { isHigh, isEditing in
                onEditingChanged(isHigh, isEditing)
            }
            // 真ん中にする
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .frame(height: sliderDiameter)
    }
}
