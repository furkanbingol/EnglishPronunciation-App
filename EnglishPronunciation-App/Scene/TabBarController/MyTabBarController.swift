//
//  MyTabBarController.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 22.03.2023.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        configure()
    }
    
    
    func configure() {
        let vc1 = UINavigationController(rootViewController: LearnViewController())
        let vc2 = UINavigationController(rootViewController: RepeatViewController())
        let vc3 = UINavigationController(rootViewController: PronunciationViewController())
        let vc4 = UINavigationController(rootViewController: ProfileViewController())
                
        vc1.title = "Learn"
        vc2.title = "Repeat"
        vc3.title = "Pronunciation"
        vc4.title = "Profile"
                
        vc4.navigationBar.prefersLargeTitles = true
        
        
        self.setViewControllers([vc1, vc2, vc3, vc4], animated: false)
        self.modalPresentationStyle = .fullScreen
        

        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(named: "learn")
        items[1].image = UIImage(named: "repeat-icon")
        items[2].image = UIImage(named: "microphone")
        items[3].image = UIImage(named: "profile")
        
        tabBar.tintColor = UIColor(hex: "#ffad33")
        tabBar.barTintColor = UIColor(hex: "#030303")
        tabBar.backgroundColor = UIColor(hex: "#171717")
    }
    
    
    // TabBar Item'lara tıklandığında oluşacak animasyon
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController),
            let tabItems = tabBarController.tabBar.items {
                
                let currentTabItem = tabItems[index]
                let tabItemView = currentTabItem.value(forKey: "view") as? UIView
                
                UIView.animate(withDuration: 0.2, animations: {
                    tabItemView?.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
                    if index == 0 {
                        self.tabBar.tintColor = UIColor(hex: "#ffad33")
                    } else if index == 1 {
                        self.tabBar.tintColor = .systemGreen
                    } else if index == 2 {
                        self.tabBar.tintColor = .systemRed
                    } else {
                        self.tabBar.tintColor = UIColor(hex: "#bf80ff")
                    }
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        tabItemView?.transform = .identity
                    })
                })
        }
        
        return true
    }
    
}

