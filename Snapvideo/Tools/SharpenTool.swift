//
//  SharpenTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 11/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import CoreImage

struct SharpenTool: Tool {
    static func == (lhs: SharpenTool, rhs: SharpenTool) -> Bool {
      lhs.icon == rhs.icon
    }
  
    let icon = ImageAsset.Tools.details
    let name = "Details"
    
    private(set) var filter = SharpFilter(sharpness: 0)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension SharpenTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .sharpness:
            return filter.sharpness * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .sharpness:
            filter.sharpness = value / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .sharpness:
            return 0.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .sharpness:
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

extension SharpenTool {
    enum Parameter: String, CaseIterable {
        case sharpness
        
        var k: Double {
            switch self {
            case .sharpness:
              return 50.0
            }
        }
    }
}

extension SharpenTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension SharpenTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
