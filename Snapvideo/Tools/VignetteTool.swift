//
//  VignetteTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 11/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

struct VignetteTool: Tool {
    let icon = ImageAsset.Tools.vignette
    
    private var filter = VignetteFilter(radius: 0, intensity: 0)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension VignetteTool: Parameterized {
    typealias Value = Double
    
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .radius:
            return filter.radius * parameter.k
        case .intensity:
            return filter.intensity * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .radius:
            filter.radius = value / parameter.k
        case .intensity:
            filter.intensity = value / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .radius:
            return 0.0 * parameter.k
        case .intensity:
            return -1.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .radius:
            return 2.0 * parameter.k
        case .intensity:
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

extension VignetteTool {
    enum Parameter: String, CaseIterable {
        case radius
        case intensity
        
        var k: Double {
            switch self {
            case .radius:
                return 50.0
            case .intensity:
                return 100.0
            }
        }
    }
}

extension VignetteTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}
