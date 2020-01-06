import UIKit
import Photos
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PHPhotoLibraryChangeObserver {
    var result: PHFetchResult<PHAsset>?
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        UINavigationBar.appearance().backgroundColor = .black
        PHPhotoLibrary.shared().register(self)
        DispatchQueue.global().async {
            self.result = PHAsset.fetchAssets(with: .video, options: nil)
        }
        setupNotifications()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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

