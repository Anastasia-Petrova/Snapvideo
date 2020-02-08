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
    let effectsView = UIView()
    var bottomLooksConstraint = NSLayoutConstraint()
    let exportView = UIView()
    var bottomExportConstraint = NSLayoutConstraint()
    var bottomToolsConstraint = NSLayoutConstraint()
//    let looksCollectionView: UICollectionView
    let looksViewController: LooksViewController
//    let dataSource: LooksCollectionDataSource
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
    var presentedFilter: (Bool) -> Void
    let saveStackView = UIStackView()
    let saveCopyStackView = UIStackView()
    let itemSize = CGSize(width: 60, height: 76)
//    var filterIndex = 0 {
//        didSet {
//            playerView.filter = dataSource.filters[filterIndex]
//            bgVideoView.filter = dataSource.filters[filterIndex] + AnyFilter(BlurFilter(blurRadius: 100))
//            doneButton.isEnabled = filterIndex != 0
//            presentedFilter(filterIndex != 0)
//            guard filterIndex != oldValue else { return }
//            player.play()
//        }
//    }
    
    var isExportViewShown: Bool = true {
        didSet {
            guard let parent = self.parent as? HomeViewController else {
               return
            }
            
            if parent.isExportButtonSelected &&  parent.isExportButtonSelected != isExportViewShown {
                parent.isExportButtonSelected = isExportViewShown
                parent.tabBar.selectedItem = nil
                parent.previouslySelectedIndex = nil
            }
        }
    }
    
    var previewImage: UIImage? {
        didSet {
            looksViewController.dataSource.image = previewImage
//            dataSource.image = previewImage
        }
    }
    
    var trackDuration: Float {
        guard let trackDuration = player.currentItem?.asset.duration else {
            return 0
        }
        return Float(CMTimeGetSeconds(trackDuration))
    }
    
    init(url: URL, filters: [AnyFilter], presentedFilter: @escaping (Bool) -> Void) {
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
//        looksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LooksCollectionViewLayout(itemSize: itemSize))
//        looksCollectionView.showsHorizontalScrollIndicator = false
//        looksCollectionView.allowsSelection = true
//        looksCollectionView.bounces = false
//        dataSource = LooksCollectionDataSource(
//            collectionView: looksCollectionView,
//            filters: filters,
//            context: CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
//        )
        looksViewController = LooksViewController(itemSize: itemSize, filters: filters)
        self.presentedFilter = presentedFilter
        super.init(nibName: nil, bundle: nil)
        addChild(looksViewController)
        looksViewController.didMove(toParent: self)
        
        looksViewController.filterIndexChangeCallback = { [weak self] newIndex, previousIndex in
            self?.playerView.filter = filters[newIndex]
            self?.bgVideoView.filter = filters[newIndex] + AnyFilter(BlurFilter(blurRadius: 100))
            self?.doneButton.isEnabled = newIndex != 0
            presentedFilter(newIndex != 0)
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
        setUpBackgroundView()
        setUpPlayerView()
        setUpLooksView()
        setUpResumeButton()
        setUpPlayer()
        setUpSlider()
        setUpTimer()
        setUpCancelButton()
        setUpDoneButton()
        setUpExportView()
        setUpSaveStackView()
        setUpSaveCopyStackView()
        setUpSaveCopyButton()
//        looksCollectionView.delegate = self
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
        self.view.addSubview(playerView)
        NSLayoutConstraint.activate ([
        playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        playerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
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
        effectsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(effectsView)
        effectsView.backgroundColor = .white
        bottomLooksConstraint = effectsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)
        
        NSLayoutConstraint.activate ([
        effectsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        effectsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        effectsView.topAnchor.constraint(equalTo: playerView.bottomAnchor),
        bottomLooksConstraint
        ])
        
        let collectionStackView = UIStackView()
        collectionStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionStackView.axis = .vertical
        effectsView.addSubview(collectionStackView)
        
        NSLayoutConstraint.activate ([
            collectionStackView.trailingAnchor.constraint(equalTo: effectsView.trailingAnchor),
            collectionStackView.leadingAnchor.constraint(equalTo: effectsView.leadingAnchor),
            collectionStackView.topAnchor.constraint(equalTo: effectsView.topAnchor),
            collectionStackView.bottomAnchor.constraint(equalTo: effectsView.bottomAnchor)
        ])
        
        let buttonsStackView = UIStackView()
//        looksCollectionView.backgroundColor = .white
            
        collectionStackView.addArrangedSubview(looksViewController.view)
        collectionStackView.addArrangedSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(doneButton)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate ([
            looksViewController.view.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setUpExportView() {
        exportView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(exportView)
        exportView.backgroundColor = .white
        bottomExportConstraint = exportView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 140)

        NSLayoutConstraint.activate ([
        exportView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        exportView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        exportView.heightAnchor.constraint(equalToConstant: 100),
        bottomExportConstraint
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
        self.view.addSubview(bgVideoView)
        bgVideoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: bgVideoView.leftAnchor),
            view.rightAnchor.constraint(equalTo: bgVideoView.rightAnchor),
            bgVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgVideoView.topAnchor.constraint(equalTo: view.topAnchor)])
    }
    
    func setUpCancelButton() {
        NSLayoutConstraint.activate ([
        cancelButton.widthAnchor.constraint(equalToConstant: 44)
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
        bottomLooksConstraint.constant = 0 - self.view.safeAreaInsets.bottom
        bottomSliderConstraint.constant *= 0.84
        bottomTimerConstraint.constant *= 0.84
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func closeLooks() {
        bottomLooksConstraint.constant = 100
        bottomSliderConstraint.constant = -40
        bottomTimerConstraint.constant = 40
        resetToDefaultFilter()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func openExportMenu() {
        isExportViewShown = true
        bottomExportConstraint.constant = 0 - self.view.safeAreaInsets.bottom - 49
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    public func closeExportMenu() {
        bottomExportConstraint.constant = 140
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func resetToDefaultFilter() {
        looksViewController.selectedFilterIndex = 0
    }
    
    @objc func discardLooks() {
        looksViewController.deselectFilter()
//        looksCollectionView.deselectItem(at: IndexPath(row: filterIndex, section: 0), animated: false)
        resetToDefaultFilter()
    }
    
    @objc func saveFilter() {
        bottomLooksConstraint.constant = 146
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
//        let choosenFilter = dataSource.filters[filterIndex]
//        let choosenFilter = looksViewController.selectedFilter
        guard let playerItem = player.currentItem else { return }
        VideoEditer.saveEditedVideo(
            choosenFilter: looksViewController.selectedFilter,
            asset: playerItem.asset
        )
    }
}

//extension VideoEditorViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        filterIndex = indexPath.row
//        
//        if indexPath.row < dataSource.filters.count - 3 || indexPath.row > 2 {
//            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
//    }
//}
