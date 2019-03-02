//
//  ViewController.swift
//  fbApp
//
//  Created by Ioana Gadinceanu on 12/02/2019.
//  Copyright © 2019 Ioana Gadinceanu. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = UIButton(type: .custom)
        loginButton.backgroundColor = UIColor.darkGray
        loginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        loginButton.center = view.center
        loginButton.setTitle("My Login Button", for: .normal)
        
        loginButton.addTarget (self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
        view.addSubview(loginButton)
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userBirthday, .userPosts, .userPhotos], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                print("Logged in!")
                UserDefaults.standard.set(accessToken.authenticationToken, forKey: "authTokenKey")
                UserDefaults.standard.set(accessToken.userId, forKey: "userIdKey")
                if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                    appdelegate.setRootController()
                }
            }
        }
    }
}
