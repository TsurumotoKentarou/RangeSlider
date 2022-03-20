//
//  RangeSliderContentView.swift
//
//  Created by 鶴本賢太朗 on 2022/03/18.
//

import SwiftUI

@available(iOS 14.0, *)
struct RangeSliderContentView: View {
    @Binding var currentValue: ClosedRange<Float>
    
    let width: CGFloat
    
    let sliderValueRange: ClosedRange<Float>
    
    let tintColor: Color
    
    let unableTintColor: Color
    
    let onEditingChanged: (_ isEditing: Bool) -> Void
    
    static let sliderHeight: CGFloat = 4.0
    
    @ObservedObject var lowViewModel: SliderHandleViewModel
    
    @ObservedObject var highViewModel: SliderHandleViewModel
    
    init(currentValue: Binding<ClosedRange<Float>>,
         width: CGFloat,
         sliderDiameter: CGFloat,
         sliderValueRange: ClosedRange<Float>,
         tintColor: Color,
         unableTintColor: Color,
         onEditingChanged: @escaping (_ isEditing: Bool) -> Void) {
        _currentValue = currentValue
        self.width = width
        self.tintColor = tintColor
        self.sliderValueRange = sliderValueRange
        self.unableTintColor = unableTintColor
        self.onEditingChanged = onEditingChanged
        
        let lowUpper = CGFloat(currentValue.wrappedValue.upperBound)
        let lowLower = CGFloat(sliderValueRange.lowerBound)
        let highUpper = CGFloat(sliderValueRange.upperBound)
        let highLower = CGFloat(currentValue.wrappedValue.lowerBound)
        
        _lowViewModel = ObservedObject(wrappedValue: .init(sliderWidth: width,
                                                           sliderHeight: RangeSliderContentView.sliderHeight,
                                                           sliderDiameter: sliderDiameter,
                                                           service: SliderHandleServiceImpl(),
                                                           sliderValueRange: CGFloat(sliderValueRange.lowerBound)...CGFloat(sliderValueRange.upperBound),
                                                           sliderValueLimitRange: lowLower...lowUpper,
                                                           startValue: CGFloat(currentValue.wrappedValue.lowerBound)))
        
        _highViewModel = ObservedObject(wrappedValue: .init(sliderWidth: width,
                                                         sliderHeight: RangeSliderContentView.sliderHeight,
                                                         sliderDiameter: sliderDiameter,
                                                         service: SliderHandleServiceImpl(),
                                                         sliderValueRange: CGFloat(sliderValueRange.lowerBound)...CGFloat(sliderValueRange.upperBound),
                                                         sliderValueLimitRange: highLower...highUpper,
                                                         startValue: CGFloat(currentValue.wrappedValue.upperBound)))
    }
    
    private func updateLimitRange() {
        let lowUpper = CGFloat(currentValue.upperBound)
        let lowLower = CGFloat(sliderValueRange.lowerBound)
        let highUpper = CGFloat(sliderValueRange.upperBound)
        let highLower = CGFloat(currentValue.lowerBound)
        lowViewModel.sliderValueLimitRange = lowLower...lowUpper
        highViewModel.sliderValueLimitRange = highLower...highUpper
    }
    
    private func updateCurrentValue() {
        let high = max(lowViewModel.currentValue, highViewModel.currentValue)
        let low = min(lowViewModel.currentValue, highViewModel.currentValue)
        currentValue = low...high
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(unableTintColor)
            .frame(width: width, height: RangeSliderContentView.sliderHeight)
            .overlay(
                ZStack() {
                    SliderPathView(currentHighLocation: highViewModel.currentLocation,
                                   currentLowLocation: lowViewModel.currentLocation,
                                   height: RangeSliderContentView.sliderHeight,
                                   tintColor: tintColor)
                    
                    SliderHandleView(diamater: lowViewModel.sliderDiameter, location: lowViewModel.currentLocation)
                        .highPriorityGesture(DragGesture().onChanged({ value in
                            withAnimation(.spring(response: 0.1, dampingFraction: 1.0)) {
                                lowViewModel.onChangedDrag(location: value.location)
                                updateLimitRange()
                            }
                            updateCurrentValue()
                            onEditingChanged(true)
                        }).onEnded({ value in
                            lowViewModel.onEndedDrag()
                            updateCurrentValue()
                            onEditingChanged(false)
                        }))
                    
                    SliderHandleView(diamater: highViewModel.sliderDiameter, location: highViewModel.currentLocation)
                        .highPriorityGesture(DragGesture().onChanged({ value in
                            withAnimation(.spring(response: 0.1, dampingFraction: 1.0)) {
                                highViewModel.onChangedDrag(location: value.location)
                                updateLimitRange()
                            }
                            updateCurrentValue()
                            onEditingChanged(true)
                        }).onEnded({ value in
                            highViewModel.onEndedDrag()
                            updateCurrentValue()
                            onEditingChanged(false)
                        }))
                }
            )
    }
}
