//
//  SceneDelegate.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 21.03.2023.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let currentUser = Auth.auth().currentUser
        
        // If user is logged in before
        if currentUser != nil {
            let window = UIWindow(windowScene: windowScene)
            
            // Get datas from userDatas.txt and categoryDatas.txt
            let userDataJson = LoginViewController.readFile(fileName: "userDatas")
            let categoriesDataJson = LoginViewController.readFile(fileName: "categoryDatas")
            
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: userDataJson)
                let categories = try decoder.decode([Category].self, from: categoriesDataJson)

                for i in 0...41 {
                    categories[i].categorySmallImage = CategoryData.shared.smallImageNames[i]
                    categories[i].categoryLargeImage = CategoryData.shared.largeImageNames[i]
                }
                
                UserData.shared.user = user
                CategoryData.shared.categories = categories
                
            } catch {
                print("JSON decoding error: \(error)")
            }

            let vc = MyTabBarController()
            vc.selectedIndex = 0
            window.rootViewController = vc
            self.window = window
            window.makeKeyAndVisible()
        }
        else {
            let window = UIWindow(windowScene: windowScene)
            let viewController = LoginViewController(nibName: "FirstScreenView", bundle: nil)
            window.rootViewController = viewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

