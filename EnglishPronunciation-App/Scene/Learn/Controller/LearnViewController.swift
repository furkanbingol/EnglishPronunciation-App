//
//  LearnViewController.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 22.03.2023.
//

import UIKit
import Firebase

class LearnViewController: UIViewController, LearnViewDelegate {
    
    // MARK: - UI Elements
    private var learnView: LearnView = {
        let learnView = LearnView()
        return learnView
    }()
    
    // MARK: - Properties
    var user = User()
    var categories = [Category]()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Learn"
        
        user = UserData.shared.user
        categories = CategoryData.shared.categories
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes?[.font] = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor(hex: "#ffad33")
        let font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
    }
    
    override func loadView() {
        self.view = learnView
        learnView.delegate = self
    }
    
    
    // MARK: - Delegate Functions    
    func categoryTapped(categoryNumber: Int) {
        CategoryData.shared.selectedCategoryNumber = categoryNumber
        
        let vc = LearnWordPageViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }

}
