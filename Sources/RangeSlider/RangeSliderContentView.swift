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
    
    let onEditingChanged: (_ isHigh: Bool, _ isEditing: Bool) -> Void
    
    static let sliderHeight: CGFloat = 4.0
    
    @StateObject var lowViewModel: SliderHandleViewModel
    
    @StateObject var highViewModel: SliderHandleViewModel
    
    init(currentHighPosition: Binding<Float>, currentLowPosition: Binding<Float>, width: CGFloat, bounds: ClosedRange<Float>,  onEditingChanged:  @escaping (_ isHigh: Bool, _ isEditing: Bool) -> Void) {
        self.width = width
        _highValue = currentHighPosition
        _lowValue = currentLowPosition
        self.onEditingChanged = onEditingChanged
        
        _lowViewModel = StateObject(wrappedValue: .init(sliderWidth: width, sliderHeight: RangeSliderContentView.sliderHeight, sliderRange: bounds, startLocation: 0))
        _highViewModel = StateObject(wrappedValue: .init(sliderWidth: width, sliderHeight: RangeSliderContentView.sliderHeight, sliderRange: bounds, startLocation: width))
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.1))
            .frame(width: width, height: RangeSliderContentView.sliderHeight)
            .overlay(
                ZStack() {
                    SliderPathView(currentHighLocation: highViewModel.currentLocation, currentLowLocation: lowViewModel.currentLocation, height: RangeSliderContentView.sliderHeight)
                    
                    SliderHandleView(viewModel: lowViewModel)
                        .highPriorityGesture(DragGesture().onChanged({ value in
                            lowViewModel.onChangedDrag(location: value.location)
                            lowValue = lowViewModel.currentValue
                            onEditingChanged(false, true)
                        }).onEnded({ value in
                            lowViewModel.onEndedDrag()
                            lowValue = lowViewModel.currentValue
                            onEditingChanged(false, false)
                        }))
                    
                    SliderHandleView(viewModel: highViewModel)
                        .highPriorityGesture(DragGesture().onChanged({ value in
                            highViewModel.onChangedDrag(location: value.location)
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