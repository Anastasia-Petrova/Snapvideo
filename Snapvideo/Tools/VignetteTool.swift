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
    let name: String = "vignette"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIVignette",
                                      parameters: [
                                        "inputImage":  image,
                                        "inputRadius" : 0.5,
                                        "inputIntensity" : 2.0
        ])
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        
        return filter.outputImage ?? image
    }
}
