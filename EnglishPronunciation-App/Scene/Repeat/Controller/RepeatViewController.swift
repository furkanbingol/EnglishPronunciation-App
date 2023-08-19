//
//  RepeatViewController.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 24.05.2023.
//

import UIKit

class RepeatViewController: UIViewController, RepeatViewDelegate {
    
    // MARK: - UI Elements
    private var repeatView: RepeatView = {
        let repeatView = RepeatView()
        return repeatView
    }()
    
    
    // MARK: - Properties
    var user = User()
    var categories = [Category]()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repeat"
        
        user = UserData.shared.user
        categories = CategoryData.shared.categories
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes?[.font] = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
    }
    
    override func loadView() {
        self.view = repeatView
        repeatView.delegate = self
    }
    
    
    
    // MARK: - Delegate Function
    func categoryTapped(categoryNumber: Int) {
        CategoryData.shared.selectedCategoryNumberInRepeatPage = categoryNumber
        
        let vc = RepeatWordPageViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
