//
//  BlurFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct BlurFilter: Filter {
    let name: String = "Blur"
    let blurRadius: Double
    
    func apply(image: CIImage) -> CIImage {
        return image.clampedToExtent().applyingGaussianBlur(sigma: blurRadius).cropped(to: image.extent)
    }
}
