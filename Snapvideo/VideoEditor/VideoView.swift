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
    var videoOutput: AVPlayerItemVideoOutput
    var displayLink: CADisplayLink?
    var context: CIContext = CIContext()
    var filter: Filter {
        didSet  {
            currentFrame = initialFrame
                .map(filter.apply)
                .flatMap { context.createCGImage($0, from: $0.extent) }

        }
    }
    let videoOrientation: CGImagePropertyOrientation
    var initialFrame: CIImage?
    var currentFrame: CGImage? {
        didSet {
            layer.contents = currentFrame
        }
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
        displayLink = CADisplayLink(target: self, selector: #selector(updateCurrentFrame))
        displayLink?.preferredFramesPerSecond = preferredFramesPerSecond
        displayLink?.add(to: .main, forMode: .common)
        layer.contentsGravity = contentsGravity
        layer.masksToBounds = true
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
        let image = videoOutput
            .copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil)
            .map { CIImage(cvPixelBuffer: $0) }
            .map { $0.oriented(self.videoOrientation) }
        
        currentFrame = image
            .map(filter.apply)
            .flatMap { context.createCGImage($0, from: $0.extent) }
        
        initialFrame = image
    }
}
