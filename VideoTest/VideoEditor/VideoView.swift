import UIKit
import AVFoundation

class VideoView: UIView {
    let videoOutput: AVPlayerItemVideoOutput
    var displayLink: CADisplayLink?
    var context: CIContext = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
    var filter: Filter
    let videoOrientation: CGImagePropertyOrientation
    
    func play() {
//        self.displayLink?.isPaused = false
    }
    
    func pause() {
//        self.displayLink?.isPaused = true
    }
    
    init(
        videoOutput: AVPlayerItemVideoOutput,
        videoOrientation: CGImagePropertyOrientation,
        preferredFramesPerSecond: Int = 30,
        contentsGravity: CALayerContentsGravity = .resizeAspect,
        filter: Filter = PassthroughFilter()
    ) {
        self.videoOrientation = videoOrientation
        self.videoOutput = videoOutput
        self.filter = filter
        super.init(frame: .zero)
        self.displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidUpdate))
        self.displayLink?.preferredFramesPerSecond = preferredFramesPerSecond
        self.displayLink?.add(to: .main, forMode: .common)
        self.layer.contentsGravity = contentsGravity
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.displayLink?.invalidate()
    }
    
    @objc func displayLinkDidUpdate() {
        let time = videoOutput.itemTime(forHostTime: CACurrentMediaTime())
        guard videoOutput.hasNewPixelBuffer(forItemTime: time) else { return }
        
        self.layer.contents = videoOutput
            .copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil)
            .map { CIImage(cvPixelBuffer: $0) }
            .map { $0.oriented(self.videoOrientation) }
            .map(filter.apply)
            .flatMap { context.createCGImage($0, from: $0.extent) }
    }
     
}

