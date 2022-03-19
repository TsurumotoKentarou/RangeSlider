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
    
    // service class
    private let service: SliderHandleService
    
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
            let newValue = service.toSliderValue(location: currentLocation.x, minLocationX: minLocationX, maxLocationX: maxLocationX, sliderValueRange: sliderValueRange)
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
         service: SliderHandleService,
         sliderValueRange: ClosedRange<CGFloat>,
         sliderValueLimitRange: ClosedRange<CGFloat>,
         startValue: CGFloat) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        self.sliderDiameter = sliderDiameter
        self.service = service
        self.sliderValueRange = sliderValueRange
        self.sliderValueLimitRange = sliderValueLimitRange
        
        let minLocationX = sliderDiameter / 2
        let maxLocationX = sliderWidth - minLocationX
        let startLocationX = service.toLocation(sliderValue: startValue, minLocationX: minLocationX, maxLocationX: maxLocationX, sliderValueRange: sliderValueRange)
        let x = max(min(startLocationX, maxLocationX), minLocationX)
        self.currentLocation = CGPoint(x: x, y: sliderHeight / 2)
        
        let calcStartValue = service.toSliderValue(location: x, minLocationX: minLocationX, maxLocationX: maxLocationX, sliderValueRange: sliderValueRange)
        self.currentValue = Float(calcStartValue)
    }
    
    func onChangedDrag(location: CGPoint) {
        updateLocation(location)
    }
    
    func onEndedDrag() {
        
    }
    
    private func updateLocation(_ dragLocation: CGPoint) {
        let x = max(min(dragLocation.x, maxLocationX), minLocationX)
        var newLocationX: CGFloat = x
        
        let sliderValue = service.toSliderValue(location: x,
                                                minLocationX: minLocationX,
                                                maxLocationX: maxLocationX,
                                                sliderValueRange: sliderValueRange)
        if (sliderValue < sliderValueLimitRange.lowerBound) {
            newLocationX = service.toLocation(sliderValue: sliderValueLimitRange.lowerBound,
                                                          minLocationX: minLocationX,
                                                          maxLocationX: maxLocationX,
                                                          sliderValueRange: sliderValueRange)
        }
        else if sliderValue > sliderValueLimitRange.upperBound {
            newLocationX = service.toLocation(sliderValue: sliderValueLimitRange.upperBound,
                                                          minLocationX: minLocationX,
                                                          maxLocationX: maxLocationX,
                                                          sliderValueRange: sliderValueRange)
        }

        let y = sliderHeight / 2
        
        currentLocation = CGPoint(x: newLocationX, y: y)
    }
}
