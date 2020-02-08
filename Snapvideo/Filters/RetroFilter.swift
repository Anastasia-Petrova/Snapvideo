//
//  RetroFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct RetroFilter: Filter {
    let name: String = "Retro"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIPhotoEffectTransfer")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage ?? image
    }
}
