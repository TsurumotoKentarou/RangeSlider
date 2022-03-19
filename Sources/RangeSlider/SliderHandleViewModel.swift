//
//  SliderHandleViewModel.swift
//
//  Created by 鶴本賢太朗 on 2022/03/13.
//

import Combine
import SwiftUI

@available(iOS 14.0, *)
class SliderHandleViewModel: ObservableObject {
    // Slider View Size
    let sliderWidth: CGFloat
    let sliderHeight: CGFloat
    
    // Slider Value Range
    let sliderValueRange: ClosedRange<Float>
    
    // Slider limit location
    private var minLocationX: CGFloat {
        return SliderHandleViewModel.diameter / 2
    }
    private var maxLocationX: CGFloat {
        return sliderWidth - SliderHandleViewModel.diameter / 2
    }
    
    // Slider circle diameter
    static let diameter: CGFloat = 28
    
    // Current Slider Location
    @Published var currentLocation: CGPoint {
        didSet {
            // diameter分位置がずれているので、最小値を0にしてからパーセント計算をする
            let percent = Float((currentLocation.x - minLocationX) / (maxLocationX - minLocationX))
            currentValue = (sliderValueRange.upperBound - sliderValueRange.lowerBound) * percent + sliderValueRange.lowerBound
        }
    }
    
    // Current Slider Value
    @Published var currentValue: Float = 0.0
    
    init(sliderWidth: CGFloat, sliderHeight: CGFloat, sliderValueRange: ClosedRange<Float>, startValue: CGFloat) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        self.sliderValueRange = sliderValueRange
        
        let x = max(min(startValue, sliderWidth - SliderHandleViewModel.diameter / 2), SliderHandleViewModel.diameter / 2)
        self.currentLocation = CGPoint(x: x, y: sliderHeight / 2)
    }
    
    func onChangedDrag(location: CGPoint) {
        updateLocation(location)
    }
    
    func onEndedDrag() {
        
    }
    
    private func updateLocation(_ dragLocation: CGPoint) {
        let x = max(min(dragLocation.x, maxLocationX), minLocationX)
        let y = sliderHeight / 2
        currentLocation = CGPoint(x: x, y: y)
    }
}
