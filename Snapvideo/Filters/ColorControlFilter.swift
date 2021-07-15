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
            kCIInputBrightnessKey : NSNumber(floatLiteral:inputBrightness),
            kCIInputContrastKey : NSNumber(floatLiteral:inputContrast)
        ]
    }
    
    func apply(image: CIImage) -> CIImage {
        filter.createOutputImage(for: parameters(with: image)) ?? image
    }
}
