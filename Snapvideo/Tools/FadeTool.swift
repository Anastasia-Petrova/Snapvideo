//
//  FadeTool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 11/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

struct FadeTool {
    let icon = ImageAsset.Tools.fade
    let name = "Fade"
    
    func apply(image: CIImage) -> CIImage {
        return image
    }
}
