//
//  ParameterListView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 23/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class ParameterListView: UIView {
    typealias DidSelectParameterCallback = (Parameter) -> Void
    var parameters: [Parameter]
    let stackView = UIStackView()
    let selectedElementView = UIView()
    
    let callback: DidSelectParameterCallback
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    init(parameters: [Parameter], callback: @escaping DidSelectParameterCallback) {
        self.parameters = parameters
        self.callback = callback
        super.init(frame: .zero)
        setUpStackView()
        setUpSelectedElementView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topConstraint?.constant = stackView.frame.height
        bottomConstraint?.constant = 0
    }
    
    func setUpStackView() {
        parameters
            .map(makeParameterButton)
            .forEach(stackView.addArrangedSubview)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        let topConstraint = topAnchor.constraint(equalTo: stackView.topAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
        self.bottomConstraint = bottomConstraint
        self.topConstraint = topConstraint
    }
    
    func makeParameterButton(_ parameter: Parameter) -> UIView {
        let container = UIView()
        let stackView = UIStackView()
        let button = UIButton()
        let name = UILabel()
        let value = UILabel()
        
        name.text = parameter.name
        value.text = parameter.value
        
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(value)
        stackView.distribution = .equalSpacing
        
        button.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        container.addSubview(button)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            button.topAnchor.constraint(equalTo: container.topAnchor),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])
        
        return stackView
    }

    func setUpSelectedElementView() {
        selectedElementView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedElementView)
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: selectedElementView.centerYAnchor),
            leadingAnchor.constraint(equalTo: selectedElementView.leadingAnchor),
            trailingAnchor.constraint(equalTo: selectedElementView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOffsetY(_ offsetY: CGFloat) {
//        scrollView.setContentOffset(CGPoint(
//            x: scrollView.contentOffset.x,
//            y: offsetY), animated: true
//        )
    }
    
    struct Parameter {
        let name: String
        var value: String
    }
}
