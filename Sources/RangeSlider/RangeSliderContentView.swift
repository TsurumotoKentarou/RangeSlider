//
//  RangeSliderContentView.swift
//
//  Created by 鶴本賢太朗 on 2022/03/18.
//

import SwiftUI

@available(iOS 14.0, *)
struct RangeSliderContentView: View {
    @Binding var highValue: Float
    
    @Binding var lowValue: Float
    
    let width: CGFloat
    
    let sliderValueRange: ClosedRange<CGFloat>
    
    let isOverRange: Bool
    
    let tintColor: Color
    
    let unableTintColor: Color
    
    let onEditingChanged: (_ isHigh: Bool, _ isEditing: Bool) -> Void
    
    static let sliderHeight: CGFloat = 4.0
    
    @StateObject var lowViewModel: SliderHandleViewModel
    
    @StateObject var highViewModel: SliderHandleViewModel
    
    init(highValue: Binding<Float>,
         lowValue: Binding<Float>,
         width: CGFloat,
         sliderDiameter: CGFloat,
         sliderValueRange: ClosedRange<CGFloat>,
         isOverRange: Bool,
         tintColor: Color,
         unableTintColor: Color,
         onEditingChanged: @escaping (_ isHigh: Bool, _ isEditing: Bool) -> Void) {
        self.width = width
        self.tintColor = tintColor
        self.sliderValueRange = sliderValueRange
        self.isOverRange = isOverRange
        self.unableTintColor = unableTintColor
        _highValue = highValue
        _lowValue = lowValue
        self.onEditingChanged = onEditingChanged
        
        let lowUpper = isOverRange ? sliderValueRange.upperBound: CGFloat(highValue.wrappedValue)
        let lowLower = isOverRange ? sliderValueRange.lowerBound: sliderValueRange.lowerBound
        let highUpper = isOverRange ? sliderValueRange.upperBound: sliderValueRange.upperBound
        let highLower = isOverRange ? sliderValueRange.lowerBound: CGFloat(lowValue.wrappedValue)
        
        _lowViewModel = StateObject(wrappedValue: .init(sliderWidth: width,
                                                        sliderHeight: RangeSliderContentView.sliderHeight,
                                                        sliderDiameter: sliderDiameter,
                                                        sliderValueRange: sliderValueRange,
                                                        sliderValueLimitRange: lowLower...lowUpper,
                                                        startValue: CGFloat(lowValue.wrappedValue)))
        _highViewModel = StateObject(wrappedValue: .init(sliderWidth: width,
                                                         sliderHeight: RangeSliderContentView.sliderHeight,
                                                         sliderDiameter: sliderDiameter,
                                                         sliderValueRange: sliderValueRange,
                                                         sliderValueLimitRange: highLower...highUpper,
                                                         startValue: CGFloat(highValue.wrappedValue)))
    }
    
    private func updateLimitRange() {
        let lowUpper = isOverRange ? sliderValueRange.upperBound: CGFloat(highValue)
        let lowLower = isOverRange ? sliderValueRange.lowerBound: sliderValueRange.lowerBound
        let highUpper = isOverRange ? sliderValueRange.upperBound: sliderValueRange.upperBound
        let highLower = isOverRange ? sliderValueRange.lowerBound: CGFloat(lowValue)
        lowViewModel.sliderValueLimitRange = lowLower...lowUpper
        highViewModel.sliderValueLimitRange = highLower...highUpper
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
                            lowValue = lowViewModel.currentValue
                            onEditingChanged(false, true)
                        }).onEnded({ value in
                            lowViewModel.onEndedDrag()
                            lowValue = lowViewModel.currentValue
                            onEditingChanged(false, false)
                        }))
                    
                    SliderHandleView(viewModel: highViewModel)
                        .highPriorityGesture(DragGesture().onChanged({ value in
                            withAnimation(.spring(response: 0.1, dampingFraction: 1.0)) {
                                highViewModel.onChangedDrag(location: value.location)
                                updateLimitRange()
                            }
                            highValue = highViewModel.currentValue
                            onEditingChanged(true, true)
                        }).onEnded({ value in
                            highViewModel.onEndedDrag()
                            highValue = highViewModel.currentValue
                            onEditingChanged(true, false)
                        }))
                }
            )
    }
}
