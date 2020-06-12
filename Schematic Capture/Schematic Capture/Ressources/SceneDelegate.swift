//
//  SceneDelegate.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/23/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData
import SwiftyDropbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var dropboxController = DropboxController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        setupRootViewController()
        NotificationCenter.default.addObserver(self, selector: #selector(dropboxAuthorization(notification:)), name: .dropboxLogin, object: nil)
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    @objc func dropboxAuthorization(notification: Notification) {
        if let info = notification.userInfo {
            if let viewController = info["viewController"] as? UIViewController {
                setupClientsViewController()
//                self.dropboxController.authorizeClient(viewController: viewController)
            }
        }
    }
    
    func setupRootViewController() {
        let navigationController = UINavigationController(rootViewController: LoginViewController())
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func setupClientsViewController() {
        let navigationController = UINavigationController()

        let model = Model<Client>()
        let clientsTableViewController = GenericTableViewController(model: model, parentId: nil, title: "Clients", configure: { (cell, client) in
            cell.textLabel?.text = client.companyName
        }) { (client) in
//            navigationController.push
        }
        clientsTableViewController.title = "Client"
        navigationController.viewControllers = [clientsTableViewController]
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func setupProjectsViewController() {
        let model = Model<Project>()
        let clientsTableViewController = GenericTableViewController(model: model, parentId: nil, title: "Projects", configure: { (cell, client) in
            cell.textLabel?.text = client.name
        }) { (project) in
            print("Client name: \(project.name)")
        }
        clientsTableViewController.title = "Client"
        let navigationController = UINavigationController(rootViewController: clientsTableViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    
    
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if let authResult = DropboxClientsManager.handleRedirectURL(url) {
                print("authResult: \(authResult)")
                switch authResult {
                case .success:
                    print("Success! User is logged into Dropbox.")
                    setupClientsViewController()
                case .cancel:
                    print("Authorization flow was manually canceled by user!")
                case .error(_, let description):
                    print("Error: \(description)")
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

