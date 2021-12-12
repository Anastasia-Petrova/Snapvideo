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
    private typealias AssetReadinessCompletion = () -> Void
    
    private(set) var asset: AVURLAsset
    let player: AVPlayer
    let playerView: VideoView
    let backgroundVideoView: VideoView
    var playerRateObservation: NSKeyValueObservation?
    let activityIndicator = UIActivityIndicatorView()
    private var assetReadinessCompletion: AssetReadinessCompletion?
    
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    var isActivityIndicatorVisible: Bool = false {
        didSet {
            setActivityIndicatorVisible(isActivityIndicatorVisible)
        }
    }
    
    init(asset: AVURLAsset) {
        self.asset = asset
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        let output = AVPlayerItemVideoOutput(outputSettings: nil)
        let outputBG = AVPlayerItemVideoOutput(outputSettings: nil)
        playerItem.add(output)
        playerItem.add(outputBG)
        playerView = VideoView(
            videoOutput: output,
            videoOrientation: asset.videoOrientation
        )
        backgroundVideoView = VideoView(
            videoOutput: outputBG,
            videoOrientation: asset.videoOrientation,
            contentsGravity: .resizeAspectFill,
            filter: BlurFilter(blurRadius: 100)
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundVideoView)
        view.addSubview(playerView)
        setUpBackgroundView()
        setUpPlayerView()
        setUpPlayer()
        setUpResumeButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpBackgroundView() {
        backgroundVideoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: backgroundVideoView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: backgroundVideoView.trailingAnchor),
            backgroundVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundVideoView.topAnchor.constraint(equalTo: view.topAnchor)])
    }
    
    func setUpPlayerView() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        playerView.addGestureRecognizer(tap)
    }
    
    func setUpResumeButton() {
        let stackView = UIStackView(arrangedSubviews: [activityIndicator])
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }
    
    private func setActivityIndicatorVisible(_ isOn: Bool) {
        tap.isEnabled = !isOn
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func setUpPlayer() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    func setPlayerRate(_ rate: Float) {
      player.rate = rate
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer?) {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    func setAsset(_ asset: AVURLAsset, completion: @escaping () -> Void) {
        self.asset = asset
        assetReadinessCompletion = completion
        
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        
        player.replaceCurrentItem(with: playerItem)
        let output = AVPlayerItemVideoOutput(outputSettings: nil)
        let outputBG = AVPlayerItemVideoOutput(outputSettings: nil)
        playerItem.add(output)
        playerItem.add(outputBG)
        playerView.videoOutput = output
        backgroundVideoView.videoOutput = outputBG
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if let playerItem = object as? AVPlayerItem,
           keyPath == "status" {
            switch playerItem.status {
            case .readyToPlay:
                assetReadinessCompletion?()
                assetReadinessCompletion = nil
            default:
                break
            }
        }
    }
}
