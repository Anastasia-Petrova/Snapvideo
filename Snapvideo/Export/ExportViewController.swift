//
//  ExportViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 19/10/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import Photos
import UIKit

final class ExportViewController: UIViewController {
  var saveCopyButton = SaveCopyVideoButton()
  var shareButton = SaveCopyVideoButton()
  let shareStackView = UIStackView()
  let saveCopyStackView = UIStackView()
  let exportPanel = UIView()
  var topExportPanelConstraint = NSLayoutConstraint()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpExportView()
    setUpShareStackView()
    setUpSaveCopyStackView()
    setUpShareButton()
    setUpSaveCopyButton()
  }
  
  private func setUpExportView() {
    exportPanel.translatesAutoresizingMaskIntoConstraints = false
    exportPanel.backgroundColor = .white
    topExportPanelConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: exportPanel.topAnchor, constant: -view.safeAreaInsets.bottom)
    
    NSLayoutConstraint.activate ([
      exportPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      exportPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      exportPanel.heightAnchor.constraint(equalToConstant: 100),
      topExportPanelConstraint
    ])
    
    let exportStackView = UIStackView()
    exportStackView.translatesAutoresizingMaskIntoConstraints = false
    exportStackView.axis = .vertical
    exportStackView.distribution = .fillEqually
    exportPanel.addSubview(exportStackView)
    
    NSLayoutConstraint.activate ([
      exportStackView.trailingAnchor.constraint(equalTo: exportPanel.trailingAnchor),
      exportStackView.leadingAnchor.constraint(equalTo: exportPanel.leadingAnchor),
      exportStackView.topAnchor.constraint(equalTo: exportPanel.topAnchor),
      exportStackView.bottomAnchor.constraint(equalTo: exportPanel.bottomAnchor)
    ])
    shareStackView.translatesAutoresizingMaskIntoConstraints = false
    shareStackView.axis = .horizontal
    saveCopyStackView.translatesAutoresizingMaskIntoConstraints = false
    saveCopyStackView.axis = .horizontal
    exportStackView.addArrangedSubview(shareStackView)
    exportStackView.addArrangedSubview(saveCopyStackView)
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
    body.text = "Creates a copy with changes that you can not undo."
    
    labelsStackView.addArrangedSubview(header)
    labelsStackView.addArrangedSubview(body)
    labelsStackView.layoutMargins = .init(top: 8, left: 0, bottom: 8, right: 0)
    labelsStackView.isLayoutMarginsRelativeArrangement = true
  }
  
  private func setUpSaveCopyButton() {
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
  
  private func setUpShareButton() {
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
  
  @objc func openActivityView() {
    //self.isExportViewShown = false
    //self.videoViewController.isActivityIndicatorVisible = true
    
    //    guard let playerItem = videoViewController.player.currentItem else { return }
    
    //    VideoEditor.composeVideo(
    //      choosenFilter: looksViewController.selectedFilter,
    //      asset: playerItem.asset
    //    ) { url in
    //      DispatchQueue.main.async {
    //        self.videoViewController.isActivityIndicatorVisible = false
    //        guard let fileURL = url as NSURL? else { return }
    //        
    //        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
    //        activityVC.setValue("Video", forKey: "subject")
    //        activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact]
    //        self.present(activityVC, animated: true, completion: nil)
    //      }
    //    }
  }
  
  @objc func saveVideoCopy() {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      switch status {
      case .authorized:
        DispatchQueue.main.async {
          self?.saveVideoToPhotos()
        }
      default:
        //TODO: properly handle this. Show error, send to settings, etc.
        print("Photos permissions not granted.")
        return
      }
    }
  }
  
  func saveVideoToPhotos() {
    //isExportViewShown = false
    //    videoViewController.isActivityIndicatorVisible = true
    //    guard let playerItem = videoViewController.player.currentItem else { return }
    //    VideoEditor.saveEditedVideo(
    //        choosenFilter: looksViewController.selectedFilter,
    //        asset: playerItem.asset
    //    ) {
    //        DispatchQueue.main.async {
    //            self.videoViewController.isActivityIndicatorVisible = false
    //        }
    //    }
  }
}
