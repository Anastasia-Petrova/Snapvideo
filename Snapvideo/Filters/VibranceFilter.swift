//
//  VibranceFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 09/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import CoreImage

struct VibranceFilter: Filter {
    let name: String = "Vibrance"
    var vibrance: Double
    
    func apply(image: CIImage) -> CIImage {
        let optionalSharpFilter = CIFilter(name: "CIVibrance")
        guard let sharpFilter = optionalSharpFilter else {
            return image
        }
        sharpFilter.setValue(image, forKey: kCIInputImageKey)
        sharpFilter.setValue(vibrance, forKey:kCIInputAmountKey)
        
        return sharpFilter.outputImage ?? image
    }
}

