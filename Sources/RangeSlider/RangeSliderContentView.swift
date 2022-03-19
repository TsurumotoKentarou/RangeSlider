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
    
    let isOverRange: Bool
    
    let tintColor: Color
    
    let unableTintColor: Color
    
    let onEditingChanged: (_ isHigh: Bool, _ isEditing: Bool) -> Void
    
    static let sliderHeight: CGFloat = 4.0
    
    @StateObject var lowViewModel: SliderHandleViewModel
    
    @StateObject var highViewModel: SliderHandleViewModel
    
    init(currentValue: Binding<ClosedRange<Float>>,
         width: CGFloat,
         sliderDiameter: CGFloat,
         sliderValueRange: ClosedRange<Float>,
         isOverRange: Bool,
         tintColor: Color,
         unableTintColor: Color,
         onEditingChanged: @escaping (_ isHigh: Bool, _ isEditing: Bool) -> Void) {
        _currentValue = currentValue
        self.width = width
        self.tintColor = tintColor
        self.sliderValueRange = sliderValueRange
        self.isOverRange = isOverRange
        self.unableTintColor = unableTintColor

        self.onEditingChanged = onEditingChanged
        
        let lowUpper = isOverRange ? CGFloat(sliderValueRange.upperBound) : CGFloat(currentValue.wrappedValue.upperBound)
        let lowLower = CGFloat(sliderValueRange.lowerBound)
        let highUpper = CGFloat(sliderValueRange.upperBound)
        let highLower = isOverRange ? CGFloat(sliderValueRange.lowerBound) : CGFloat(currentValue.wrappedValue.lowerBound)
        
        _lowViewModel = StateObject(wrappedValue: .init(sliderWidth: width,
                                                        sliderHeight: RangeSliderContentView.sliderHeight,
                                                        sliderDiameter: sliderDiameter,
                                                        service: SliderHandleServiceImpl(),
                                                        sliderValueRange: CGFloat(sliderValueRange.lowerBound)...CGFloat(sliderValueRange.upperBound),
                                                        sliderValueLimitRange: lowLower...lowUpper,
                                                        startValue: CGFloat(currentValue.wrappedValue.lowerBound)))
        
        _highViewModel = StateObject(wrappedValue: .init(sliderWidth: width,
                                                         sliderHeight: RangeSliderContentView.sliderHeight,
                                                         sliderDiameter: sliderDiameter,
                                                         service: SliderHandleServiceImpl(),
                                                         sliderValueRange: CGFloat(sliderValueRange.lowerBound)...CGFloat(sliderValueRange.upperBound),
                                                         sliderValueLimitRange: highLower...highUpper,
                                                         startValue: CGFloat(currentValue.wrappedValue.upperBound)))
    }
    
    private func updateLimitRange() {
        let lowUpper = isOverRange ? CGFloat(sliderValueRange.upperBound) : CGFloat(currentValue.upperBound)
        let lowLower = CGFloat(sliderValueRange.lowerBound)
        let highUpper = CGFloat(sliderValueRange.upperBound)
        let highLower = isOverRange ? CGFloat(sliderValueRange.lowerBound) : CGFloat(currentValue.lowerBound)
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
                    
                    SliderHandleView(viewModel: lowViewModel)
                        .highPriorityGesture(DragGesture().onChanged({ value in
                            withAnimation(.spring(response: 0.1, dampingFraction: 1.0)) {
                                lowViewModel.onChangedDrag(location: value.location)
                                updateLimitRange()
                            }
                            updateCurrentValue()
                            onEditingChanged(false, true)
                        }).onEnded({ value in
                            lowViewModel.onEndedDrag()
                            updateCurrentValue()
                            onEditingChanged(false, false)
                        }))
                    
                    SliderHandleView(viewModel: highViewModel)
                        .highPriorityGesture(DragGesture().onChanged({ value in
                            withAnimation(.spring(response: 0.1, dampingFraction: 1.0)) {
                                highViewModel.onChangedDrag(location: value.location)
                                updateLimitRange()
                            }
                            updateCurrentValue()
                            onEditingChanged(true, true)
                        }).onEnded({ value in
                            highViewModel.onEndedDrag()
                            updateCurrentValue()
                            onEditingChanged(true, false)
                        }))
                }
            )
    }
}
