//
//  CropTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 11/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

struct CropTool: Tool {
    static func == (lhs: CropTool, rhs: CropTool) -> Bool {
      lhs.icon == rhs.icon
    }
  
    let icon = ImageAsset.Tools.crop
    
  private(set) var filter = CropFilter(x: 0, y: 0, width: 700, height: 1400)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension CropTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .x:
          return Double(filter.x) * parameter.k
        case .y:
          return Double(filter.y) * parameter.k
        case .width:
          return Double(filter.width) * parameter.k
        case .heigh:
          return Double(filter.height) * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .x:
          filter.x = CGFloat(value / parameter.k)
        case .y:
          filter.y = CGFloat(value / parameter.k)
        case .width:
          filter.width = CGFloat(value / parameter.k) * 350
        case .heigh:
          filter.height = CGFloat(value / parameter.k) * 700
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .x:
          return 0.0 * parameter.k
        case .y:
          return 0.0 * parameter.k
        case .width:
          return 0.0 * parameter.k
        case .heigh:
          return 0.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .x:
          return 2.0 * parameter.k
        case .y:
          return 2.0 * parameter.k
        case .width:
          return 2.0 * parameter.k
        case .heigh:
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

extension CropTool {
    enum Parameter: String, CaseIterable {
        case x
        case y
        case width
        case heigh
      
        var k: Double {
            switch self {
            case .x:
                return 50.0
            case .y:
                return 50.0
            case .width:
              return 50.0
            case .heigh:
              return 50.0
            }
        }
    }
}

extension CropTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension CropTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
