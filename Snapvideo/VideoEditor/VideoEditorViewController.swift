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
    let url: URL
    let videoViewController: VideoViewController
    let looksContainerView = UIView()
    let exportView = UIView()
    var topExportConstraint = NSLayoutConstraint()
    let looksViewController: LooksViewController
    var topLooksConstraint = NSLayoutConstraint()
    var selectedFilter: AnyFilter
    var selectedFilterIndex: Int
    var pendingFilterIndex: Int?
    var topVimeoConstraint = NSLayoutConstraint()
    let coverView = UIView()
    let progressView = UIProgressView(progressViewStyle: .default)
    let coverButton = UIButton()

    let tabBar = TabBar(items: "LOOKS", "UPLOADS", "EXPORT")
    var cancelButton = LooksViewButton(imageName: "cancel-solid")
    var saveFilterButton = LooksViewButton(imageName: "done-solid")
    var saveCopyButton = HightlightedButton()
    var shareButton = HightlightedButton()
    var spacerHeight = CGFloat()
    let shareStackView = UIStackView()
    let saveCopyStackView = UIStackView()
    let itemSize = CGSize(width: 60, height: 76)
    var previouslySelectedIndex: Int?
    
    lazy var vimeoViewController = VimeoViewController() { [weak self] in
        guard let self = self else { return }
        self.uploadVideo()
    }
    
    var progressValue: Float = 0 {
        didSet {
            progressView.progress = progressValue
        }
    }
    
    var isLooksButtonSelected: Bool = false {
        didSet {
            if isLooksButtonSelected {
                openLooks()
            } else {
                closeLooks()
            }
        }
    }
    
    var isVimeoButtonSelected: Bool = false {
        didSet {
            if isVimeoButtonSelected {
                openVimeo()
                coverView.isHidden = false
            } else {
                closeVimeo()
                coverView.isHidden = true
            }
        }
    }
    
    var isVimeoViewShown: Bool = true {
        didSet {
            if isVimeoButtonSelected &&  isVimeoButtonSelected != isVimeoViewShown {
                isVimeoButtonSelected = isVimeoViewShown
                tabBar.selectedItem = nil
                previouslySelectedIndex = nil
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
    
    var isExportViewShown: Bool = true {
        didSet {
            if isExportButtonSelected &&  isExportButtonSelected != isExportViewShown {
                isExportButtonSelected = isExportViewShown
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
        guard let trackDuration = videoViewController.player.currentItem?.asset.duration else {
            return 0
        }
        return Float(CMTimeGetSeconds(trackDuration))
    }
    
    init(url: URL, index: Int, filters: [AnyFilter]) {
        self.url = url
        asset = AVAsset(url: url)
        selectedFilterIndex = index
        selectedFilter = filters[index]
        videoViewController = VideoViewController(asset: asset)
        looksViewController = LooksViewController(itemSize: itemSize, selectedFilterIndex: index, filters: filters)
        super.init(nibName: nil, bundle: nil)
        looksViewController.filterIndexChangeCallback = {
            [weak self] newIndex, previousIndex in
            guard let self = self else { return }
            let hasChangedSelectedFilter = newIndex != self.selectedFilterIndex
            self.videoViewController.playerView.filter = filters[newIndex]
            self.videoViewController.bgVideoView.filter = filters[newIndex] + AnyFilter(BlurFilter(blurRadius: 100))
            self.saveFilterButton.isEnabled = hasChangedSelectedFilter
            self.tabBar.isHidden = hasChangedSelectedFilter
            guard newIndex != previousIndex && hasChangedSelectedFilter else { return }
            self.videoViewController.player.play()
            self.selectedFilter = filters[newIndex]
            self.pendingFilterIndex = newIndex
        }
        addChild(looksViewController)
        looksViewController.didMove(toParent: self)
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
        
        view.addSubview(videoViewController.view)
        view.addSubview(coverView)
        view.addSubview(looksContainerView)
        view.addSubview(vimeoViewController.view)
        view.addSubview(exportView)
        view.addSubview(tabBar)
        
        setUpVideoViewController()
        setUpCoverView()
        setUpLooksView()
        setUpCancelButton()
        setUpDoneButton()
        setUpVimeoView()
        setUpExportView()
        setUpShareStackView()
        setUpSaveCopyStackView()
        setUpShareButton()
        setUpSaveCopyButton()
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.isTranslucent = false
        tabBar.setContentHuggingPriority(.required, for: .vertical)
        tabBar.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setUpVideoViewController() {
        videoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            videoViewController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            videoViewController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            videoViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tabBar.topAnchor.constraint(greaterThanOrEqualTo: videoViewController.view.bottomAnchor)
        ])
    }
   
    func setUpLooksView() {
        looksContainerView.translatesAutoresizingMaskIntoConstraints = false
        looksContainerView.backgroundColor = .white
        topLooksConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: looksContainerView.topAnchor, constant: -view.safeAreaInsets.bottom)
        let looksViewHeight: CGFloat = 100.0
        let bottomConstraint = looksContainerView.topAnchor.constraint(equalTo: videoViewController.view.bottomAnchor)
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
        buttonsStackView.addArrangedSubview(saveFilterButton)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        
        let collectionStackView = UIStackView()
        collectionStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionStackView.axis = .vertical
        
        looksContainerView.addSubview(collectionStackView)
        collectionStackView.addArrangedSubview(looksViewController.view)
        
        let line = UIView()
        line.backgroundColor = .darkGray
        collectionStackView.addArrangedSubview(line)
        
        let spacer = UIView()
        spacer.backgroundColor = .white
        collectionStackView.addArrangedSubview(spacer)
        collectionStackView.addArrangedSubview(buttonsStackView)
        
        NSLayoutConstraint.activate ([
            collectionStackView.trailingAnchor.constraint(equalTo: looksContainerView.trailingAnchor),
            collectionStackView.leadingAnchor.constraint(equalTo: looksContainerView.leadingAnchor),
            collectionStackView.topAnchor.constraint(equalTo: looksContainerView.topAnchor),
            collectionStackView.bottomAnchor.constraint(equalTo: looksContainerView.bottomAnchor),
            looksViewController.view.heightAnchor.constraint(equalToConstant: looksViewHeight),
            line.heightAnchor.constraint(equalToConstant: 0.4)
        ])
    }
    
    func setUpVimeoView() {
        vimeoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        topVimeoConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: vimeoViewController.view.topAnchor)
        
        NSLayoutConstraint.activate ([
            vimeoViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vimeoViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vimeoViewController.view.heightAnchor.constraint(equalToConstant: 280),
            topVimeoConstraint
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
        shareStackView.translatesAutoresizingMaskIntoConstraints = false
        shareStackView.axis = .horizontal
        saveCopyStackView.translatesAutoresizingMaskIntoConstraints = false
        saveCopyStackView.axis = .horizontal
        exportStackView.addArrangedSubview(shareStackView)
        exportStackView.addArrangedSubview(saveCopyStackView)
    }
    
    func setUpCancelButton() {
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        NSLayoutConstraint.activate ([
            cancelButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        cancelButton.addTarget(self, action: #selector(self.discardLooks), for: .touchUpInside)
    }
    
    func setUpDoneButton() {
        saveFilterButton.isEnabled = false
        saveFilterButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        NSLayoutConstraint.activate ([
            saveFilterButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        saveFilterButton.addTarget(self, action: #selector(self.saveFilter), for: .touchUpInside)
    }
    
    func setUpShareStackView() {
        shareStackView.spacing = 16
        shareStackView.alignment = .center
        let imageView = ExportImageView(systemName: "square.and.arrow.up")
        let leftSpacer = UIView()
        let rightSpacer = UIView()
        let labelsStackView = UIStackView()
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        
        shareStackView.addArrangedSubview(leftSpacer)
        shareStackView.addArrangedSubview(imageView)
        shareStackView.addArrangedSubview(labelsStackView)
        shareStackView.addArrangedSubview(rightSpacer)
        shareStackView.setCustomSpacing(0, after: leftSpacer)
        shareStackView.setCustomSpacing(0, after: labelsStackView)
        
        NSLayoutConstraint.activate ([
            leftSpacer.widthAnchor.constraint(equalToConstant: 16),
            rightSpacer.widthAnchor.constraint(equalTo: leftSpacer.widthAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        let header = HeaderExportLabel()
        header.text = "Share"
        
        let body = BodyExportLabel()
        body.text = "Posts video to social media sites or sends it via email or SMS."
        
        labelsStackView.addArrangedSubview(header)
        labelsStackView.addArrangedSubview(body)
        labelsStackView.layoutMargins = .init(top: 8, left: 0, bottom: 8, right: 0)
        labelsStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func setUpSaveCopyStackView() {
        saveCopyStackView.spacing = 16
        saveCopyStackView.alignment = .center
        let imageView = ExportImageView(systemName: "doc.on.doc")
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
        body.text = "Creates a copy with changes that you can't undo."
        
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
    
    func setUpShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(self.openActivityView), for: .touchUpInside)
        shareStackView.addSubview(shareButton)
        NSLayoutConstraint.activate ([
            shareButton.trailingAnchor.constraint(equalTo: shareStackView.trailingAnchor),
            shareButton.leadingAnchor.constraint(equalTo: shareStackView.leadingAnchor),
            shareButton.topAnchor.constraint(equalTo: shareStackView.topAnchor),
            shareButton.bottomAnchor.constraint(equalTo: shareStackView.bottomAnchor)
        ])
    }
    
    private func setUpCoverView() {
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.backgroundColor = .lightGray
        coverView.alpha = 0.5
        coverButton.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(progressView)
        coverView.addSubview(coverButton)
        NSLayoutConstraint.activate ([
            coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverView.topAnchor.constraint(equalTo: view.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coverButton.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            coverButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            coverButton.topAnchor.constraint(equalTo: coverView.topAnchor),
            coverButton.bottomAnchor.constraint(equalTo: coverView.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
        ])
        coverButton.addTarget(self, action: #selector(closeVimeoView), for: .touchUpInside)
        coverView.isHidden = true
        progressView.tintColor = .systemBlue
        progressView.trackTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        progressView.isHidden = true
    }
   
    public func openLooks() {
        self.view.layoutIfNeeded()
        topLooksConstraint.constant = looksViewController.view.frame.height + tabBar.frame.height + 0.3
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func closeLooks() {
        self.view.layoutIfNeeded()
        topLooksConstraint.constant = -view.safeAreaInsets.bottom
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
    
    public func openVimeo() {
        self.view.layoutIfNeeded()
        isVimeoViewShown = true
        topVimeoConstraint.constant = vimeoViewController.view.frame.height + tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func closeVimeo() {
        self.view.layoutIfNeeded()
        topVimeoConstraint.constant = -self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func resetToDefaultFilter() {
        pendingFilterIndex = nil
        looksViewController.deselectFilter()
    }
    
    private func saveVideoToPhotos() {
        DispatchQueue.main.async {
            self.isExportViewShown = false
            self.showCoverView(isShown: true)
            self.videoViewController.indicatorSwitcher = true
        }
        
        guard let playerItem = videoViewController.player.currentItem else { return }
        VideoEditor.saveEditedVideo(
            choosenFilter: selectedFilter,
            asset: playerItem.asset
        ) { 
            DispatchQueue.main.async {
                self.showCoverView(isShown: false)
                self.videoViewController.indicatorSwitcher = false
            }
        }
    }
    
    private func showCoverView(isShown: Bool) {
        coverView.isHidden = !isShown
        coverButton.isEnabled = !isShown
        tabBar.isUserInteractionEnabled = !isShown
        progressView.isHidden = !isShown
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    @objc func closeVimeoView() {
        isVimeoViewShown = false
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    @objc func discardLooks() {
        resetToDefaultFilter()
    }
    
    @objc func saveFilter() {
        view.layoutIfNeeded()
        tabBar.isHidden = false
        topLooksConstraint.constant = 146
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        if let pendingFilterIndex = looksViewController.pendingFilterIndex {
            selectedFilterIndex = pendingFilterIndex
            looksViewController.selectedFilterIndex = pendingFilterIndex
        }
        looksViewController.pendingFilterIndex = nil
        pendingFilterIndex = nil
        looksViewController.dataSource.updateVideo(index: selectedFilterIndex)
    }
    
    @objc func openActivityView() {
        DispatchQueue.main.async {
            self.isExportViewShown = false
            self.showCoverView(isShown: true)
            self.videoViewController.indicatorSwitcher = true
        }
        guard let playerItem = videoViewController.player.currentItem else { return }
        
        VideoEditor.composeVideo(
            choosenFilter: selectedFilter,
            asset: playerItem.asset
        ) { url in
            DispatchQueue.main.async {
                guard let fileURL = url else {
                    self.videoViewController.indicatorSwitcher = false
                    return
                }
                let objectToImport = [fileURL as NSURL]
                let activityVC = UIActivityViewController(activityItems: objectToImport, applicationActivities: nil)
                activityVC.setValue("Video", forKey: "subject")
                activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact]
                self.present(activityVC, animated: true, completion: nil)
                self.videoViewController.indicatorSwitcher = false
                self.showCoverView(isShown: false)
            }
        }
    }
    
    @objc func saveVideoCopy() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                self?.saveVideoToPhotos()
            default:
                DispatchQueue.main.async {
                    self?.presentAlert(title: "Error!", message: "Photos permissions not granted.")
                }
                return
            }
        }
    }
}

extension VideoEditorViewController {
    func uploadVideo() {
        guard let token = vimeoClient.currentAccount?.accessToken else { return }
        DispatchQueue.global().async {
            guard let playerItem = self.videoViewController.player.currentItem else { return
            }
            
            VideoEditor.composeVideo(
                choosenFilter: self.selectedFilter,
                asset: playerItem.asset
            ) { [weak self] url in
                guard let url = url,
                    let data = VideoEditor.getVideoData(url: url) else { return }
                self?.getUploadLink(token: token, data: data)
            }
        }
    }
    
    func getUploadLink(token: String, data: Data) {
        VimeoUploadClient.performGetUploadLinkRequest(
            accessToken: token,
            size: data.count
        ) { response in
            switch response {
            case .success(let response):
                let link = response.upload.uploadLink
                self.performUploadRequest(data: data, link: link)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error!", message: error.localizedDescription)
                }
            }
        }
    }
    
    func performUploadRequest(data: Data, link: String) {
        VimeoUploadClient.performUploadRequest(uploadLink: link, videoData: data) { [weak self] response in
            switch response {
            case .success:
                self?.performHeadRequest(uploadLink: link)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentAlert(title: "Error!", message: error.localizedDescription)
                }
            }
        }
    }
    
    func performHeadRequest(uploadLink: String) {
        VimeoUploadClient.performHeadUploadRequest(uploadLink: uploadLink) { [weak self] (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let dataSource = self?.vimeoViewController.videoDataSource
                    dataSource?.headerView?.setActivityIndicatorOn(false)
                    dataSource?.fetchVideos()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.presentAlert(title: "Error!", message: error.localizedDescription)
                }
            }
        }
    }
}


extension VideoEditorViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        
        isLooksButtonSelected = selectedIndex == 0 && previouslySelectedIndex != selectedIndex
        
        isVimeoButtonSelected = selectedIndex == 1 && previouslySelectedIndex != selectedIndex
        
        isExportButtonSelected = selectedIndex == 2 && previouslySelectedIndex != selectedIndex
        
        if previouslySelectedIndex == selectedIndex {
            previouslySelectedIndex = nil
        } else {
            previouslySelectedIndex = selectedIndex
        }
    }
}
