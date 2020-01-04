import UIKit
import AVFoundation

class VideoView: UIView {
    let videoOutput: AVPlayerItemVideoOutput
    var displayLink: CADisplayLink?
    var context: CIContext = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])

    func play() {
        self.displayLink?.isPaused = false
    }
    
    func stop() {
        self.displayLink?.isPaused = true
    }
    
    init(videoOutput: AVPlayerItemVideoOutput, preferredFramesPerSecond: Int = 30) {
        self.videoOutput = videoOutput
        super.init(frame: .zero)
        self.displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidUpdate))
        self.displayLink?.preferredFramesPerSecond = preferredFramesPerSecond
        self.displayLink?.isPaused = true
        self.displayLink?.add(to: .main, forMode: .common)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.displayLink?.invalidate()
    }
    
    @objc func displayLinkDidUpdate() {
        let time = videoOutput.itemTime(forHostTime: CACurrentMediaTime())
        guard videoOutput.hasNewPixelBuffer(forItemTime: time),
            let pixBuf = videoOutput.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) else {
                return
        }
        let baseImg = CIImage(cvPixelBuffer: pixBuf)
        guard let cgImg = context.createCGImage(baseImg, from: baseImg.extent) else { return }

        self.layer.contents = cgImg
    }
}
