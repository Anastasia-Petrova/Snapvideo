//
//  VintageFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct VintageFilter: Filter {
    let name: String = "Vintage"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIPhotoEffectInstant")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage ?? image
    }
}
