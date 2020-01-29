//
//  SignInViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/24/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {
    
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let loginController = LogInController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // check network connection
        if Reachability.isConnectedToNetwork() {
            setUpUI()
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        } else {
            let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
        }
    }

    func setUpUI() {
        Style.styleFilledButton(signUpButton)
        Style.styleHollowButton(loginButton)
    }

}

