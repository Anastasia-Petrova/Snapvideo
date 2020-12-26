//
//  VideoView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import AVFoundation

final class VideoView: UIView {
    let videoOutput: AVPlayerItemVideoOutput
    var displayLink: CADisplayLink?
    var context: CIContext = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
    var filter: AnyFilter
    let videoOrientation: CGImagePropertyOrientation
    
    init(
        videoOutput: AVPlayerItemVideoOutput,
        videoOrientation: CGImagePropertyOrientation,
        preferredFramesPerSecond: Int = 30,
        contentsGravity: CALayerContentsGravity = .resizeAspect,
        filter: AnyFilter = AnyFilter(PassthroughFilter())
    ) {
        self.videoOrientation = videoOrientation
        self.videoOutput = videoOutput
        self.filter = filter
        super.init(frame: .zero)
        displayLink = CADisplayLink(target: self, selector: #selector(updateCurrentFrame))
        displayLink?.preferredFramesPerSecond = preferredFramesPerSecond
        displayLink?.add(to: .main, forMode: .common)
        layer.contentsGravity = contentsGravity
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    @objc func updateCurrentFrame() {
        let time = videoOutput.itemTime(forHostTime: CACurrentMediaTime())
        guard videoOutput.hasNewPixelBuffer(forItemTime: time) else { return }
        
        layer.contents = videoOutput
            .copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil)
            .map { CIImage(cvPixelBuffer: $0) }
            .map { $0.oriented(self.videoOrientation) }
            .map(filter.apply)
            .flatMap { context.createCGImage($0, from: $0.extent) }
    }
}
