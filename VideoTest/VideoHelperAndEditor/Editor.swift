import UIKit
import AVFoundation

class Editor {
  func makeBirthdayCard(fromVideoAt videoURL: URL, forName name: String, onComplete: @escaping (URL?) -> Void) {
    let asset = AVURLAsset(url: videoURL)
    let composition = AVMutableComposition()
    guard let compositoinTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
          let assetTrack = asset.tracks(withMediaType: .video).first else {
        print("Something is wrong with the asset.")
        onComplete(nil)
        return
    }
    do {
      let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
      try compositoinTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
      if let audioAssetTrack = asset.tracks(withMediaType: .audio).first,
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
        try compositionAudioTrack.insertTimeRange(timeRange, of: audioAssetTrack, at: .zero)
      }
    } catch {
      print(error)
      onComplete(nil)
      return
    }
    
    compositoinTrack.preferredTransform = assetTrack.preferredTransform
    let videoInfo = orientation(from: assetTrack.preferredTransform)
    let videoSize: CGSize
    if videoInfo.isPortrait {
      videoSize = CGSize(width: assetTrack.naturalSize.height, height: assetTrack.naturalSize.width)
    } else {
      videoSize = assetTrack.naturalSize
    }
    
    let backgroundLayer = CALayer()
    backgroundLayer.frame = CGRect(origin: .zero, size: videoSize)
    let videoLayer = CALayer()
    videoLayer.frame = CGRect(origin: .zero, size: videoSize)
    let overlayLayer = CALayer()
    overlayLayer.frame = CGRect(origin: .zero, size: videoSize)
    let outputLayer = CALayer()
    outputLayer.frame = CGRect(origin: .zero, size: videoSize)
    backgroundLayer.backgroundColor = UIColor.red.cgColor
    videoLayer.frame = CGRect(x: 20, y: 20, width: videoSize.width - 40, height: videoSize.height - 40)
    backgroundLayer.contents = UIImage(named: "background")?.cgImage
    backgroundLayer.contentsGravity = .resizeAspectFill
    addConfetti(to: overlayLayer)
    addImage(to: overlayLayer, videoSize: videoSize)
    addText(text: "Merry Christmas,\n\(name)", to: overlayLayer, videoSize: videoSize)
    outputLayer.addSublayer(backgroundLayer)
    outputLayer.addSublayer(videoLayer)
    outputLayer.addSublayer(overlayLayer)
    let videoComposition = AVMutableVideoComposition()
    videoComposition.renderSize = videoSize
    videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
    videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: outputLayer)
    
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)
    videoComposition.instructions = [instruction]
    let layerInstruction = compositionLayerInstruction(for: compositoinTrack, assetTrack: assetTrack)
    instruction.layerInstructions = [layerInstruction]
    
    guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
      print("Cannot create export session.")
      onComplete(nil)
      return
    }
    
    let videoName = UUID().uuidString
    let exportURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(videoName).appendingPathExtension("mov")
    export.videoComposition = videoComposition
    export.outputFileType = .mov
    export.outputURL = exportURL
    export.exportAsynchronously {
      DispatchQueue.main.async {
        switch export.status {
        case .completed:
          onComplete(exportURL)
          default:
          print("Something went wrong during export.")
          print(export.error ?? "unknown error")
          onComplete(nil)
          break
        }
      }
    }
    
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
    let colors: [UIColor] = [.systemGreen, .systemRed, .systemYellow]
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
  
  private func addImage(to layer: CALayer, videoSize: CGSize) {
    let image = UIImage(named: "overlay")!
//    let image = UIImage(named: "overlay2")!
    
    let imageLayer = CALayer()
    let aspect: CGFloat = image.size.width / image.size.height
    let width = videoSize.width
    let height = width / aspect
    imageLayer.frame = CGRect(x: 0, y: -height * 0.015, width: width, height: height)
//    imageLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
    
    imageLayer.contents = image.cgImage
    layer.addSublayer(imageLayer)
  }
  
  private func addText(text: String, to layer: CALayer, videoSize: CGSize) {
    let attributedText = NSAttributedString(string: text, attributes: [ .font: UIFont(name: "ArialRoundedMTBold", size: 60) as Any,
        .foregroundColor: UIColor.red.cgColor,
        .strokeColor: UIColor.white,
        .strokeWidth: -3])
    let textLayer = CATextLayer()
    textLayer.string = attributedText
    textLayer.shouldRasterize = true
    textLayer.rasterizationScale = UIScreen.main.scale
    textLayer.backgroundColor = UIColor.clear.cgColor
    textLayer.alignmentMode = .center
    textLayer.frame = CGRect(x: 0, y: videoSize.height * 0.80, width: videoSize.width, height: 150)
    textLayer.displayIfNeeded()
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.fromValue = 0.8
    scaleAnimation.toValue = 1.2
    scaleAnimation.duration = 0.5
    scaleAnimation.repeatCount = .greatestFiniteMagnitude
    scaleAnimation.autoreverses = true
    scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    scaleAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
    scaleAnimation.isRemovedOnCompletion = false
    textLayer.add(scaleAnimation, forKey: "scale")
    layer.addSublayer(textLayer)
  }
}
