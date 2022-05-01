//
//  RangeSlider.swift
//
//  Created by 鶴本賢太朗 on 2022/03/13.
//

import SwiftUI

public struct RangeSlider: View {
    @Binding public var currentValue: ClosedRange<Float>
    
    public let bounds: ClosedRange<Float>
    
    public let tintColor: Color
    
    public let unableTintColor: Color
    
    public let onEditingChanged: (_ isEditing: Bool) -> Void
    
    // Slider circle diameter
    private let sliderDiameter: CGFloat = 28
    
    /// Initialization
    /// - Parameters:
    ///   - currentValue: slider range value
    ///   - bounds: the range of slider value
    ///   - tintColor: tint color inside the slider range
    ///   - unableTintColor: tint color outside the slider range
    ///   - onEditingChanged: called when Slider value is changed
    public init(currentValue: Binding<ClosedRange<Float>>,
                bounds: ClosedRange<Float>,
                tintColor: Color = Color.blue,
                unableTintColor: Color = Color(UIColor.label.withAlphaComponent(0.15)),
                onEditingChanged: @escaping (_ isEditing: Bool) -> Void) {
        _currentValue = currentValue
        self.bounds = bounds
        self.tintColor = tintColor
        self.unableTintColor = unableTintColor
        self.onEditingChanged = onEditingChanged
    }
    
    public var body: some View {
        GeometryReader { geometry in
            RangeSliderContentView(currentValue: $currentValue,
                                   width: geometry.size.width,
                                   sliderDiameter: sliderDiameter,
                                   sliderValueRange: bounds,
                                   tintColor: tintColor,
                                   unableTintColor: unableTintColor) { isEditing in
                onEditingChanged(isEditing)
            }
            // to center
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .frame(height: sliderDiameter)
    }
}
