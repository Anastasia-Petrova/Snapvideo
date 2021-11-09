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
    
    private(set) var filter = VibranceFilter(vibrance: 0)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension VibranceTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .vibrance:
            return filter.vibrance * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .vibrance:
            filter.vibrance = value / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .vibrance:
            return -1.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .vibrance:
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
        
        var k: Double {
            switch self {
            case .vibrance:
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
