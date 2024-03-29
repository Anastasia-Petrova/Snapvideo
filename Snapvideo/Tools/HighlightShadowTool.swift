//
//  HighlightShadowTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 11/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

struct HighlightShadowTool: Tool {
    static func == (lhs: HighlightShadowTool, rhs: HighlightShadowTool) -> Bool {
      lhs.icon == rhs.icon
    }
  
    let icon = ImageAsset.Tools.highlights
    let name = "Tonal Contrast"
    
    private(set) var filter = HighlightShadowFilter(highlight: 1, shadow: 0, radius: 0)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension HighlightShadowTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .highlight:
            return filter.highlight * parameter.k
        case .radius:
            return filter.radius * parameter.k
        case .shadow:
            return filter.shadow * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .highlight:
            filter.highlight = value / parameter.k
        case .radius:
            filter.radius = value / parameter.k
        case .shadow:
            filter.shadow = value / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .highlight, .radius:
            return 0.0 * parameter.k
        case .shadow:
            return -1.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .highlight,
                .shadow:
            return 1.0 * parameter.k
        case .radius:
            return 10.0 * parameter.k
        }
    }
    
    func process(input: Double, for parameter: Parameter) -> Double {
        input / parameter.k
    }
    
    func process(output: Double, for parameter: Parameter) -> Double {
        output * parameter.k
    }
}

extension HighlightShadowTool {
    enum Parameter: String, CaseIterable {
        case highlight
        case shadow
        case radius
        
        var k: Double {
            switch self {
            case .highlight,
                    .shadow:
                return 100.0
                
            case .radius:
                return 10.0
            }
        }
    }
}

extension HighlightShadowTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension HighlightShadowTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
