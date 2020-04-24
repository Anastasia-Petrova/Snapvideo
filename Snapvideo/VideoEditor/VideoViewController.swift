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
    let activityIndicator = UIActivityIndicatorView()
    var playerRateObservation: NSKeyValueObservation?
    
    var indicatorSwitcher: Bool = false {
        didSet {
            setActivityIndicatorOn(indicatorSwitcher)
        }
    }
    
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?.withRenderingMode(.alwaysTemplate))
    
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
        setUpPlayer()
        setUpResumeButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        playerView.addGestureRecognizer(tap)
    }
    
    func setUpResumeButton() {
        let stackView = UIStackView(arrangedSubviews: [resumeImageView, activityIndicator])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            resumeImageView.heightAnchor.constraint(equalToConstant: 70),
            resumeImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        resumeImageView.tintColor = .white
        resumeImageView.isUserInteractionEnabled = false
        resumeImageView.isHidden = false
        
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
//        activityIndicator.alpha = 0
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
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
            let isPlaying = self.player.rate > 0
            self.resumeImageView.isHidden = isPlaying
            isPlaying ? self.playerView.play() :  self.playerView.pause()
        }
    }
    
    private func setActivityIndicatorOn(_ isOn: Bool) {
        tap.isEnabled = !isOn
        resumeImageView.isHidden = isOn
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
}
