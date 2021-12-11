//
//  VibranceTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 09/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

struct VibranceTool: Tool {
    static func == (lhs: VibranceTool, rhs: VibranceTool) -> Bool {
      lhs.icon == rhs.icon
    }
  
    let icon = ImageAsset.Tools.vibrance
    let name = "Color"
    
    var filter: CompositeFilter {
        vibranceFilter + saturationFilter
    }
    
    private(set) var vibranceFilter = VibranceFilter(vibrance: 0)
    
    private(set) var saturationFilter = SaturationFilter()
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension VibranceTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .vibrance:
            return vibranceFilter.vibrance * parameter.k
        case .saturation:
            return (saturationFilter.inputSaturation - 1) * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .vibrance:
            vibranceFilter.vibrance = value / parameter.k
        case .saturation:
            saturationFilter.inputSaturation = value / parameter.k + 1
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .vibrance:
            return -1.0 * parameter.k
        case .saturation:
            return -1.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .vibrance:
            return 1.0 * parameter.k
        case .saturation:
            return 1.0 * parameter.k
        }
    }
    
    func process(input: Double, for parameter: Parameter) -> Double {
        input / parameter.k
    }
    
    func process(output: Double, for parameter: Parameter) -> Double {
        output * parameter.k
    }
}

extension VibranceTool {
    enum Parameter: String, CaseIterable {
        case vibrance
        case saturation
        
        var k: Double {
            switch self {
            case .vibrance:
                return 100.0
            case .saturation:
                return 100.0
            }
        }
    }
}

extension VibranceTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension VibranceTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
