//
//  AssetImageGenerator.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import AVFoundation
import UIKit

struct AssetImageGenerator {
    static func getThumbnailImageFromVideoAsset(
        asset: AVAsset,
        maximumSize: CGSize = .zero,
        queue: DispatchQueue = .global(),
        completion: @escaping (UIImage?) -> Void
    ) {
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        avAssetImageGenerator.maximumSize = maximumSize
        avAssetImageGenerator.appliesPreferredTrackTransform = true
        avAssetImageGenerator.requestedTimeToleranceBefore = .zero
        
        queue.async {
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: .zero, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                completion(thumbImage)
            } catch {
                completion(nil)
            }
        }
    }
}
