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

struct VignetteTool: Tool {
    let icon = ImageAsset.Tools.vignette
//    private var filter = VignetteFilter(radius: 0.5)
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(
            name: "CIVignette",
            parameters: [
                "inputImage":  image,
                "inputRadius" : 0.5,
                "inputIntensity" : 2.0
            ]
        )
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        
        return filter.outputImage ?? image
    }
}

struct VignetteT {
    let apply: (CIImage) -> CIImage
    let name: String
    
    init<F: Filter>(_ filter: F) {
        apply = filter.apply
        name = filter.name
    }
}
