//
//  SharpFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 08/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import CoreImage

struct SharpFilter: Filter {
    let name: String = "Sharp"
    var sharpness: Double
    
    init(sharpness: Double) {
        self.sharpness = sharpness
    }
    
    func apply(image: CIImage) -> CIImage {
        let optionalSharpFilter = CIFilter(name: "CISharpenLuminance")
        guard let sharpFilter = optionalSharpFilter else {
            return image
        }
        sharpFilter.setValue(image, forKey: kCIInputImageKey)
        sharpFilter.setValue(sharpness, forKey:kCIInputSharpnessKey)
        
        return sharpFilter.outputImage ?? image
    }
}
