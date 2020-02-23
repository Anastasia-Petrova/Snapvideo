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
    var parameters: [Parameter] = []
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let selectedElementView = UIView()
    
    let callback: DidSelectParameterCallback
    
    init(callback: @escaping DidSelectParameterCallback) {
        self.callback = callback
        super.init(frame: .zero)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOffsetY(_ offsetY: CGFloat) {
        scrollView.setContentOffset(CGPoint(
            x: scrollView.contentOffset.x,
            y: offsetY), animated: true
        )
    }
    
    struct Parameter {
        let name: String
        var value: String
    }
}
