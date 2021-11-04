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
  typealias Callback = (ExportAction) -> Void
  var saveCopyButton = SaveCopyVideoButton()
  var shareButton = SaveCopyVideoButton()
  let shareStackView = UIStackView()
  let saveCopyStackView = UIStackView()
  let exportPanel = UIView()
  var topExportPanelConstraint = NSLayoutConstraint()
  var didTapEportViewButton: Callback?
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(exportPanel)
    setUpShareStackView()
    setUpSaveCopyStackView()
    setUpShareButton()
    setUpSaveCopyButton()
    setUpExportView()
  }
  
  func setUpShareStackView() {
    setUpStackView(
      stackView: shareStackView,
      imageName: "square.and.arrow.up",
      headerText: "Share",
      bodyText: "Posts video to social media sites or sends it via email or SMS."
    )
  }
  
  private func setUpSaveCopyStackView() {
    setUpStackView(
      stackView: saveCopyStackView,
      imageName: "doc.on.doc",
      headerText: "Save a copy",
      bodyText: "Creates a copy with changes that you can not undo."
    )
  }
  
  private func setUpShareButton() {
    setUpButton(
      stackView: shareStackView,
      button: shareButton,
      action: #selector(self.openActivityView)
    )
  }
  
  private func setUpSaveCopyButton() {
    setUpButton(
      stackView: saveCopyStackView,
      button: saveCopyButton,
      action: #selector(self.saveVideoCopy)
    )
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
    exportStackView.addArrangedSubview(shareStackView)
    exportStackView.addArrangedSubview(saveCopyStackView)
  }
  
  private func setUpStackView(stackView: UIStackView, imageName: String, headerText: String, bodyText: String) {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.alignment = .center
    let imageView = ExportImageView(systemName: imageName)
    let leftSpacer = UIView()
    let rightSpacer = UIView()
    let labelsStackView = UIStackView()
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false
    labelsStackView.axis = .vertical
    
    stackView.addArrangedSubview(leftSpacer)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(labelsStackView)
    stackView.addArrangedSubview(rightSpacer)
    stackView.setCustomSpacing(0, after: leftSpacer)
    stackView.setCustomSpacing(0, after: labelsStackView)
    
    NSLayoutConstraint.activate ([
      leftSpacer.widthAnchor.constraint(equalToConstant: 16),
      rightSpacer.widthAnchor.constraint(equalTo: leftSpacer.widthAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 20)
    ])
    
    let header = HeaderExportLabel()
    header.text = headerText
    
    let body = BodyExportLabel()
    body.text = bodyText
    
    labelsStackView.addArrangedSubview(header)
    labelsStackView.addArrangedSubview(body)
    labelsStackView.layoutMargins = .init(top: 8, left: 0, bottom: 8, right: 0)
    labelsStackView.isLayoutMarginsRelativeArrangement = true
  }
  
  private func setUpButton(
    stackView: UIStackView,
    button: UIButton,
    action: Selector
  ) {
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: action, for: .touchUpInside)
    stackView.addSubview(button)
    NSLayoutConstraint.activate ([
      button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
      button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
      button.topAnchor.constraint(equalTo: stackView.topAnchor),
      button.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
    ])
  }
  
  @objc func openActivityView() {
    didTapEportViewButton?(.openActivityView)
  }
  
  @objc func saveVideoCopy() {
    didTapEportViewButton?(.saveVideoCopy)
  }
}

internal enum ExportAction {
  case openActivityView
  case saveVideoCopy
}
