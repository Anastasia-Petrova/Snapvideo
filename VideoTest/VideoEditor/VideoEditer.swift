import Foundation
import AVFoundation
import Photos

struct VideoEditer {
    
    static func saveEditedVideo(choosenFilter: AnyFilter, asset: AVAsset ) {
        let composition = AVVideoComposition(asset: asset) { (request) in
            let source = request.sourceImage.clampedToExtent()
            let filteredImage = choosenFilter.apply(source).cropped(to: request.sourceImage.extent)
            request.finish(with: filteredImage, context: nil)
        }
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
                
            }
        })
    }
}
