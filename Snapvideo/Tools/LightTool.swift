//
//  ColourCorrectionTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 31/12/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct LightTool: Tool {
    let icon = ImageAsset.Tools.tune
    
    var filter: CompositeFilter {
        temperatureFilter + lightFilter
    }
    
    private(set) var temperatureFilter = TemperatureAndTintFilter()
    
    private(set) var lightFilter = LightFilter()
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension LightTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .brightness:
            return Double(lightFilter.inputBrightness) * parameter.k
        case .contrast:
            let value = lightFilter.inputContrast
            switch value {
            case 1:
                return 0
            case 0..<1:
                return -100 + value * 100.0
            case 1...2:
                return value * 100.0 - 100
            default:
                fatalError("shouldn't be allowed. Check your logic")
            }
            
        case .warmth:
            let value = Double(temperatureFilter.targetNeutral)
            let start: Double
            let divident: Double
            let divisor: Double
            
            switch value {
            case TemperatureAndTintFilter.min...TemperatureAndTintFilter.mid:
                divident = TemperatureAndTintFilter.min - value
                divisor = (TemperatureAndTintFilter.mid - TemperatureAndTintFilter.min)/100.0
                start = 100
                
            case TemperatureAndTintFilter.mid...TemperatureAndTintFilter.max:
                divident = TemperatureAndTintFilter.max - value
                divisor = (TemperatureAndTintFilter.max - TemperatureAndTintFilter.mid)/100.0
                start = -100.0
                
            default:
                fatalError("shouldn't be allowed. Check your logic")
            }
            
            return start + divident / divisor
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .brightness:
            return -1.0 * parameter.k
        case .contrast:
            return -100.0
        case .warmth:
            return -100.0
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .brightness:
            return 1.0 * parameter.k
        case .contrast:
            return 100.0
        case .warmth:
            return 100.0
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .warmth:
            let start: Double
            let multiplier1: Double
            let multiplier2: Double

            switch value {
            case 0...100:
                start = TemperatureAndTintFilter.min
                multiplier1 = 100.0 - value
                multiplier2 = TemperatureAndTintFilter.mid - TemperatureAndTintFilter.min
                
            case -100...0:
                start = TemperatureAndTintFilter.mid
                multiplier1 = 0.0 - value
                multiplier2 = TemperatureAndTintFilter.max - TemperatureAndTintFilter.mid
                
            default:
                fatalError("shouldn't be allowed. Check your logic")
            }
            temperatureFilter.targetNeutral = CGFloat(start + (multiplier1 * multiplier2) / 100.0)
            
        case .brightness:
            lightFilter.inputBrightness = value / parameter.k
        case .contrast:
            if value == 0 {
                lightFilter.inputContrast = 1
            } else if value > 0 {
                lightFilter.inputContrast = 1 + value / 100.0
            } else {
                lightFilter.inputContrast = 1 + value / 100.0
            }
        }
    }
}

extension LightTool {
    enum Parameter: String, CaseIterable {
        case brightness
        case contrast
        case warmth
        
        var k: Double {
            switch self {
            case .brightness:
                return 100.0
            case .contrast:
                fatalError("should be implemented")
            case .warmth:
                return 65.0
            }
        }
    }
}

extension LightTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension LightTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
