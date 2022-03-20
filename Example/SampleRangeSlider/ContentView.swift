//
//  ContentView.swift
//  SampleRangeSlider
//
//  Created by 鶴本賢太朗 on 2022/03/18.
//

import SwiftUI

struct ContentView: View {
    @State var currentValue: ClosedRange<Float> = 200...400
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            RangeSlider(currentValue: $currentValue,
                        bounds: 100...500,
                        onEditingChanged: { isEditing in
                let editStr = isEditing ? "editing" : "ended"
                print("\(currentValue)" + " " + editStr)
            })
            
            HStack {
                Text(String(format: "%.2f", currentValue.lowerBound))
                Spacer()
                Text(String(format: "%.2f", currentValue.upperBound))
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
