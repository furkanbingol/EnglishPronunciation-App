//
//  RepeatWordPageViewController.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 27.05.2023.
//

import UIKit
import AVFoundation

class RepeatWordPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, AVSpeechSynthesizerDelegate {

    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView! {
        willSet {
            newValue.delegate = self
            newValue.dataSource = self
            newValue.register(WordTableViewCell.nib(), forCellReuseIdentifier: WordTableViewCell.identifier)
        }
    }
    @IBOutlet weak var zeroWordsLearnedView: UIView! {
        willSet {
            newValue.layer.cornerRadius = 40
            newValue.isHidden = true
        }
    }
    
    // MARK: - Properties
    var user = User()
    var categories = [Category]()
    var selectedCategoryNumber = 0
    var selectedCategory = Category()
    var userLearnedWordsInSelectedLevel = [Word]()       // userA1LearnedWords or userA2LearnedWords etc...
    var userLearnedWordsInSelectedCategory = [Word]()
    
    var isAudioButtonTapped = false
    let synthesizer = AVSpeechSynthesizer()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.delegate = self
        configureModels()
        configureLearnedWords()
        adjustUI()
    }
    
    
    // MARK: - Functions
    private func adjustUI() {
        title = selectedCategory.categoryName       // Navigation Bar Title
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.delegate = self
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureModels() {
        user = UserData.shared.user
        categories = CategoryData.shared.categories
        
        selectedCategoryNumber = CategoryData.shared.selectedCategoryNumberInRepeatPage
        selectedCategory = categories[selectedCategoryNumber]
        
        switch selectedCategory.categoryLevel! {
            case "A1": userLearnedWordsInSelectedLevel = user.userA1LearnedWords!
            case "A2": userLearnedWordsInSelectedLevel = user.userA2LearnedWords!
            case "B1": userLearnedWordsInSelectedLevel = user.userB1LearnedWords!
            case "B2": userLearnedWordsInSelectedLevel = user.userB2LearnedWords!
            case "C1": userLearnedWordsInSelectedLevel = user.userC1LearnedWords!
            case "C2": userLearnedWordsInSelectedLevel = user.userC2LearnedWords!
            default: print("error")
        }
    }
    
    private func configureLearnedWords() {
        for wordInSelectedCategory in selectedCategory.categoryWords! {
            for word in userLearnedWordsInSelectedLevel {
                if wordInSelectedCategory == word {
                    userLearnedWordsInSelectedCategory.append(word)
                    break
                }
            }
        }
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userLearnedWordsInSelectedCategory.count == 0 {
            self.zeroWordsLearnedView.isHidden = false
            self.tableView.isHidden = true
            return 0
        }
        else {
            self.zeroWordsLearnedView.isHidden = true
            self.tableView.isHidden = false
            return userLearnedWordsInSelectedCategory.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WordTableViewCell.identifier, for: indexPath) as? WordTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureWordCell(with: userLearnedWordsInSelectedCategory[indexPath.row])
        
        // tag: An integer that you can use to 'identify view objects' in your application
        cell.audioButton.tag = indexPath.row
        cell.audioButton.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        
        cell.micButton.tag = indexPath.row
        cell.micButton.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    @objc private func audioButtonTapped(_ sender: UIButton) {
        if isAudioButtonTapped {
            return
        }
        isAudioButtonTapped = true
        
        let word = userLearnedWordsInSelectedCategory[sender.tag]
        
        let utterance = AVSpeechUtterance(string: word.wordEnglishMeaning ?? "")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) { [weak self] in
            self?.isAudioButtonTapped = false
        }
    }
    
    @objc private func micButtonTapped(_ sender: UIButton) {
        let word = userLearnedWordsInSelectedCategory[sender.tag]
        
        CategoryData.shared.option = "fromRepeatPage"
        CategoryData.shared.selectedWordInRepeatPage = word
        
        tabBarController?.tabBar.tintColor = .systemRed
        tabBarController?.selectedIndex = 2
    }
    
}
