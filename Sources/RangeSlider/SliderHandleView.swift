//
//  SliderHandleView.swift
//
//  Created by 鶴本賢太朗 on 2022/03/13.
//

import SwiftUI

struct SliderHandleView: View {
    let diamater: CGFloat
    
    let location: CGPoint
    
    var body: some View {
        Circle()
            .frame(width: diamater,
                   height: diamater)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 0)
            .contentShape(Rectangle())
            .position(x: location.x, y: location.y)
    }
}
