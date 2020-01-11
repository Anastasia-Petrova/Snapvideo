import AVFoundation
import UIKit

extension AVAsset {
    var videoTransform: CGAffineTransform {
        let videoTrack =  self.tracks(withMediaType: .video)[0]
        return videoTrack.preferredTransform
    }
    
    var videoOrientation: CGImagePropertyOrientation {
        switch (videoTransform.a, videoTransform.b, videoTransform.c, videoTransform.d) {
        case ( 0.0,  1.0, -1.0,  0.0): return .right
        case ( 0.0, -1.0,  1.0,  0.0): return .left
        case (-1.0,  0.0,  0.0, -1.0): return .down
        case ( 1.0,  0.0,  0.0,  1.0): return .up
        default: return .right
        }
    }
    
    var isPortrait: Bool {
        return videoOrientation == .up || videoOrientation == .down
    }
}
