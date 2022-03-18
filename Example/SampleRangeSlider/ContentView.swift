//
//  ContentView.swift
//  SampleRangeSlider
//
//  Created by 鶴本賢太朗 on 2022/03/18.
//

import SwiftUI

struct ContentView: View {
    @State var highValue: Float = 0.0
    @State var lowValue: Float = 0.0
    
    var body: some View {
        VStack {
            RangeSlider(highValue: $highValue, lowValue: $lowValue, bounds: 0...300, onEditingChanged: { isHigh, isEditing in
                let highStr = isHigh ? "high" : "low"
                let editStr = isEditing ? "editing" : "ended"
                let value = isHigh ? highValue : lowValue
                print(highStr + " " + editStr + " \(value)")
            })
            
            Slider(value: .constant(0.5))
            
            HStack {
                Text(String(format: "%.2f", lowValue))
                Spacer()
                Text(String(format: "%.2f", highValue))
            }
        }
        .padding(.horizontal, 50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
