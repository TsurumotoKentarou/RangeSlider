//
//  SliderPathView.swift
//
//  Created by 鶴本賢太朗 on 2022/03/13.
//

import SwiftUI

@available(iOS 14.0, *)
struct SliderPathView: View {
    let currentHighLocation: CGPoint
    
    let currentLowLocation: CGPoint
    
    let height: CGFloat
    
    let tintColor: Color
    
    var body: some View {
        Path { path in
            path.move(to: currentLowLocation)
            path.addLine(to: currentHighLocation)
        }
        .stroke(tintColor, lineWidth: height)
    }
}
