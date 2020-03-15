//
//  SceneDelegate.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
//        start()
        test()
    }
    
    private func start() {
        let vc = HomeViewController()
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func test() {
        let vc = UIViewController()
        vc.view.backgroundColor = .black
        let navigationController = UINavigationController(rootViewController: vc)
        let view = ParameterListView(parameters: [
            ParameterListView.Parameter(name: "Hello", value: "10"),
            ParameterListView.Parameter(name: "World World World", value: "20"),
            ParameterListView.Parameter(name: "Hello", value: "10"),
            ParameterListView.Parameter(name: "World World World", value: "20"),
            ParameterListView.Parameter(name: "Hello", value: "10"),
            ParameterListView.Parameter(name: "World World World", value: "20"),
            ParameterListView.Parameter(name: "Hello", value: "10"),
            ParameterListView.Parameter(name: "World World World", value: "20"),
        ]) { _ in }
        //    view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.6),
            view.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        
        for i in (1...30) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                view.translateY(CGFloat(i * 1))
            }
        }
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

