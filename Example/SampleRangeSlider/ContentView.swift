//
//  ContentView.swift
//  SampleRangeSlider
//
//  Created by 鶴本賢太朗 on 2022/03/18.
//

import SwiftUI

struct ContentView: View {
    @State var highValue: Float = 400
    @State var lowValue: Float = 100
    @State var isOverRange: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            RangeSlider(highValue: $highValue,
                        lowValue: $lowValue,
                        bounds: 200...300,
                        isOverRange: isOverRange,
                        onEditingChanged: { isHigh, isEditing in
                let highStr = isHigh ? "high" : "low"
                let editStr = isEditing ? "editing" : "ended"
                let value = isHigh ? highValue : lowValue
                print(highStr + " " + editStr + " \(value)")
            })
            
            HStack {
                Text(String(format: "%.2f", lowValue))
                Spacer()
                Text(String(format: "%.2f", highValue))
            }
            
            
            Toggle("is over range:", isOn: $isOverRange)
        }
        .padding(.horizontal, 50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
