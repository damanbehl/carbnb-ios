//
//  AppDelegate.swift
//  CarRental
//
//   on 22/12/21.
//

import UIKit
@_exported import Firebase
@_exported import FirebaseFirestore
@_exported import SDWebImage
@_exported import FirebaseStorage
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var db : Firestore!
    static let shared : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        FirebaseApp.configure()
        db = Firestore.firestore()
        let settings = db.settings
        
        //settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        
        UserDefaults.standard.set(false, forKey: UserDefaults.Keys.currentUser)
        UserDefaults.standard.synchronize()
        if UserDefaults.standard.bool(forKey: UserDefaults.Keys.currentUser) {
            UIApplication.shared.setHome()
        }
        
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


}

