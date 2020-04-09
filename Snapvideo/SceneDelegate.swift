//
//  SceneDelegate.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import VimeoNetworking

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    lazy var authenticationController: AuthenticationController = {
        let appConfiguration = AppConfiguration(
            clientIdentifier: "feaa04ff48eedc3e6474cf36515591cab2e4f84e",
            clientSecret: "crpqthfLxViJGIMLICoxaShxm68uEWjHsyApn5UpsKvAef/QStz1cC7lC5OIHZXzXdgNQ7OpdkMjKFwd8fAGRr4+hIg8v3FvgJXG3wRKIoMBEfYzdyzdHFVlrqMjGu1I",
            scopes: [.Public],
            keychainService: "KeychainServiceVimeo"
        )
        
        let vimeoClient = VimeoClient(appConfiguration: appConfiguration, configureSessionManagerBlock: nil)
        
        return AuthenticationController(client: vimeoClient, appConfiguration: appConfiguration, configureSessionManagerBlock: nil)
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach {
            self.authenticationController.codeGrant(responseURL: $0.url) { result in
                switch result
                {
                case .success(let account):
                    print("authenticated successfully: \(account)")
                case .failure(let error):
                    print("failure authenticating: \(error)")
                }
            }
        }
    }
    
    private func start() {
        let vc = HomeViewController()
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    public func startVimeo() {
        let URL = authenticationController.codeGrantAuthorizationURL()
        UIApplication.shared.open(URL)
    }
}
