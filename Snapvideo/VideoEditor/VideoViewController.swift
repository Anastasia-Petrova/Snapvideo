//
//  VideoViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 16/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import AVFoundation
import UIKit

final class VideoViewController: UIViewController {
    let asset: AVAsset
    let player: AVPlayer
    let playerView: VideoView
    let bgVideoView: VideoView
    let url: URL
    
    init(url: URL) {
        self.url = url
        asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        let output = AVPlayerItemVideoOutput(outputSettings: nil)
        let outputBG = AVPlayerItemVideoOutput(outputSettings: nil)
        playerItem.add(output)
        playerItem.add(outputBG)
        playerView = VideoView(
            videoOutput: output,
            videoOrientation: self.asset.videoOrientation
        )
        bgVideoView = VideoView(
            videoOutput: outputBG,
            videoOrientation: self.asset.videoOrientation,
            contentsGravity: .resizeAspectFill,
            filter: AnyFilter(BlurFilter(blurRadius: 100))
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgVideoView)
        view.addSubview(playerView)
        setUpBackgroundView()
        setUpPlayerView()
    }
    
    func setUpBackgroundView() {
        bgVideoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: bgVideoView.leftAnchor),
            view.rightAnchor.constraint(equalTo: bgVideoView.rightAnchor),
            bgVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgVideoView.topAnchor.constraint(equalTo: view.topAnchor)])
    }
    
    func setUpPlayerView() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        playerView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }
}
