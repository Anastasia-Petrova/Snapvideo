//
//  ExposureTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 08/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import CoreImage

struct ExposureTool: Tool {
    static func == (lhs: ExposureTool, rhs: ExposureTool) -> Bool {
      lhs.icon == rhs.icon
    }
  
    let icon = ImageAsset.Tools.exposure
    let name = "Exposure"
    
    private(set) var filter = ExposureFilter(exposure: 0)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension ExposureTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .exposure:
            return filter.exposure * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .exposure:
            filter.exposure = value / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .exposure:
            return -1.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .exposure:
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

extension ExposureTool {
    enum Parameter: String, CaseIterable {
        case exposure
        
        var k: Double {
            switch self {
            case .exposure:
                return 100.0
            }
        }
    }
}

extension ExposureTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension ExposureTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
