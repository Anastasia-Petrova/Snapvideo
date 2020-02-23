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

protocol Parameterized {
    associatedtype Parameter: CustomStringConvertible
    associatedtype Value
    
    var allParameters: [Parameter] { get }
    
    func value(for parameter: Parameter) -> Value
    
    func minValue(for parameter: Parameter) -> Value
    
    func maxValue(for parameter: Parameter) -> Value
    
    mutating func setValue(value: Value, for parameter: Parameter)
}

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
            return filter.radius
        case .intensity:
            return filter.intensity
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .radius:
            filter.radius = value
        case .intensity:
            filter.intensity = value
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .radius:
            return 0.0
        case .intensity:
            return -1.0
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .radius:
            return 2.0
        case .intensity:
            return 1.0
        }
    }
}

extension VignetteTool {
    enum Parameter: String, CaseIterable {
        case radius
        case intensity
    }
}

extension VignetteTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}
