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
    lazy var videoCollection = UICollectionView(frame: .zero, collectionViewLayout: VimeoCollectionLayout())
    lazy var videoDataSource = VideoDataSource(collectionView: videoCollection)
    
    var state: State = .unauthorized {
        didSet {
            fetchVideos()
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
        state = vimeoClient.currentAccount == nil ? .unauthorized : .authorized
        NetworkingNotification.authenticatedAccountDidChange.observe(target: self, selector: #selector(handleAuthEvent))
        videoCollection.delegate = self
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
        if let layout = videoCollection.collectionViewLayout as? VimeoCollectionLayout {
            layout.setWidth(width: view.frame.width)
        }
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
    
    private func fetchVideos() {
        if state == .authorized {
            videoDataSource.fetchVideos()
        }
    }
    
    private func setUpVideoCollection() {
        videoCollection.translatesAutoresizingMaskIntoConstraints = false
        videoCollection.backgroundColor = .white
        videoCollection.backgroundView = BackgroundView()
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

extension VimeoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let videoLink = videoDataSource.videos[indexPath.row].link,
            let url = URL(string: videoLink) else { return }
        let vc = VimeoPlayerViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}

extension VimeoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
