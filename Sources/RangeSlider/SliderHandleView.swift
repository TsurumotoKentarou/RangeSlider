//
//  SliderHandleView.swift
//
//  Created by 鶴本賢太朗 on 2022/03/13.
//

import SwiftUI

@available(iOS 14.0, *)
struct SliderHandleView: View {
    @StateObject var viewModel: SliderHandleViewModel
    
    var body: some View {
        Circle()
            .frame(width: SliderHandleViewModel.diameter, height: SliderHandleViewModel.diameter)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 0)
            .contentShape(Rectangle())
            .position(x: viewModel.currentLocation.x, y: viewModel.currentLocation.y)
    }
}
