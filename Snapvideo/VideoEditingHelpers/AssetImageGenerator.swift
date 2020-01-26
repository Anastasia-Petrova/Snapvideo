import Foundation
import AVFoundation
import UIKit

struct AssetImageGenerator {
    static func getThumbnailImageFromVideoAsset(asset: AVAsset, maximumSize: CGSize = .zero, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.maximumSize = maximumSize
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil) 
                }
            }
        }
    }
}
