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
    
    lazy var appConfiguration: AppConfiguration = {
        .init(
            clientIdentifier: "feaa04ff48eedc3e6474cf36515591cab2e4f84e",
            clientSecret: "crpqthfLxViJGIMLICoxaShxm68uEWjHsyApn5UpsKvAef/QStz1cC7lC5OIHZXzXdgNQ7OpdkMjKFwd8fAGRr4+hIg8v3FvgJXG3wRKIoMBEfYzdyzdHFVlrqMjGu1I",
            scopes: [.Public],
            keychainService: "KeychainServiceVimeo"
        )
    }()
    
    lazy var vimeoClient: VimeoClient = { .init(appConfiguration: appConfiguration, configureSessionManagerBlock: nil) }()
    
    lazy var authenticationController: AuthenticationController = {
        .init(
            client: vimeoClient,
            appConfiguration: appConfiguration,
            configureSessionManagerBlock: nil
        )
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach {
            self.authenticationController.codeGrant(responseURL: $0.url) { [weak vimeoClient = self.vimeoClient] result in
                switch result
                {
                case .success(let account):
//                    let requestMyVideo = Request<[VIMVideo]>(path: "me/videos")
//                    _ = vimeoClient?.request(requestMyVideo) { result in
//                        switch result {
//                        case let .success(response):
//                            let video: [VIMVideo] = response.model
//                            let url = URL(string: video[0].link!)!
//                            UIApplication.shared.open(url)
////                            print("retrieved video: \(video)")
//                        case let .failure(error):
//                            print("error retrieving video: \(error)")
//                        }
//                    }
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
        let url = authenticationController.codeGrantAuthorizationURL()
        UIApplication.shared.open(url)
    }
}
