//
//  VimeoPlayerViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 22/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import WebKit

final class VimeoPlayerViewController: UIViewController, WKUIDelegate {
    let webConfiguration = WKWebViewConfiguration()
    let webView: WKWebView
    let url: URL
    
    init(url: URL) {
        self.url = url
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        webView.uiDelegate = self
        view = webView
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
    private func setUpNavigationBar() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = doneItem
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
