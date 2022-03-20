Range Slider
====

This package is a slider that can stand for range using two Sliders created by SwiftUI.

## Description

A slider that can stand for range using two Sliders.

### Features

* Use two sliders to represent a range

## Demo
![demo](https://user-images.githubusercontent.com/15685633/159162771-3a7d829e-6b4b-4e6f-89b4-2627fdcdad14.gif)

## Requirement
iOS 14 or later.

## Usage

``` swift
@State var currentValue: ClosedRange<Float> = 200...400
    
RangeSlider(currentValue: $currentValue,
            bounds: 100...500,
            onEditingChanged: { isEditing in
    // `isEditing` represent whether editing is in progress
})
```

## Install
Add it in the latest main branch in **Swift Package Manager**.

## Licence

```
Copyright 2022 Kentaro Tsurumoto.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

## Author

[Tsuruken](https://github.com/tsuruken0802)
