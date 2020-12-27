//
//  AdjustmentsViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 13/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import AVFoundation

final class AdjustmentsViewController<SelectedTool: Tool>: UIViewController {
    let toolBar = UIToolbar(
        frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44))
    )
    lazy var parameterListItem = UIBarButtonItem(
        image: UIImage(systemName: "slider.horizontal.3"),
        style: .plain,
        target: self,
        action: #selector(showParameterList)
    )
    let asset: AVAsset
    var tool: SelectedTool
    
    let videoViewController: VideoViewController
    let parameterlistView: ParameterListView
    let sliderView: AdjustmentSliderView
    
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?
                                            .withRenderingMode(.alwaysTemplate))
    
    var previousTranslation: CGPoint = .zero
    var isVerticalPan = false
    
    lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePanGesture)
    )
    
    var trackDuration: Float {
        guard let trackDuration = videoViewController.player.currentItem?.asset.duration else {
            return 0
        }
        return Float(CMTimeGetSeconds(trackDuration))
    }
    
    init(url: URL, tool: SelectedTool) {
        asset = AVAsset(url: url)
        self.tool = tool
        videoViewController = VideoViewController(asset: asset)
        
        let names = tool.allParameters.map(\.description)
        let values = tool.allParameters.map(tool.value)
        
        let parameters = zip(names, values).map {
            ParameterListView.Parameter(name: $0.0, value: $0.1)
        }
        parameterlistView = ParameterListView(parameters: parameters)
        sliderView = AdjustmentSliderView(
            name: names.first ?? "",
            value: values.first ?? 0.0 //TODO: Use NonEmpty
        )
       
        super.init(nibName: nil, bundle: nil)
        sliderView.didChangeValue = { [weak self] value in
            guard let self = self,
                  let parameter = SelectedTool.Parameter(string: self.sliderView.name) else { return }
            
            self.tool.setValue(value: value, for: parameter)
            self.parameterlistView.setParameter(ParameterListView.Parameter(name: parameter.description, value: value))
        }
        parameterlistView.didSelectParameter = { [weak self] parameter in
            self?.sliderView.name = parameter.name
            self?.sliderView.percent = parameter.value
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(videoViewController.view)
        view.addSubview(sliderView)
        view.addSubview(parameterlistView)
        view.addSubview(toolBar)
        
        setUpVideoViewController()
        setUpSliderView()
        setUpToolBar()
        setUpParameterListView()
        setUpPanGestureRecognizer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpSliderView() {
        sliderView.translatesAutoresizingMaskIntoConstraints = false 
        NSLayoutConstraint.activate([
            sliderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            sliderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            sliderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func setUpParameterListView() {
        parameterlistView.isHidden = true
        parameterlistView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parameterlistView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            parameterlistView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            parameterlistView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setUpToolBar() {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        func spacer() -> UIBarButtonItem {
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        let cancelItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(cancelAdjustment))
        
        let doneItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(applyAdjustment))
        
        let items = [cancelItem, spacer(), parameterListItem, spacer(), doneItem]
        toolBar.tintColor = .darkGray
        toolBar.setItems(items, animated: false)
        
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setUpVideoViewController() {
        videoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            videoViewController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            videoViewController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            videoViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            videoViewController.view.bottomAnchor.constraint(equalTo: toolBar.topAnchor)
        ])
    }
    
    private func setUpPanGestureRecognizer() {
        videoViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: videoViewController.view)
         
        if recognizer.state == .began {
            let velocity = recognizer.velocity(in: self.view)
            isVerticalPan = abs(velocity.y) > abs(velocity.x) ? true : false
        }
        if isVerticalPan {
            updateParameterList(translation: translation, state: recognizer.state)
        } else {
            updateSlider(translation: translation, state: recognizer.state)
        }
    }
    
    private func updateParameterList(translation: CGPoint, state: UIGestureRecognizer.State) {
        let deltaY = previousTranslation.y - translation.y
        previousTranslation.y = translation.y
        parameterlistView.translateY(deltaY)
        switch state {
        case .began:
            parameterlistView.setHiddenAnimated(false, duration: 0.3)
        case .ended:
            parameterlistView.setHiddenAnimated(true, duration: 0.2)
            previousTranslation = .zero
            parameterListItem.tintColor = .darkGray
        default: break
        }
    }
    
    private func updateSlider(translation: CGPoint, state: UIGestureRecognizer.State) {
        let deltaX = previousTranslation.x - translation.x
        previousTranslation.x = translation.x
        sliderView.setDelta(deltaX)
        switch state {
        case .ended:
            previousTranslation = .zero
        default: break
        }
    }
    
    @objc func cancelAdjustment() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showParameterList() {
        parameterListItem.tintColor = parameterlistView.isHidden ? .systemBlue : .darkGray
        let duration = parameterlistView.isHidden ? 0.3 : 0.2
        parameterlistView.setHiddenAnimated(!parameterlistView.isHidden, duration: duration)
    }
    
    @objc func applyAdjustment() {
        //TODO: apply
    }
}
