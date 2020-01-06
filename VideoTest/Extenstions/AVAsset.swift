import AVFoundation
import UIKit

extension AVAsset {
    var videoTransform: CGAffineTransform {
        let videoTrack =  self.tracks(withMediaType: .video)[0]
        return videoTrack.preferredTransform
    }
    
    var videoOrientation: CGImagePropertyOrientation {
        let transform = self.videoTransform
        
        switch (transform.a, transform.b, transform.c, transform.d) {
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
