//
//  AppDelegate.swift
//  personneldb
//
//  Created by Ronaldo II Dorado on 13/7/17.
//  Copyright © 2017 Ronaldo II Dorado. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain

// MARK:- AppDelegate Life Cycle Methods
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = buildRootViewController()
        window?.makeKeyAndVisible()
        showSignIn()
       
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Auth.signOut()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let signInViewController = window?.rootViewController?.presentedViewController
        if !Auth.isLoggedIn() && signInViewController == nil {
            showSignIn()
        }
    }
}

// MARK:- AppDelegate Private Methods
extension AppDelegate {
    fileprivate func buildRootViewController() -> UIViewController {
        let rootViewController = UINavigationController(rootViewController: PersonnelListViewController())
        rootViewController.navigationBar.isTranslucent = false;
        return rootViewController
    }
    
    fileprivate func showSignIn() {
        window?.rootViewController?.present(SignInViewController(), animated: false, completion: nil)
    }
}
