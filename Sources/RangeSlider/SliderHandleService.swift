//
//  SliderHandleService.swift
//  SampleRangeSlider
//
//  Created by 鶴本賢太朗 on 2022/03/19.
//

import SwiftUI

protocol SliderHandleService {
    
    /// location to slider value
    /// - Parameters:
    ///   - location: slider location
    ///   - minLocationX: minimum location
    ///   - maxLocationX: maximum location
    ///   - sliderValueRange: slider value range
    /// - Returns: slider value
    func toSliderValue(location: CGFloat,
                               minLocationX: CGFloat,
                               maxLocationX: CGFloat,
                               sliderValueRange: ClosedRange<CGFloat>) -> CGFloat
    
    /// slider value to location
    /// - Parameters:
    ///   - sliderValue: slider value
    ///   - minLocationX: minimum location
    ///   - maxLocationX: maximum location
    ///   - sliderValueRange: slider value range
    /// - Returns: location
    func toLocation(sliderValue: CGFloat,
                            minLocationX: CGFloat,
                            maxLocationX: CGFloat,
                            sliderValueRange: ClosedRange<CGFloat>) -> CGFloat
}

class SliderHandleServiceImpl: SliderHandleService {
    func toSliderValue(location: CGFloat,
                               minLocationX: CGFloat,
                               maxLocationX: CGFloat,
                               sliderValueRange: ClosedRange<CGFloat>) -> CGFloat {
        let locationRate = (location - minLocationX) / (maxLocationX - minLocationX)
        return (sliderValueRange.upperBound - sliderValueRange.lowerBound) * locationRate + sliderValueRange.lowerBound
    }
    
    func toLocation(sliderValue: CGFloat,
                            minLocationX: CGFloat,
                            maxLocationX: CGFloat,
                            sliderValueRange: ClosedRange<CGFloat>) -> CGFloat {
        let lower = sliderValueRange.lowerBound
        let upper = sliderValueRange.upperBound
        let sliderValueRate = (sliderValue - lower) / (upper - lower)
        return (maxLocationX - minLocationX) * sliderValueRate + minLocationX
    }
}
