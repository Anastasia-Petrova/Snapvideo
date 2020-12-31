//
//  ColourCorrectionTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 31/12/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct ColourCorrectionTool: Tool {
    let icon = ImageAsset.Tools.tune
    
    var filter: CompositeFilter {
        temperatureFilter + colourControlFilter
    }
    
    private(set) var temperatureFilter = TemperatureAndTintFilter(
        inputNeutral: 6500,
        targetNeutral: 4500
    )
    
    private(set) var colourControlFilter = ColorControlFilter(
        inputSaturation: 0.0,
        inputBrightness: 0.0,
        inputContrast: 0.0
    )
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension ColourCorrectionTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .warmth:
            return Double(temperatureFilter.inputNeutral) / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .warmth:
            return 0
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .warmth:
            return parameter.k * 100.0
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .warmth:
            let newValue = CGFloat(value * parameter.k)
            temperatureFilter.inputNeutral = newValue
            temperatureFilter.targetNeutral = newValue
        }
    }
}

extension ColourCorrectionTool {
    enum Parameter: String, CaseIterable {
        case warmth
        
        var k: Double {
            switch self {
            case .warmth:
                return 65.0
            }
        }
    }
}

extension ColourCorrectionTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension ColourCorrectionTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
