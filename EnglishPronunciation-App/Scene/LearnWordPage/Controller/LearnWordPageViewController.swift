//
//  LearnWordPageViewController.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 10.05.2023.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseFirestore

class LearnWordPageViewController: UIViewController, UINavigationControllerDelegate, AVSpeechSynthesizerDelegate, MyAlertViewDelegate {
    
    let firestoreDatabase = Firestore.firestore()
    
    // MARK: - UI Elements
    @IBOutlet weak var myView: UIView! {
        willSet {
            newValue.layer.cornerRadius = 30
            newValue.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var englishMeaningLabel: UILabel!
    @IBOutlet weak var turkishMeaningLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    
    
    // MARK: - Properties
    private var congratsAlertView: MyAlertView = {
        let congratsAlertView = MyAlertView()
        return congratsAlertView
    }()
    
    var user = User()
    var category = Category()                // selected category Array
    var categoryWordsSet = Set<Word>()       // selected category Words Set (UNLEARNED WORDS Set)
    var selectedWord = Word()
    
    var isFlipped = false
    var isAudioButtonTapped = false
    let synthesizer = AVSpeechSynthesizer()
    
    // Total words of all levels
    var totalNumberOfA1Words = 0
    var totalNumberOfA2Words = 0
    var totalNumberOfB1Words = 0
    var totalNumberOfB2Words = 0
    var totalNumberOfC1Words = 0
    var totalNumberOfC2Words = 0
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.delegate = self
        user = UserData.shared.user
        category = CategoryData.shared.categories[CategoryData.shared.selectedCategoryNumber]
        
        calculateTotalWordsOfLevels()
        adjustUnlearnedWords()
        adjustUI()
    }
    
    
    func adjustUnlearnedWords() {
        let categoryNumber = CategoryData.shared.selectedCategoryNumber
        
        for word in category.categoryWords! {
            categoryWordsSet.insert(word)
        }
        
        
        var words = [Word]()
        if categoryNumber < 8 { words = user.userA1LearnedWords! }          // A1
        else if categoryNumber < 15 { words = user.userA2LearnedWords! }    // A2
        else if categoryNumber < 24 { words = user.userB1LearnedWords! }    // B1
        else if categoryNumber < 30 { words = user.userB2LearnedWords! }    // B2
        else if categoryNumber < 38 { words = user.userC1LearnedWords! }    // C1
        else if categoryNumber < 42 { words = user.userC2LearnedWords! }    // C2
        
        for word in words {
            if categoryWordsSet.contains(word) {
                categoryWordsSet.remove(word)
            }
        }
        
        
    }
    
    func adjustUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.delegate = self
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
        
        subjectLabel.text = category.categoryName!
        turkishMeaningLabel.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        myView.addGestureRecognizer(tapGesture)
        
        
        if categoryWordsSet.count == 0 {
            // The category already completed
            myView.isHidden = true
            rightButton.isHidden = true
            leftButton.isHidden = true
            rightLine.isHidden = true
            bottomLine.isHidden = true
            englishMeaningLabel.isHidden = true
            turkishMeaningLabel.isHidden = true
            audioButton.isHidden = true
            
            self.showCongratsAlert()
        } else {
            // Showing randomly chosen word
            selectedWord = categoryWordsSet.randomElement()!
            englishMeaningLabel.text = selectedWord.wordEnglishMeaning!
            turkishMeaningLabel.text = selectedWord.wordTurkishMeaning!
        }
        
    }
    
    private func calculateTotalWordsOfLevels() {
        let categories = CategoryData.shared.categories
        
        totalNumberOfA1Words = categories[0].categoryWords!.count + categories[1].categoryWords!.count +
                               categories[2].categoryWords!.count + categories[3].categoryWords!.count +
                               categories[4].categoryWords!.count + categories[5].categoryWords!.count +
                               categories[6].categoryWords!.count + categories[7].categoryWords!.count
        
        totalNumberOfA2Words = categories[8].categoryWords!.count + categories[9].categoryWords!.count +
                               categories[10].categoryWords!.count + categories[11].categoryWords!.count +
                               categories[12].categoryWords!.count + categories[13].categoryWords!.count +
                               categories[14].categoryWords!.count
        
        totalNumberOfB1Words = categories[15].categoryWords!.count + categories[16].categoryWords!.count +
                               categories[17].categoryWords!.count + categories[18].categoryWords!.count +
                               categories[19].categoryWords!.count + categories[20].categoryWords!.count +
                               categories[21].categoryWords!.count + categories[22].categoryWords!.count +
                               categories[23].categoryWords!.count
        
        totalNumberOfB2Words = categories[24].categoryWords!.count + categories[25].categoryWords!.count +
                               categories[26].categoryWords!.count + categories[27].categoryWords!.count +
                               categories[28].categoryWords!.count + categories[29].categoryWords!.count
        
        totalNumberOfC1Words = categories[30].categoryWords!.count + categories[31].categoryWords!.count +
                               categories[32].categoryWords!.count + categories[33].categoryWords!.count +
                               categories[34].categoryWords!.count + categories[35].categoryWords!.count +
                               categories[36].categoryWords!.count + categories[37].categoryWords!.count
        
        totalNumberOfC2Words = categories[38].categoryWords!.count + categories[39].categoryWords!.count +
                               categories[40].categoryWords!.count + categories[41].categoryWords!.count

    }
    
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func viewTapped() {
        if isFlipped {
            UIView.transition(with: myView, duration: 0.35, options: .transitionFlipFromBottom, animations: {
                self.englishMeaningLabel.isHidden = false
                self.turkishMeaningLabel.isHidden = true
                self.audioButton.isHidden = false
            }, completion: nil)
        } else {
            UIView.transition(with: myView, duration: 0.35, options: .transitionFlipFromTop, animations: {
                self.englishMeaningLabel.isHidden = true
                self.turkishMeaningLabel.isHidden = false
                self.audioButton.isHidden = true
            }, completion: nil)
        }
        
        isFlipped.toggle()
    }
    
    
    
