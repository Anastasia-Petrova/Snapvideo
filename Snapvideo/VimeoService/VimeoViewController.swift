//
//  VimeoViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 09/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import VimeoNetworking

final class VimeoViewController: UIViewController {
    let loginButton = UIButton()
    let videoCollection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var state: State = .unauthorized {
        didSet {
            DispatchQueue.main.async {
                self.view.setNeedsLayout()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpLiginButton()
        setUpVideoCollection()
        NetworkingNotification.authenticatedAccountDidChange.observe(target: self, selector: #selector(handleAuthEvent))
    }
    
    deinit {
        NetworkingNotification.authenticatedAccountDidChange.removeObserver(target: self)
    }
    
    @objc private func handleAuthEvent(_ notification: NSNotification) {
        let account = notification.object as? VIMAccount
        state = account == nil ? .unauthorized : .authorized
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViews()
    }
    
    private func updateViews() {
        switch state {
        case .authorized:
            loginButton.isHidden = true
            videoCollection.isHidden = false
        case .unauthorized:
            loginButton.isHidden = false
            videoCollection.isHidden = true
        }
    }
    
    private func setUpVideoCollection() {
        videoCollection.translatesAutoresizingMaskIntoConstraints = false
        videoCollection.backgroundColor = .red
        view.addSubview(videoCollection)
        NSLayoutConstraint.activate ([
            videoCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoCollection.topAnchor.constraint(equalTo: view.topAnchor),
            videoCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setUpLiginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        loginButton.titleLabel?.font = .systemFont(ofSize: 20)
        loginButton.setTitle("LOG IN TO VIMEO", for: .normal)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        NSLayoutConstraint.activate ([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func handleLogin() {
        let url = authenticationController.codeGrantAuthorizationURL()
        UIApplication.shared.open(url)
    }
}

extension VimeoViewController {
    enum State {
        case unauthorized
        case authorized
    }
}
