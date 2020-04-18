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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpLiginButton()
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
