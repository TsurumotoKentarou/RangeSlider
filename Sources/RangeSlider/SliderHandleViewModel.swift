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
    let sliderValueRange: ClosedRange<CGFloat>
    
    // Slider Value Limit Range
    var sliderValueLimitRange: ClosedRange<CGFloat>
    
    // Slider circle diameter
    let sliderDiameter: CGFloat
    private var circleRadius: CGFloat {
        return sliderDiameter / 2
    }
    
    // Slider limit location
    private var minLocationX: CGFloat {
        return circleRadius
    }
    private var maxLocationX: CGFloat {
        return sliderWidth - circleRadius
    }
    
    // Current Slider Location
    @Published var currentLocation: CGPoint {
        didSet {
            // diameter分位置がずれているので、最小値を0にしてからパーセント計算をする
            let percent = (currentLocation.x - minLocationX) / (maxLocationX - minLocationX)
            let newValue = (sliderValueRange.upperBound - sliderValueRange.lowerBound) * percent + sliderValueRange.lowerBound
            if sliderValueLimitRange.contains(newValue) {
                currentValue = Float(newValue)
            }
        }
    }
    
    // Current Slider Value
    @Published var currentValue: Float = 0.0
    
    init(sliderWidth: CGFloat,
         sliderHeight: CGFloat,
         sliderDiameter: CGFloat,
         sliderValueRange: ClosedRange<CGFloat>,
         sliderValueLimitRange: ClosedRange<CGFloat>,
         startValue: CGFloat) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        self.sliderDiameter = sliderDiameter
        self.sliderValueRange = sliderValueRange
        self.sliderValueLimitRange = sliderValueLimitRange
        
        let startValueRate = (startValue - sliderValueRange.lowerBound) / (sliderValueRange.upperBound - sliderValueRange.lowerBound)
        let startX = startValueRate * sliderWidth
        let x = max(min(startX, sliderWidth - sliderDiameter / 2), sliderDiameter / 2)
        self.currentLocation = CGPoint(x: x, y: sliderHeight / 2)
    }
    
    func onChangedDrag(location: CGPoint) {
        updateLocation(location)
    }
    
    func onEndedDrag() {
        
    }
    
    private func updateLocation(_ dragLocation: CGPoint) {
        let x = max(min(dragLocation.x, maxLocationX), minLocationX)
        var newLocationX: CGFloat = x
        let sliderValue = toSliderValue(location: x)
        if (sliderValue < sliderValueLimitRange.lowerBound) {
            newLocationX = toLocation(sliderValue: sliderValueLimitRange.lowerBound)
        }
        else if sliderValue > sliderValueLimitRange.upperBound {
            newLocationX = toLocation(sliderValue: sliderValueLimitRange.upperBound)
        }

        let y = sliderHeight / 2
        
        currentLocation = CGPoint(x: newLocationX, y: y)
    }
    
    private func toSliderValue(location: CGFloat) -> CGFloat {
        let locationRate = (location - minLocationX) / (maxLocationX - minLocationX)
        return (sliderValueRange.upperBound - sliderValueRange.lowerBound) * locationRate + sliderValueRange.lowerBound
    }
    
    private func toLocation(sliderValue: CGFloat) -> CGFloat {
        let lower = sliderValueRange.lowerBound
        let upper = sliderValueRange.upperBound
        let sliderValueRate = (sliderValue - lower) / (upper - lower)
        return (maxLocationX - minLocationX) * sliderValueRate + minLocationX
    }
}
