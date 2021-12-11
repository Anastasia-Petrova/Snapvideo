//
//  ColorControlFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 31/12/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct ColorControlFilter: Filter, Equatable {
    let name: String = "Color Control"
    private let filter = CIFilter(name: "CIColorControls")!
    var inputSaturation: Double
    var inputBrightness: Double
    var inputContrast: Double
    
    func parameters(with image: CIImage) -> [String : Any] {
        [
            kCIInputImageKey:  image,
            kCIInputSaturationKey : NSNumber(floatLiteral: inputSaturation),
            kCIInputBrightnessKey : NSNumber(floatLiteral: inputBrightness),
            kCIInputContrastKey : NSNumber(floatLiteral: inputContrast)
        ]
    }
    
    func apply(image: CIImage) -> CIImage {
        filter.createOutputImage(for: parameters(with: image)) ?? image
    }
}

struct LightFilter: Filter, Equatable {
    let name: String = "Light Control"
    
    private var colorControlFilter = ColorControlFilter(
        inputSaturation: 1.0,
        inputBrightness: 0.0,
        inputContrast: 1.0
    )
    
    var inputBrightness: Double {
        get {
            colorControlFilter.inputBrightness
        }
        set {
            colorControlFilter.inputBrightness = newValue
        }
    }
    
    var inputContrast: Double {
        get {
            colorControlFilter.inputContrast
        }
        set {
            colorControlFilter.inputContrast = newValue
        }
    }
    
    func apply(image: CIImage) -> CIImage {
        colorControlFilter.apply(image: image)
    }
}
