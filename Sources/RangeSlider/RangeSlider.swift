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
    
    public let bounds: ClosedRange<Float>
    
    public let onEditingChanged: (_ isHigh: Bool, _ isEditing: Bool) -> Void
    
    public var body: some View {
        GeometryReader { geometry in
            // Circleが外にはみ出してしまうため、diameterを引く
            RangeSliderContentView(currentHighPosition: $highValue, currentLowPosition: $lowValue, width: geometry.size.width - SliderHandleViewModel.diameter, bounds: bounds) { isHigh, isEditing in
                onEditingChanged(isHigh, isEditing)
            }
            // 真ん中にする
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .frame(height: SliderHandleViewModel.diameter)
    }
}
