import UIKit
import AVFoundation

class VideoView: UIView {
    let videoOutput: AVPlayerItemVideoOutput
    var displayLink: CADisplayLink?
    var context: CIContext = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
    var filter: Filter
    
    func play() {
//        self.displayLink?.isPaused = false
    }
    
    func pause() {
//        self.displayLink?.isPaused = true
    }
    
    init(
        videoOutput: AVPlayerItemVideoOutput,
        preferredFramesPerSecond: Int = 30,
        filter: Filter = PassthroughFilter()
    ) {
        self.videoOutput = videoOutput
        self.filter = filter
        super.init(frame: .zero)
        self.displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidUpdate))
        self.displayLink?.preferredFramesPerSecond = preferredFramesPerSecond
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

        let filteredImg = self.filter.apply(image: baseImg)

        guard let cgImg = context.createCGImage(filteredImg, from: filteredImg.extent) else { return }

        self.layer.contents = cgImg
    }
}