    // MARK: - Actions
    @IBAction func leftButtonTapped() {
        
        let originalX = self.myView.frame.origin.x
            
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.leftButton.isEnabled = false        // for fast tapping
            self.myView.frame.origin.x = -500
        } completion: { _ in
            let previousWord = self.selectedWord
            self.selectedWord = self.categoryWordsSet.randomElement()!             // randomly selected
            
            if self.categoryWordsSet.count > 1 {
                while previousWord == self.selectedWord {
                    self.selectedWord = self.categoryWordsSet.randomElement()!     // randomly selected
                }
            }
            
            self.myView.frame.origin.x = originalX
            self.englishMeaningLabel.text = self.selectedWord.wordEnglishMeaning!
            self.turkishMeaningLabel.text = self.selectedWord.wordTurkishMeaning!
            
            self.leftButton.isEnabled = true         // for fast tapping
                
            if self.isFlipped {
                // If the current card is Turkish meaning card, change to the English meaning card
                self.isFlipped = false
                self.englishMeaningLabel.isHidden = false
                self.turkishMeaningLabel.isHidden = true
                self.audioButton.isHidden = false
            }
        }
    }
    
    @IBAction func rightButtonTapped() {
    
        if categoryWordsSet.count == 1 {
            // If the all words of this category is finished
            addToUserLearnedWords()
            
            // UI Operations must be in mainQueue
            DispatchQueue.main.async {
                self.categoryWordsSet.removeAll()

                self.myView.isHidden = true
                self.rightButton.isHidden = true
                self.leftButton.isHidden = true
                self.rightLine.isHidden = true
                self.bottomLine.isHidden = true
                self.englishMeaningLabel.isHidden = true
                self.turkishMeaningLabel.isHidden = true
                self.audioButton.isHidden = true
                
                self.showCongratsAlert()
            }
            
        } else {
            addToUserLearnedWords()
            
            let originalX = self.myView.frame.origin.x
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
                self.rightButton.isEnabled = false        // for fast tapping
                self.myView.frame.origin.x = 500
            } completion: { _ in
                self.categoryWordsSet.remove(self.selectedWord)
                self.selectedWord = self.categoryWordsSet.randomElement()!
                
                self.myView.frame.origin.x = originalX
                self.englishMeaningLabel.text = self.selectedWord.wordEnglishMeaning!
                self.turkishMeaningLabel.text = self.selectedWord.wordTurkishMeaning!
                
                self.rightButton.isEnabled = true         // for fast tapping
                
                if self.isFlipped {
                    // If the current card is Turkish meaning card, change to the English meaning card
                    self.isFlipped = false
                    self.englishMeaningLabel.isHidden = false
                    self.turkishMeaningLabel.isHidden = true
                    self.audioButton.isHidden = false
                }
            }
        }
    }
        
    @IBAction func voiceButtonTapped() {
        if isAudioButtonTapped {
            return
        }
        
        isAudioButtonTapped = true
        
        let utterance = AVSpeechUtterance(string: englishMeaningLabel.text ?? "")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self] in
            self?.isAudioButtonTapped = false
        }
    }
    
    
    private func addToUserLearnedWords() {
        let categoryNumber = CategoryData.shared.selectedCategoryNumber
        
        user.userNumberOfWordsLearned! += 1
        if categoryWordsSet.count == 1 {
            // Learned the last word because the user clicked the right button, the category completed.
            user.userNumberOfCompletedCourseCategory! += 1
        }
        
        if categoryNumber < 8 {
            user.userA1LearnedWords?.append(selectedWord)
            updateFirestore(key: "userA1LearnedWords", user.userA1LearnedWords!)
        }
        else if categoryNumber < 15 {
            user.userA2LearnedWords?.append(selectedWord)
            updateFirestore(key: "userA2LearnedWords", user.userA2LearnedWords!)
        }
        else if categoryNumber < 24 {
            user.userB1LearnedWords?.append(selectedWord)
            updateFirestore(key: "userB1LearnedWords", user.userB1LearnedWords!)
        }
        else if categoryNumber < 30 {
            user.userB2LearnedWords?.append(selectedWord)
            updateFirestore(key: "userB2LearnedWords", user.userB2LearnedWords!)
        }
        else if categoryNumber < 38 {
            user.userC1LearnedWords?.append(selectedWord)
            updateFirestore(key: "userC1LearnedWords", user.userC1LearnedWords!)
        }
        else if categoryNumber < 42 {
            user.userC2LearnedWords?.append(selectedWord)
            updateFirestore(key: "userC2LearnedWords", user.userC2LearnedWords!)
        }
        
    }
    
    private func updateFirestore(key: String, _ learnedWords: [Word]) {
        let currentUserMail = user.userEmail!
        var wordsData = [[String: String]]()

        self.firestoreDatabase.collection("Users").whereField("userEmail", isEqualTo: currentUserMail).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            
            for document in snapshot.documents {
                let documentRef = self.firestoreDatabase.collection("Users").document(document.documentID)
                
                self.checkAchievements()
                
                for word in learnedWords {
                    let wordData: [String: String] = [
                        "wordEnglishMeaning": word.wordEnglishMeaning!,
                        "wordTurkishMeaning": word.wordTurkishMeaning!
                    ]
                    wordsData.append(wordData)
                }
                
                // update for learnedWords
                documentRef.updateData([key : wordsData]) { error in
                    guard error == nil else {
                        self.makeAlert(title: "Error", message: error!.localizedDescription)
                        return
                    }
                    
                    // update for numberOfWordsLearned
                    documentRef.updateData(["userNumberOfWordsLearned" : self.user.userNumberOfWordsLearned!]) { error in
                        guard error == nil else {
                            self.makeAlert(title: "Error", message: error!.localizedDescription)
                            return
                        }
                        
                        // update for achievementStatus
                        documentRef.updateData(["userAchievementStatus" : self.user.userAchievementStatus!]) { error in
                            guard error == nil else {
                                self.makeAlert(title: "Error", message: error!.localizedDescription)
                                return
                            }
                            
                            // update for numberOfCompletedCourseCategory
                            documentRef.updateData(["userNumberOfCompletedCourseCategory" : self.user.userNumberOfCompletedCourseCategory!]) { error in
                                guard error == nil else {
                                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                                    return
                                }
                                
                                self.writeUpdatesToFile(key: key, wordsData)    // update file
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    private func writeUpdatesToFile(key: String, _ learnedWords: [[String: String]]) {
        let fileName = "userDatas"
        let documentDirectoryUrl = try! FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")

        guard let jsonString = try? String(contentsOfFile: fileUrl.path, encoding: .utf8),
              var json = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? [String: Any] else {
            return
        }
    
        
        // Updates
        if let _ = json[key] as? [[String: String]] {
            json[key] = learnedWords
            json["userNumberOfWordsLearned"] = user.userNumberOfWordsLearned!
            json["userAchievementStatus"] = user.userAchievementStatus!
            json["userNumberOfCompletedCourseCategory"] = user.userNumberOfCompletedCourseCategory!
        }

        // Write to userDatas.txt file
        if let updatedJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
            try? updatedJsonString.write(to: fileUrl, atomically: true, encoding: .utf8)
        }
    }
    
    
    private func checkAchievements() {

        if user.userNumberOfWordsLearned! >= 10 {
            if user.userNumberOfWordsLearned! >= 100 {
                // Check 100 words achievement
                if user.userAchievementStatus![1] == false {
                    user.userAchievementStatus![1] = true
                }
            } else {
                // Check 10 words achievement
                if user.userAchievementStatus![0] == false {
                    user.userAchievementStatus![0] = true
                }
            }
        }
        
        // Check levels achievements
        if user.userAchievementStatus![3] == false && user.userA1LearnedWords!.count == totalNumberOfA1Words {
            user.userAchievementStatus![3] = true
        }
        if user.userAchievementStatus![4] == false && user.userA2LearnedWords!.count == totalNumberOfA2Words {
            user.userAchievementStatus![4] = true
        }
        if user.userAchievementStatus![5] == false && user.userB1LearnedWords!.count == totalNumberOfB1Words {
            user.userAchievementStatus![5] = true
        }
        if user.userAchievementStatus![6] == false && user.userB2LearnedWords!.count == totalNumberOfB2Words {
            user.userAchievementStatus![6] = true
        }
        if user.userAchievementStatus![7] == false && user.userC1LearnedWords!.count == totalNumberOfC1Words {
            user.userAchievementStatus![7] = true
        }
        if user.userAchievementStatus![8] == false && user.userC2LearnedWords!.count == totalNumberOfC2Words {
            user.userAchievementStatus![8] = true
        }
                
    }
    
    
    // MyAlertView Delegate Function
    func doneButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showCongratsAlert() {
        congratsAlertView.delegate = self
        congratsAlertView.configure(message: "You have finished the \(category.categoryName!) category")
        
        navigationItem.leftBarButtonItem?.isHidden = true
        self.view = congratsAlertView
    }
    
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}
