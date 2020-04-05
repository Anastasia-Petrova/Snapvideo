//
//  AppDelegate.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import Photos
import UserNotifications
import VimeoNetworking

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, PHPhotoLibraryChangeObserver {
    var result: PHFetchResult<PHAsset>?
    let center = UNUserNotificationCenter.current()
    
    lazy var authenticationController: AuthenticationController = {
        let appConfiguration = AppConfiguration(
            clientIdentifier: "feaa04ff48eedc3e6474cf36515591cab2e4f84e",
            clientSecret: "feaa04ff48eedc3e6474cf36515591cab2e4f84e",
            scopes: [.Private, .Upload],
            keychainService: "KeychainServiceVimeo"
        )
        
        let vimeoClient = VimeoClient(appConfiguration: appConfiguration, configureSessionManagerBlock: nil)
        
        return AuthenticationController(client: vimeoClient, appConfiguration: appConfiguration, configureSessionManagerBlock: nil)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PHPhotoLibrary.shared().register(self)
        DispatchQueue.global().async {
            self.result = PHAsset.fetchAssets(with: .video, options: nil)
        }
        setupNotifications()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        authenticationController.codeGrant(responseURL: url) { result in
            switch result
            {
            case .success(let account):
                print("authenticated successfully: \(account)")
            case .failure(let error):
                print("failure authenticating: \(error)")
            }
        }

        return true
    }
    
    private func startVimeo() {
        let URL = authenticationController.codeGrantAuthorizationURL()
        UIApplication.shared.open(URL)
    }
    
    private func setupNotifications() {
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        let tapAction = UNNotificationAction(identifier: "tapAction", title: "Open Library")
        let category = UNNotificationCategory(identifier: "NotificationCategory",
                                              actions: [tapAction],
                                              intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Success!"
        content.body = "Video was saved."
        content.sound = UNNotificationSound.default
        let date = Date(timeIntervalSinceNow: 1)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let result = self.result else { return }
        if let changes = changeInstance.changeDetails(for: result) {
            self.result = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                if let inserted = changes.insertedIndexes, inserted.count > 0 {
                    self.scheduleNotification()
                }
            }
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    fileprivate func tapAction() {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            UIApplication.shared.open(URL(string:"photos-redirect://")!)
        }
    }
}

