//
//  MonochromeFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct MonochromeFilter: Filter {
    let name: String = "Monochrome"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIColorMonochrome")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5), forKey: "inputColor")
        filter.setValue(1.0, forKey: "inputIntensity")
        return filter.outputImage ?? image
    }
}
