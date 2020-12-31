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
        case .brightness:
            return Double(colourControlFilter.inputBrightness) / parameter.k
        case .contrast:
            return Double(colourControlFilter.inputContrast) / parameter.k
        case .saturation:
            return Double(colourControlFilter.inputSaturation) / parameter.k
        case .warmth:
            return Double(temperatureFilter.inputNeutral) / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .brightness:
            return -1.0
        case .contrast:
            return 0.0
        case .saturation:
            return 0.0
        case .warmth:
            return 0.0
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .brightness:
            return parameter.k * 100.0
        case .contrast:
            return parameter.k * 100.0
        case .saturation:
            return parameter.k * 100.0
        case .warmth:
            return parameter.k * 100.0
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        let newValue = value * parameter.k
        switch parameter {
        case .warmth:
            temperatureFilter.inputNeutral = CGFloat(newValue)
            temperatureFilter.targetNeutral = CGFloat(newValue)
        case .saturation:
            colourControlFilter.inputSaturation = newValue
        case .brightness:
            colourControlFilter.inputBrightness = newValue
        case .contrast:
            colourControlFilter.inputContrast = newValue
        }
    }
}

extension ColourCorrectionTool {
    enum Parameter: String, CaseIterable {
        case brightness
        case contrast
        case saturation
        case warmth
        
        var k: Double {
            switch self {
            case .brightness:
                return 0.01
            case .contrast:
                return 0.01
            case .saturation:
                return 0.01
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
