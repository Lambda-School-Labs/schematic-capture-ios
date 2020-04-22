//
//  SignInViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/24/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//
//
import UIKit
import Firebase
import FirebaseStorage
import GoogleSignIn
import SCLAlertView
import WebKit

class SignInViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
   let loginController = LogInController()
    var webView: WKWebView!
//
    override func viewDidLoad() {
        super.viewDidLoad()


        setUpUI()

        // check network connection
//        if Reachability.isConnectedToNetwork() {
//            // if wifi/data is available, setup Google sign in
//            GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//            GIDSignIn.sharedInstance().delegate = self
//            GIDSignIn.sharedInstance()?.presentingViewController = self
//            GIDSignIn.sharedInstance().signIn()
//        } else {
//            // if wifi/data is NOT available, skip the login page and direct to the main page
//            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
//            let alert = SCLAlertView(appearance: appearance)
//            alert.addButton("OK") {
//                self.performSegue(withIdentifier: "HomeVCSegue", sender: nil)
//            }
//            alert.showWarning("No Internet Connection!", subTitle: "Unable to download or upload")
        }
    
//
    func setUpUI() {
        Style.styleFilledButton(signUpButton)
        Style.styleFilledButton(loginButton)

        self.navigationController?.view.backgroundColor = .clear

        loginImage.image = UIImage(imageLiteralResourceName: "OnBoardImage.jpeg")

        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        if let url = Bundle.main.url(forResource: "Pulse-1s-200px", withExtension: "svg") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }



    func startLoadingScreen() {
        guard let webView = webView else { return }

        DispatchQueue.main.async {
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.backgroundColor = .clear
            webView.isOpaque = false
            self.view.addSubview(webView)

            webView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
            webView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
            webView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -15).isActive = true
        }
    }

    func stopLoadingScreen() {
        guard let webView = webView else { return }

        DispatchQueue.main.async {
            webView.removeFromSuperview()
            self.webView = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            if let signUpVC = segue.destination as? SignUpViewController {
                signUpVC.loginController = loginController
            }
        } else if segue.identifier == "LoginSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.loginController = loginController
            }
        } else if segue.identifier == "HomeVCSegue" {
            if let homeVC = segue.destination as? HomeViewController {
                homeVC.loginController = loginController
                homeVC.projectController.user = loginController.user
                homeVC.projectController.bearer = loginController.bearer
            }
        } else if segue.identifier == "GoogleSegue" {
            if let googleVC = segue.destination as? GoogleSignUpViewController {
                googleVC.loginController = loginController
            }
        }
    }
}

