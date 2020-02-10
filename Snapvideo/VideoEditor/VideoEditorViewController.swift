//
//  VideoEditorViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

final class VideoEditorViewController: UIViewController {
    let asset: AVAsset
    let player: AVPlayer
    let playerView: VideoView
    let looksContainerView = UIView()
    let exportView = UIView()
    var topExportConstraint = NSLayoutConstraint()
    let looksViewController: LooksViewController
    var topLooksConstraint = NSLayoutConstraint()
    let tabBar = TabBar(items: "LOOKS", "TOOLS", "EXPORT")
    let toolsViewController: ToolsViewController
    var topToolsConstraint = NSLayoutConstraint()
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?.withRenderingMode(.alwaysTemplate))
    let bgVideoView: VideoView
    var playerRateObservation: NSKeyValueObservation?
    var slider = UISlider()
    var bottomSliderConstraint = NSLayoutConstraint()
    let timerLabel = UILabel()
    var bottomTimerConstraint = NSLayoutConstraint()
    var cancelButton = LooksViewButton(imageName: "cancel")
    var doneButton = LooksViewButton(imageName: "done")
    var saveCopyButton = SaveCopyVideoButton()
    var spacerHeight = CGFloat()
    let saveStackView = UIStackView()
    let saveCopyStackView = UIStackView()
    let itemSize = CGSize(width: 60, height: 76)
    var previouslySelectedIndex: Int?
    
    var isLooksButtonSelected: Bool = false {
        didSet {
            if isLooksButtonSelected {
                openLooks()
            } else {
                closeLooks()
            }
        }
    }
    
    var isExportButtonSelected: Bool = false {
        didSet {
            if isExportButtonSelected {
                openExportMenu()
            } else {
                closeExportMenu()
            }
        }
    }
    
    var isToolsButtonSelected: Bool = false {
        didSet {
            if isToolsButtonSelected {
                openToolsMenu()
            } else {
                closeToolsMenu()
            }
        }
    }
    
    var isExportViewShown: Bool = true {
        didSet {
            if isExportButtonSelected &&  isExportButtonSelected != isExportViewShown {
                isExportButtonSelected = isExportViewShown
                tabBar.selectedItem = nil
                previouslySelectedIndex = nil
            }
        }
    }
    
    var isToolsViewShown: Bool = true {
        didSet {
            if isToolsButtonSelected &&  isToolsButtonSelected != isToolsViewShown {
                isToolsButtonSelected = isToolsViewShown
                tabBar.selectedItem = nil
                previouslySelectedIndex = nil
            }
        }
    }
    
    var previewImage: UIImage? {
        didSet {
            looksViewController.dataSource.image = previewImage
        }
    }
    
    var trackDuration: Float {
        guard let trackDuration = player.currentItem?.asset.duration else {
            return 0
        }
        return Float(CMTimeGetSeconds(trackDuration))
    }
    
    init(url: URL, filters: [AnyFilter]) {
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
        looksViewController = LooksViewController(itemSize: itemSize, filters: filters)
        toolsViewController = ToolsViewController()
        super.init(nibName: nil, bundle: nil)
        addChild(looksViewController)
        looksViewController.didMove(toParent: self)
        
        looksViewController.filterIndexChangeCallback = { [weak self] newIndex, previousIndex in
            self?.playerView.filter = filters[newIndex]
            self?.bgVideoView.filter = filters[newIndex] + AnyFilter(BlurFilter(blurRadius: 100))
            self?.doneButton.isEnabled = newIndex != 0
            self?.tabBar.isHidden = newIndex != 0
            guard newIndex != previousIndex && newIndex != 0 else { return }
            self?.player.play()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        AssetImageGenerator.getThumbnailImageFromVideoAsset(
            asset: asset,
            maximumSize: itemSize.applying(.init(scaleX: UIScreen.main.scale, y: UIScreen.main.scale)),
            completion: { [weak self] image in
                self?.previewImage = image
            }
        )
        
        view.addSubview(bgVideoView)
        view.addSubview(playerView)
        view.addSubview(looksContainerView)
        view.addSubview(toolsViewController.view)
        view.addSubview(exportView)
        view.addSubview(tabBar)
        
        setUpBackgroundView()
        setUpPlayerView()
        setUpLooksView()
        setUpResumeButton()
        setUpPlayer()
        setUpSlider()
        setUpTimer()
        setUpCancelButton()
        setUpDoneButton()
        setUpToolsView()
        setUpExportView()
        setUpSaveStackView()
        setUpSaveCopyStackView()
        setUpSaveCopyButton()
        setUpTabBar()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpTabBar() {
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.setContentHuggingPriority(.required, for: .vertical)
        tabBar.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 100), queue: .main) { [weak self] time in
            self?.slider.value = Float(time.seconds)
            self?.updateTimer()
        }
    }
    
    func setUpResumeButton() {
        resumeImageView.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(resumeImageView)
        NSLayoutConstraint.activate([
            resumeImageView.centerYAnchor.constraint(equalTo: playerView.centerYAnchor),
            resumeImageView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            resumeImageView.heightAnchor.constraint(equalToConstant: 70),
            resumeImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        resumeImageView.tintColor = .white
        resumeImageView.isUserInteractionEnabled = false
        resumeImageView.isHidden = false
    }
    
    func setUpSlider() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(slider)
        bottomSliderConstraint = slider.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -40)
        NSLayoutConstraint.activate ([
            slider.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 50),
            slider.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -50),
            bottomSliderConstraint])
        slider.minimumValue = 0
        slider.maximumValue = trackDuration
        slider.addTarget(self, action: #selector(self.sliderAction), for: .valueChanged)
    }
    
    func setUpPlayerView() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            playerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tabBar.topAnchor.constraint(greaterThanOrEqualTo: playerView.bottomAnchor)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        playerView.addGestureRecognizer(tap)
    }
    
    func setUpTimer() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(timerLabel)
        bottomTimerConstraint = timerLabel.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 40)
        NSLayoutConstraint.activate ([
            timerLabel.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 40),
            bottomTimerConstraint,
            timerLabel.heightAnchor.constraint(equalToConstant: 44)])
        timerLabel.alpha = 0.5
        timerLabel.textColor = .white
        let videoDuration = Int(trackDuration)
        timerLabel.text = "\(formatMinuteSeconds(videoDuration))"
    }
    
    func updateTimer() {
        let duraion = Int(CMTimeGetSeconds(player.currentTime()))
        let timeString = formatMinuteSeconds(duraion)
        timerLabel.text = "\(timeString)"
    }
    
    func formatMinuteSeconds(_ totalSeconds: Int) -> String {
        let hours  = totalSeconds / 3600
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds);
    }
    
    func setUpLooksView() {
        looksContainerView.translatesAutoresizingMaskIntoConstraints = false
        looksContainerView.backgroundColor = .white
        topLooksConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: looksContainerView.topAnchor, constant: -view.safeAreaInsets.bottom)
        let looksViewHeight: CGFloat = 100.0
        let bottomConstraint = looksContainerView.topAnchor.constraint(equalTo: playerView.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate ([
            looksContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            looksContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            looksContainerView.heightAnchor.constraint(equalTo: tabBar.heightAnchor, constant: looksViewHeight),
            bottomConstraint,
            topLooksConstraint
        ])
        let buttonsStackView = UIStackView()
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(doneButton)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        
        let collectionStackView = UIStackView()
        collectionStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionStackView.axis = .vertical
        
        looksContainerView.addSubview(collectionStackView)
        collectionStackView.addArrangedSubview(looksViewController.view)
        collectionStackView.addArrangedSubview(buttonsStackView)
        let spacer = UIView()
        spacer.backgroundColor = .white
        collectionStackView.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate ([
            collectionStackView.trailingAnchor.constraint(equalTo: looksContainerView.trailingAnchor),
            collectionStackView.leadingAnchor.constraint(equalTo: looksContainerView.leadingAnchor),
            collectionStackView.topAnchor.constraint(equalTo: looksContainerView.topAnchor),
            collectionStackView.bottomAnchor.constraint(equalTo: looksContainerView.bottomAnchor),
            looksViewController.view.heightAnchor.constraint(equalToConstant: looksViewHeight)
        ])
        
    }
    
    func setUpToolsView() {
        toolsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        topToolsConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: toolsViewController.view.topAnchor)
        
        NSLayoutConstraint.activate ([
            toolsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolsViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            topToolsConstraint
        ])
    }
    
    func setUpExportView() {
        exportView.translatesAutoresizingMaskIntoConstraints = false
        exportView.backgroundColor = .white
        topExportConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: exportView.topAnchor, constant: -view.safeAreaInsets.bottom)
        
        NSLayoutConstraint.activate ([
            exportView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exportView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exportView.heightAnchor.constraint(equalToConstant: 100),
            topExportConstraint
        ])
        
        let exportStackView = UIStackView()
        exportStackView.translatesAutoresizingMaskIntoConstraints = false
        exportStackView.axis = .vertical
        exportStackView.distribution = .fillEqually
        exportView.addSubview(exportStackView)
        
        NSLayoutConstraint.activate ([
            exportStackView.trailingAnchor.constraint(equalTo: exportView.trailingAnchor),
            exportStackView.leadingAnchor.constraint(equalTo: exportView.leadingAnchor),
            exportStackView.topAnchor.constraint(equalTo: exportView.topAnchor),
            exportStackView.bottomAnchor.constraint(equalTo: exportView.bottomAnchor)
        ])
        saveStackView.translatesAutoresizingMaskIntoConstraints = false
        saveStackView.axis = .horizontal
        saveCopyStackView.translatesAutoresizingMaskIntoConstraints = false
        saveCopyStackView.axis = .horizontal
        exportStackView.addArrangedSubview(saveStackView)
        exportStackView.addArrangedSubview(saveCopyStackView)
    }
    
    func setUpBackgroundView() {
        bgVideoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: bgVideoView.leftAnchor),
            view.rightAnchor.constraint(equalTo: bgVideoView.rightAnchor),
            bgVideoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bgVideoView.topAnchor.constraint(equalTo: view.topAnchor)])
    }
    
    func setUpCancelButton() {
        NSLayoutConstraint.activate ([
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        cancelButton.addTarget(self, action: #selector(self.discardLooks), for: .touchUpInside)
    }
    
    func setUpDoneButton() {
        doneButton.isEnabled = false
        NSLayoutConstraint.activate ([
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        doneButton.addTarget(self, action: #selector(self.saveFilter), for: .touchUpInside)
    }
    
    func setUpSaveStackView() {
        saveStackView.spacing = 16
        saveStackView.alignment = .center
        let imageView = ExportImageView(imageName: "saveVideoImage")
        let leftSpacer = UIView()
        let rightSpacer = UIView()
        let labelsStackView = UIStackView()
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        
        saveStackView.addArrangedSubview(leftSpacer)
        saveStackView.addArrangedSubview(imageView)
        saveStackView.addArrangedSubview(labelsStackView)
        saveStackView.addArrangedSubview(rightSpacer)
        saveStackView.setCustomSpacing(0, after: leftSpacer)
        saveStackView.setCustomSpacing(0, after: labelsStackView)
        
        NSLayoutConstraint.activate ([
            leftSpacer.widthAnchor.constraint(equalToConstant: 16),
            rightSpacer.widthAnchor.constraint(equalTo: leftSpacer.widthAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        let header = HeaderExportLabel()
        header.text = "Save"
        
        let body = BodyExportLabel()
        body.text = "Saves with changes that you can undo. IOS will ask for permission to modify this photo."
        
        labelsStackView.addArrangedSubview(header)
        labelsStackView.addArrangedSubview(body)
        labelsStackView.layoutMargins = .init(top: 8, left: 0, bottom: 8, right: 0)
        labelsStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func setUpSaveCopyStackView() {
        saveCopyStackView.spacing = 16
        saveCopyStackView.alignment = .center
        let imageView = ExportImageView(imageName: "saveVideoCopyImage")
        let leftSpacer = UIView()
        let rightSpacer = UIView()
        let labelsStackView = UIStackView()
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        
        saveCopyStackView.addArrangedSubview(leftSpacer)
        saveCopyStackView.addArrangedSubview(imageView)
        saveCopyStackView.addArrangedSubview(labelsStackView)
        saveCopyStackView.addArrangedSubview(rightSpacer)
        
        saveCopyStackView.setCustomSpacing(0, after: leftSpacer)
        saveCopyStackView.setCustomSpacing(0, after: labelsStackView)
        
        NSLayoutConstraint.activate ([
            leftSpacer.widthAnchor.constraint(equalToConstant: 16),
            rightSpacer.widthAnchor.constraint(equalTo: leftSpacer.widthAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        let header = HeaderExportLabel()
        header.text = "Save a copy"
        
        let body = BodyExportLabel()
        body.text = "Creates a copy with changes that you can undo."
        
        labelsStackView.addArrangedSubview(header)
        labelsStackView.addArrangedSubview(body)
        labelsStackView.layoutMargins = .init(top: 8, left: 0, bottom: 8, right: 0)
        labelsStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func setUpSaveCopyButton() {
        saveCopyButton.translatesAutoresizingMaskIntoConstraints = false
        saveCopyButton.addTarget(self, action: #selector(self.saveVideoCopy), for: .touchUpInside)
        saveCopyStackView.addSubview(saveCopyButton)
        NSLayoutConstraint.activate ([
            saveCopyButton.trailingAnchor.constraint(equalTo: saveCopyStackView.trailingAnchor),
            saveCopyButton.leadingAnchor.constraint(equalTo: saveCopyStackView.leadingAnchor),
            saveCopyButton.topAnchor.constraint(equalTo: saveCopyStackView.topAnchor),
            saveCopyButton.bottomAnchor.constraint(equalTo: saveCopyStackView.bottomAnchor)
        ])
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    @objc func sliderAction() {
        player.seek(
            to: CMTime(
                seconds: Double(slider.value),
                preferredTimescale: 1
            ),
            toleranceBefore: CMTime.zero,
            toleranceAfter: CMTime.zero
        )
    }
    
    public func openLooks() {
        self.view.layoutIfNeeded()
        topLooksConstraint.constant = looksViewController.view.frame.height + tabBar.frame.height
        bottomSliderConstraint.constant *= 0.84
        bottomTimerConstraint.constant *= 0.84
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func closeLooks() {
        self.view.layoutIfNeeded()
        topLooksConstraint.constant = -view.safeAreaInsets.bottom
        bottomSliderConstraint.constant = -40
        bottomTimerConstraint.constant = 40
        resetToDefaultFilter()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func openExportMenu() {
        self.view.layoutIfNeeded()
        isExportViewShown = true
        topExportConstraint.constant = exportView.frame.height + tabBar.frame.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func closeExportMenu() {
        self.view.layoutIfNeeded()
        topExportConstraint.constant = -self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func openToolsMenu() {
        self.view.layoutIfNeeded()
        isToolsViewShown = true
        topToolsConstraint.constant = toolsViewController.view.frame.height + tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func closeToolsMenu() {
        self.view.layoutIfNeeded()
        topToolsConstraint.constant = -self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func resetToDefaultFilter() {
        looksViewController.deselectFilter()
    }
    
    @objc func discardLooks() {
        resetToDefaultFilter()
    }
    
    @objc func saveFilter() {
        self.view.layoutIfNeeded()
        topLooksConstraint.constant = 146
        resetToDefaultFilter()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func saveVideoCopy() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                self?.saveVideoToPhotos()
            default:
                print("Photos permissions not granted.")
                return
            }
        }
    }
    
    func saveVideoToPhotos() {
        DispatchQueue.main.async {
            self.isExportViewShown = false
        }
        guard let playerItem = player.currentItem else { return }
        VideoEditer.saveEditedVideo(
            choosenFilter: looksViewController.selectedFilter,
            asset: playerItem.asset
        )
    }
}

extension VideoEditorViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        
        isLooksButtonSelected = selectedIndex == 0 && previouslySelectedIndex != selectedIndex
        
        isExportButtonSelected = selectedIndex == 2 && previouslySelectedIndex != selectedIndex
        
        isToolsButtonSelected = selectedIndex == 1 && previouslySelectedIndex != selectedIndex
        
        if previouslySelectedIndex == selectedIndex {
            previouslySelectedIndex = nil
        } else {
            previouslySelectedIndex = selectedIndex
        }
    }
}
