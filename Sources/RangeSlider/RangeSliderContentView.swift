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
         bounds: ClosedRange<CGFloat>,
         tintColor: Color,
         unableTintColor: Color,
         onEditingChanged: @escaping (_ isHigh: Bool, _ isEditing: Bool) -> Void) {
        self.width = width
        self.tintColor = tintColor
        self.unableTintColor = unableTintColor
        _highValue = highValue
        _lowValue = lowValue
        self.onEditingChanged = onEditingChanged
        
        _lowViewModel = StateObject(wrappedValue: .init(sliderWidth: width, sliderHeight: RangeSliderContentView.sliderHeight, sliderDiameter: sliderDiameter, sliderValueRange: bounds, startValue: CGFloat(lowValue.wrappedValue)))
        _highViewModel = StateObject(wrappedValue: .init(sliderWidth: width, sliderHeight: RangeSliderContentView.sliderHeight, sliderDiameter: sliderDiameter, sliderValueRange: bounds, startValue: CGFloat(highValue.wrappedValue)))
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
