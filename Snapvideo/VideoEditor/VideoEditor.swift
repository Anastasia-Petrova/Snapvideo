//
//  VideoEditor.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

struct VideoEditor {
    static func setUpComposition(choosenFilter: AnyFilter, asset: AVAsset ) -> AVVideoComposition {
        return AVVideoComposition(asset: asset) { (request) in
            let source = request.sourceImage.clampedToExtent()
            let filteredImage = choosenFilter
                .apply(source)
                .cropped(to: request.sourceImage.extent)
            request.finish(with: filteredImage, context: nil)
        }
    }

    static func saveEditedVideo(choosenFilter: AnyFilter, asset: AVAsset ) {
        let composition = setUpComposition(choosenFilter: choosenFilter, asset: asset)
        guard let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            return
        }
        export.outputFileType = AVFileType.mov
        let exportPath = NSTemporaryDirectory().appendingFormat("/\(UUID().uuidString).mov")
        let exportUrl = URL(fileURLWithPath: exportPath)
        export.outputURL = exportUrl
        export.videoComposition = composition
        export.exportAsynchronously(completionHandler: {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportUrl)
            }) { saved, error in
                if saved {
                    let appDelegate = AppDelegate()
                    appDelegate.scheduleNotification()
                }
            }
        })
    }
    
    static func composeVideo(choosenFilter: AnyFilter, asset: AVAsset, completion: @escaping (String?) -> Void ) {
        let composition = setUpComposition(choosenFilter: choosenFilter, asset: asset)
        guard let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            return completion(nil)
        }
        export.outputFileType = AVFileType.mov
        let exportPath = NSTemporaryDirectory().appendingFormat("/\(UUID().uuidString).mov")
        let exportUrl = URL(fileURLWithPath: exportPath)
        export.outputURL = exportUrl
        export.videoComposition = composition
        export.exportAsynchronously(completionHandler: {
            completion(exportPath)
        })
    }
}
