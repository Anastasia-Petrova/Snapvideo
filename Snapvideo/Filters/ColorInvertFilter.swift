//
//  ColorInvertFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct ColorInvertFilter: Filter {
    let name: String = "ColorInvert"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIColorInvert")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage ?? image
    }
}
