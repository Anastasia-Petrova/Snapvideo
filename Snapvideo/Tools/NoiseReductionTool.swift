//
//  NoiseReductionTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 09/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

struct NoiseReductionTool: Tool {
    static func == (lhs: NoiseReductionTool, rhs: NoiseReductionTool) -> Bool {
      lhs.icon == rhs.icon
    }
  
    let icon = ImageAsset.Tools.details
    
    private(set) var filter = NoiseReductionFilter(noise: 0, sharpness: 0)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension NoiseReductionTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .noise:
            return filter.noise * parameter.k
        case .sharpness:
            return filter.sharpness * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .noise:
            filter.noise = value / parameter.k
        case .sharpness:
            filter.sharpness = value / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .noise, .sharpness:
            return 0.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .noise, .sharpness:
            return 2.0 * parameter.k
        }
    }
    
    func process(input: Double, for parameter: Parameter) -> Double {
        input / parameter.k
    }
    
    func process(output: Double, for parameter: Parameter) -> Double {
        output * parameter.k
    }
}

extension NoiseReductionTool {
    enum Parameter: String, CaseIterable {
        case noise
        case sharpness
        
        var k: Double {
            switch self {
            case .noise, .sharpness:
                return 50.0
            }
        }
    }
}

extension NoiseReductionTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension NoiseReductionTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}

