//
//  AppDelegate.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // create because we dont have Main.storyboard
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    if AuthManager.shared.isSignedIn {
      AuthManager.shared.refreshIfNeeded(completion: nil)
      
      window.rootViewController = TabBarViewController() // assing the TabBarViewController as the entry point
    } else {
      let navVC = UINavigationController(rootViewController: WelcomeViewController())
      
      // set the title to large
      navVC.navigationBar.prefersLargeTitles = true
      navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
      
      window.rootViewController = navVC
    }
    
    window.makeKeyAndVisible()
    self.window = window
    
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
