//
//  SharpAndWarmFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct SharpAndWarmFilter: Filter {
    let name: String = "Warm"
    let inputSharpness: Double
    
    init(inputSharpness: Double) {
        self.inputSharpness = inputSharpness
    }
    
    func apply(image: CIImage) -> CIImage {
        let optionalSharpFilter = CIFilter(name: "CISharpenLuminance")
        guard let sharpFilter = optionalSharpFilter else {
            return image
        }
        sharpFilter.setValue(image, forKey: kCIInputImageKey)
        sharpFilter.setValue(inputSharpness, forKey:kCIInputSharpnessKey)
        guard let sharpImage = sharpFilter.outputImage else {
            return image
        }
        let optionalBrightFilter = CIFilter(name: "CIColorControls")
        guard let brightFilter = optionalBrightFilter else {
            return image
        }
        brightFilter.setValue(sharpImage, forKey: kCIInputImageKey)
        brightFilter.setValue(1.25, forKey: kCIInputContrastKey)
        guard let brightAndSharpImage = brightFilter.outputImage else {
            return image
        }
        let optionalTempFilter = CIFilter(name: "CITemperatureAndTint")
        guard let tempFilter = optionalTempFilter else {
            return image
        }
        tempFilter.setValue(brightAndSharpImage, forKey: kCIInputImageKey)
        tempFilter.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
        tempFilter.setValue(CIVector(x: 4000, y: 0), forKey: "inputTargetNeutral")
        return tempFilter.outputImage ?? image
    }
}


