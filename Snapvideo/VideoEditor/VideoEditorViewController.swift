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
    var videoFileAsset: AVAsset {
        didSet {
            videoViewController.asset = videoFileAsset
            generatePreviewImages()
        }
    }
    
    let looksPanel = UIView()
    
    var topExportConstraint = NSLayoutConstraint()
    var topLooksConstraint = NSLayoutConstraint()
    var topToolsConstraint = NSLayoutConstraint()
    
    //child view controllers
    let exportViewController: ExportViewController
    let looksViewController: LooksViewController
    let toolsViewController: ToolsViewController
    let videoViewController: VideoViewController
    
    let tabBar = TabBar(items: "LOOKS", "TOOLS", "EXPORT")
    var selectedFilter: Filter = PassthroughFilter()
    var selectedFilterIndex: Int
    var pendingFilterIndex: Int?
    let coverView = UIView()

    var cancelButton = LooksViewButton(imageName: "cancel-solid")
    var doneButton = LooksViewButton(imageName: "done-solid")

    var spacerHeight = CGFloat()
    let shareStackView = UIStackView()
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
                openTools()
            } else {
                closeTools()
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
        guard let trackDuration = videoViewController.player.currentItem?.asset.duration else {
            return 0
        }
        return Float(CMTimeGetSeconds(trackDuration))
    }
    

    init(url: URL, selectedFilterIndex: Int, filters: [Filter], tools: [ToolEnum]) {
        videoFileAsset = AVAsset(url: url)
        self.selectedFilterIndex = selectedFilterIndex
        videoViewController = VideoViewController(asset: videoFileAsset)
        toolsViewController = ToolsViewController(tools: tools)
        looksViewController = LooksViewController(
            itemSize: itemSize,
            selectedFilterIndex: selectedFilterIndex,
            filters: filters
        )
        exportViewController = ExportViewController()
        
        super.init(nibName: nil, bundle: nil)
        addChild(looksViewController)
        looksViewController.didMove(toParent: self)
        looksViewController.didSelectLook = { [weak self] newIndex, previousIndex in
            guard let self = self else { return }
            let hasChangedSelectedFilter = newIndex != self.selectedFilterIndex
            self.videoViewController.playerView.filter = filters[newIndex]
            self.videoViewController.backgroundVideoView.filter = filters[newIndex] + BlurFilter(blurRadius: 100)
            self.doneButton.isEnabled = hasChangedSelectedFilter
            self.tabBar.isHidden = hasChangedSelectedFilter
            guard newIndex != previousIndex && hasChangedSelectedFilter else { return }
            self.selectedFilter = filters[newIndex]
            self.pendingFilterIndex = newIndex
        }
        toolsViewController.didSelectToolCallback = { [weak self] index in
            self?.presentAdjustmentsScreen(url: url, tool: tools[index])
        }
        exportViewController.didTapExportViewButton = { [weak self] action in
          switch action {
          case .openActivityView:
            self?.openActivityView()
          case .saveVideoCopy:
            self?.saveVideoCopy()
          }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        generatePreviewImages()
        
        view.addSubview(videoViewController.view)
        view.addSubview(looksPanel)
        view.addSubview(toolsViewController.view)
        view.addSubview(exportViewController.view)
        view.addSubview(tabBar)
        
        setUpVideoViewController()
        setUpLooksView()
        setUpCancelButton()
        setUpDoneButton()
        setUpToolsView()
        setUpExportView()
        setUpTabBar()
    }
    
    private func generatePreviewImages() {
        AssetImageGenerator.getThumbnailImageFromVideoAsset(
            asset: videoFileAsset,
            maximumSize: itemSize.applying(.init(scaleX: UIScreen.main.scale, y: UIScreen.main.scale)),
            completion: { [weak self] image in
                DispatchQueue.main.async {
                    self?.previewImage = image
                }
            }
        )
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
            videoViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabBar.topAnchor.constraint(greaterThanOrEqualTo: videoViewController.view.bottomAnchor)
        ])
    }
   
    func setUpLooksView() {
        looksPanel.translatesAutoresizingMaskIntoConstraints = false
        looksPanel.backgroundColor = .white
        topLooksConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: looksPanel.topAnchor, constant: -view.safeAreaInsets.bottom)
        let looksViewHeight: CGFloat = 100.0
        let bottomConstraint = looksPanel.topAnchor.constraint(equalTo: videoViewController.view.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate ([
            looksPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            looksPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            looksPanel.heightAnchor.constraint(equalTo: tabBar.heightAnchor, constant: looksViewHeight),
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
        
        looksPanel.addSubview(collectionStackView)
        collectionStackView.addArrangedSubview(looksViewController.view)
        
        let line = UIView()
        line.backgroundColor = .darkGray
        collectionStackView.addArrangedSubview(line)
        
        let spacer = UIView()
        spacer.backgroundColor = .white
        collectionStackView.addArrangedSubview(spacer)
        collectionStackView.addArrangedSubview(buttonsStackView)
        
        NSLayoutConstraint.activate ([
            collectionStackView.trailingAnchor.constraint(equalTo: looksPanel.trailingAnchor),
            collectionStackView.leadingAnchor.constraint(equalTo: looksPanel.leadingAnchor),
            collectionStackView.topAnchor.constraint(equalTo: looksPanel.topAnchor),
            collectionStackView.bottomAnchor.constraint(equalTo: looksPanel.bottomAnchor),
            looksViewController.view.heightAnchor.constraint(equalToConstant: looksViewHeight),
            line.heightAnchor.constraint(equalToConstant: 0.4)
        ])
    }
    
    func setUpToolsView() {
        toolsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        topToolsConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: toolsViewController.view.topAnchor)
        
        NSLayoutConstraint.activate ([
            toolsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolsViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            topToolsConstraint
        ])
    }
  
    func setUpExportView() {
      exportViewController.view.translatesAutoresizingMaskIntoConstraints = false
      topExportConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: exportViewController.view.topAnchor, constant: -view.safeAreaInsets.bottom)
      
      NSLayoutConstraint.activate ([
        exportViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        exportViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        exportViewController.view.heightAnchor.constraint(equalToConstant: 100),
        topExportConstraint
      ])
  }
    
    func setUpCancelButton() {
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        NSLayoutConstraint.activate ([
            cancelButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        cancelButton.addTarget(self, action: #selector(self.discardLooks), for: .touchUpInside)
    }
    
    func setUpDoneButton() {
        doneButton.isEnabled = false
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        NSLayoutConstraint.activate ([
            doneButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        doneButton.addTarget(self, action: #selector(self.saveFilter), for: .touchUpInside)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
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
        topExportConstraint.constant = exportViewController.view.frame.height + tabBar.frame.height
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
    
    public func openTools() {
        self.view.layoutIfNeeded()
        isToolsViewShown = true
        topToolsConstraint.constant = toolsViewController.view.frame.height + tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func closeTools() {
        self.view.layoutIfNeeded()
        topToolsConstraint.constant = -self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func handleAdjustmentsResult(_ result: Result<URL, AVAssetExportSession.Error>) {
        switch result {
        case let .success(url):
          self.videoFileAsset = AVAsset(url: url)
        
        case let .failure(error):
          print(error) //TODO: add proper handling
        }
    }
  
    private func presentAdjustmentsScreen(url: URL, tool: ToolEnum) {
        switch tool {
        case let .vignette(tool),
             let .blur(tool):
            let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
                self?.handleAdjustmentsResult(result)
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            isToolsViewShown = false
        case let .colourCorrection(tool):
            let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
                self?.handleAdjustmentsResult(result)
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            isToolsViewShown = false
        case let .sharpenTool(tool):
          let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
              self?.handleAdjustmentsResult(result)
          }
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .overCurrentContext
          present(vc, animated: true, completion: nil)
          isToolsViewShown = false
        case let .exposureTool(tool):
          let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
              self?.handleAdjustmentsResult(result)
          }
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .overCurrentContext
          present(vc, animated: true, completion: nil)
          isToolsViewShown = false
        case let .noiseReductionTool(tool):
          let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
              self?.handleAdjustmentsResult(result)
          }
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .overCurrentContext
          present(vc, animated: true, completion: nil)
          isToolsViewShown = false
         case let .highlightShadowTool(tool):
          let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
              self?.handleAdjustmentsResult(result)
          }
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .overCurrentContext
          present(vc, animated: true, completion: nil)
          isToolsViewShown = false
        case let .vibranceTool(tool):
          let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
              self?.handleAdjustmentsResult(result)
          }
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .overCurrentContext
          present(vc, animated: true, completion: nil)
          isToolsViewShown = false
        case let .straightenTool(tool):
          let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
              self?.handleAdjustmentsResult(result)
          }
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .overCurrentContext
          present(vc, animated: true, completion: nil)
          isToolsViewShown = false
        case let .cropTool(tool):
          let vc = AdjustmentsViewController(url: url, tool: tool) { [weak self] result in
              self?.handleAdjustmentsResult(result)
          }
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .overCurrentContext
          present(vc, animated: true, completion: nil)
          isToolsViewShown = false
        }
    }
    
    private func resetToDefaultFilter() {
        pendingFilterIndex = nil
        looksViewController.deselectFilter()
    }
    
    func openActivityView() {
        self.isExportViewShown = false
        self.videoViewController.isActivityIndicatorVisible = true

        guard let playerItem = videoViewController.player.currentItem else { return }

        VideoEditor
          .exportSession(filter: looksViewController.selectedFilter, asset: playerItem.asset)?
          .export { result in
            DispatchQueue.main.async {
                self.videoViewController.isActivityIndicatorVisible = false
              switch result {
              case let .success(url):
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityVC.setValue("Video", forKey: "subject")
                activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact]
                self.present(activityVC, animated: true, completion: nil)
              case let .failure(error):
                print(error) //TODO: add proper handling
              }
            }
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
        if let pendingFilterIndex = looksViewController.currentlySelectedFilterIndex {
            selectedFilterIndex = pendingFilterIndex
            looksViewController.initiallySelectedFilterIndex = pendingFilterIndex
        }
        looksViewController.currentlySelectedFilterIndex = nil
        pendingFilterIndex = nil
    }
    
    func saveVideoCopy() {
        appDelegate.setupNotifications { [weak self] _ in
            DispatchQueue.main.async {
                self?.saveVideoToPhotos()
            }
        }
    }
    
    func saveVideoToPhotos() {
        isExportViewShown = false
        videoViewController.isActivityIndicatorVisible = true
        guard let playerItem = videoViewController.player.currentItem else { return }
        VideoEditor.saveEditedVideo(
            filter: looksViewController.selectedFilter,
            asset: playerItem.asset
        ) {
            DispatchQueue.main.async {
                self.videoViewController.isActivityIndicatorVisible = false
            }
        }
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
