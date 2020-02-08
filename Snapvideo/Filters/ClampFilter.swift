//
//  ClampFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct ClampFilter: Filter {
    let name: String = "Clamp"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIColorClamp")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(CIVector(x: 0.1, y: 0.0, z: 0.1, w: 0), forKey: "inputMinComponents")
        filter.setValue(CIVector(x: 0.8, y: 0.8, z: 0.8, w: 0.8), forKey: "inputMaxComponents")
        return filter.outputImage ?? image
    }
}

