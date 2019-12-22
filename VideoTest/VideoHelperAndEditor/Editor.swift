import UIKit
import AVFoundation

class Editor {
   func makeBirthdayCard(fromVideoAt videoURL: URL, forName name: String, onComplete: @escaping (URL?) -> Void) {
    onComplete(videoURL)
  }
  
  private func orientation(from transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
    var assetOrientation = UIImage.Orientation.up
    var isPortrait = false
    if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
      assetOrientation = .right
      isPortrait = true
    } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
      assetOrientation = .left
      isPortrait = true
    } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
      assetOrientation = .up
    } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
      assetOrientation = .down
    }
    
    return (assetOrientation, isPortrait)
  }
  
  private func compositionLayerInstruction(for track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
    let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
    let transform = assetTrack.preferredTransform

    instruction.setTransform(transform, at: .zero)

    return instruction
  }
  
  private func addConfetti(to layer: CALayer) {
    let images: [UIImage] = (0...5).map { UIImage(named: "confetti\($0)")! }
    let colors: [UIColor] = [.systemGreen, .systemRed, .systemBlue, .systemPink, .systemOrange, .systemPurple, .systemYellow]
    let cells: [CAEmitterCell] = (0...16).map { i in
      let cell = CAEmitterCell()
      cell.contents = images.randomElement()?.cgImage
      cell.birthRate = 3
      cell.lifetime = 12
      cell.lifetimeRange = 0
      cell.velocity = CGFloat.random(in: 100...200)
      cell.velocityRange = 0
      cell.emissionLongitude = 0
      cell.emissionRange = 0.8
      cell.spin = 4
      cell.color = colors.randomElement()?.cgColor
      cell.scale = CGFloat.random(in: 0.2...0.8)
      return cell
    }
    
    let emitter = CAEmitterLayer()
    emitter.emitterPosition = CGPoint(x: layer.frame.size.width / 2, y: layer.frame.size.height + 5)
    emitter.emitterShape = .line
    emitter.emitterSize = CGSize(width: layer.frame.size.width, height: 2)
    emitter.emitterCells = cells
    
    layer.addSublayer(emitter)
  }
}
