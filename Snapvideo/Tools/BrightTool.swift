//
//  SharpTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 11/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

struct BrightTool {
    let icon = ImageAsset.Tools.bright
    let inputSharpness: Double = 1.0
    
    func apply(image: CIImage) -> CIImage {
        let optionalBrightFilter = CIFilter(name: "CIColorControls")
        guard let brightFilter = optionalBrightFilter else {
            return image
        }
        brightFilter.setValue(image, forKey: kCIInputImageKey)
        brightFilter.setValue(inputSharpness, forKey: kCIInputContrastKey)
        
        return brightFilter.outputImage ?? image
    }
}
