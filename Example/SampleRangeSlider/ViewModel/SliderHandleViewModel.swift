//
//  SliderHandleView.swift
//  SampleRangeSlider
//
//  Created by 鶴本賢太朗 on 2022/03/13.
//

import Combine
import SwiftUI

class SliderHandleViewModel: ObservableObject {
    // Slider View Size
    let sliderWidth: CGFloat
    let sliderHeight: CGFloat
    
    // Slider Range
    let sliderRange: ClosedRange<Float>
    
    // Slider circle diameter
    static let diameter: CGFloat = 28
    
    // Current Slider Location
    @Published var currentLocation: CGPoint {
        didSet {
            let percent = Float(currentLocation.x / sliderWidth)
            currentValue = (sliderRange.upperBound - sliderRange.lowerBound) * percent + sliderRange.lowerBound
        }
    }
    
    // Current Slider Value
    @Published var currentValue: Float = 0.0
    
    init(sliderWidth: CGFloat, sliderHeight: CGFloat, sliderRange: ClosedRange<Float>, startLocation: CGFloat) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        self.sliderRange = sliderRange
        
        let x: CGFloat = max(min(startLocation, sliderWidth), 0.0)
        self.currentLocation = CGPoint(x: x, y: sliderHeight / 2)
    }
    
    func onChangedDrag(location: CGPoint) {
        
        updateLocation(location)
    }
    
    func onEndedDrag() {
        
    }
    
    private func updateLocation(_ dragLocation: CGPoint) {
        let x = max(min(dragLocation.x, sliderWidth), 0.0)
        let y = sliderHeight / 2
        currentLocation = CGPoint(x: x, y: y)
    }
}
