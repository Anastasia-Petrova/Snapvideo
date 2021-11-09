//
//  StraightenFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 09/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import CoreImage

struct StraightenFilter: Filter {
    let name: String = "Straighten"
    var angle: Double
    
    func apply(image: CIImage) -> CIImage {
        let optionalSharpFilter = CIFilter(name: "CIStraightenFilter")
        guard let sharpFilter = optionalSharpFilter else {
            return image
        }
        sharpFilter.setValue(image, forKey: kCIInputImageKey)
        sharpFilter.setValue(angle, forKey:kCIInputAngleKey)
        
        return sharpFilter.outputImage ?? image
    }
}

