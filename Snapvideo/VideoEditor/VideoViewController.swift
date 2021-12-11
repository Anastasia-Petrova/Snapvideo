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
    var asset: AVAsset {
        didSet {
            resetPlayerItem()
        }
    }
    let player: AVPlayer
    let playerView: VideoView
    let backgroundVideoView: VideoView
    var playerRateObservation: NSKeyValueObservation?
    let activityIndicator = UIActivityIndicatorView()
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?.withRenderingMode(.alwaysTemplate))
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    var isActivityIndicatorVisible: Bool = false {
        didSet {
            setActivityIndicatorVisible(isActivityIndicatorVisible)
        }
    }
    
    init(asset: AVAsset) {
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
        let stackView = UIStackView(arrangedSubviews: [resumeImageView, activityIndicator])
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resumeImageView.heightAnchor.constraint(equalToConstant: 70),
            resumeImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        resumeImageView.tintColor = .white
        resumeImageView.isHidden = false
        
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        //        activityIndicator.alpha = 0
    }
    
    private func setActivityIndicatorVisible(_ isOn: Bool) {
        tap.isEnabled = !isOn
        resumeImageView.isHidden = isOn
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func setUpPlayer() {
        //1 Подписка на событие достижения конца видео
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        //2 Подписка на изменение рейта плейера - (играю/не играю)
        playerRateObservation = player.observe(\.rate) { [weak self] (_, _) in
            guard let self = self else { return }
            self.resumeImageView.isHidden = self.player.rate > 0
        }
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
    
    private func resetPlayerItem() {
        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        let output = AVPlayerItemVideoOutput(outputSettings: nil)
        let outputBG = AVPlayerItemVideoOutput(outputSettings: nil)
        playerItem.add(output)
        playerItem.add(outputBG)
        playerView.videoOutput = output
        backgroundVideoView.videoOutput = outputBG
    }
}
