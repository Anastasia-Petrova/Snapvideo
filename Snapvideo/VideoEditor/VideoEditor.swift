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
    
    static func saveEditedVideo(choosenFilter: AnyFilter, asset: AVAsset, completion: @escaping () -> Void ) {
        let composition = setUpComposition(choosenFilter: choosenFilter, asset: asset)
        performExport(asset: asset, composition: composition) { exportUrl in
            guard let exportUrl = exportUrl else {
                completion()
                return
            }
            saveToPhotoLibrary(exportUrl, completion: completion)
        }
    }
    
    static func saveToPhotoLibrary(_ exportUrl: URL, completion: @escaping () -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportUrl)
        }) { saved, error in
            if saved {
                let appDelegate = AppDelegate()
                appDelegate.scheduleNotification(title: "Success!", body: "Video was saved.")
            } else {
                let appDelegate = AppDelegate()
                appDelegate.scheduleNotification(title: "Error!", body: "Video was not saved. Try again.")
            }
            completion()
        }
    }
    
    static func composeVideo(choosenFilter: AnyFilter, asset: AVAsset, completion: @escaping (URL?) -> Void ) {
        let composition = setUpComposition(choosenFilter: choosenFilter, asset: asset)
        performExport(asset: asset, composition: composition) { exportPath in
            completion(exportPath)
        }
    }
    
    static func performExport(
        asset: AVAsset,
        composition: AVVideoComposition,
        completion: @escaping (URL?) -> Void
    ) {
        guard let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil)
            return
        }
        export.outputFileType = AVFileType.mov
        let exportPath = NSTemporaryDirectory().appendingFormat("/\(UUID().uuidString).mov")
        let exportUrl = URL(fileURLWithPath: exportPath)
        export.outputURL = exportUrl
        export.videoComposition = composition
        export.exportAsynchronously {
            completion(exportUrl)
        }
    }
    
    static func getVideoData(url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }
}
