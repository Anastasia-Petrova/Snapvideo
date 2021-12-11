//
//  HighlightShadowFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 09/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct HighlightShadowFilter: Filter {
    let name: String = "HighlightShadow"
    var highlight: Double
    var shadow: Double
    var radius: Double
    
    func apply(image: CIImage) -> CIImage {
        let optionalHighlightShadowFilter = CIFilter(name: "CIHighlightShadowAdjust")
        guard let highlightShadowFilter = optionalHighlightShadowFilter else {
            return image
        }
        highlightShadowFilter.setValue(image, forKey: kCIInputImageKey)
        highlightShadowFilter.setValue(highlight, forKey: "inputHighlightAmount")
        highlightShadowFilter.setValue(shadow, forKey: "inputShadowAmount")
        highlightShadowFilter.setValue(radius, forKey: kCIInputRadiusKey)
      
        return highlightShadowFilter.outputImage ?? image
    }
}

