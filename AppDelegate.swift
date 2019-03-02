//
//  AppDelegate.swift
//  fbApp
//
//  Created by Ioana Gadinceanu on 12/02/2019.
//  Copyright © 2019 Ioana Gadinceanu. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRootController()
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func setRootController() {
        if window == nil { window = UIWindow(frame: UIScreen.main.bounds);
            window?.backgroundColor = .blue}
        
        var controller: UIViewController!
        
        
        if let token = UserDefaults.standard.string(forKey: "authTokenKey") {
            Session.authToken = token
             Session.userId = UserDefaults.standard.string(forKey: "userIdKey")
            controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        } else {
            controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}

