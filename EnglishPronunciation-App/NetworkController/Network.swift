//
//  Network.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 9.04.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore


// Singleton Class
class Network {
    static let shared = Network()
    let firestoreDatabase = Firestore.firestore()
    
    private init() {}
    
    
    // ## Fetching User Data ##
    func getUserData(emailText: String, vc: UIViewController, completion: @escaping (User) -> Void) {
        
        let user = User()
        
        self.firestoreDatabase.collection("Users").whereField("userEmail", isEqualTo: emailText).getDocuments { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                self?.makeAlert(title: "Error", message: error!.localizedDescription, presentingViewController: vc)
                return
            }
            
            guard let data = snapshot.documents.first?.data(),
                  let fullName = data["userFullName"] as? String,
                  let email = data["userEmail"] as? String,
                  let imageUrl = data["userImage"] as? String,
                  let registrationDate = data["userRegistrationDate"] as? String,
                  let numberOfWordsLearned = data["userNumberOfWordsLearned"] as? Int,
                  let numberOfCompletedCourseCategory = data["userNumberOfCompletedCourseCategory"] as? Int,
                  let averagePronunciationScore = data["userAveragePronunciationScore"] as? Int,
                  let pronunciationNumberOfTrying = data["userPronunciationNumberOfTrying"] as? Int,
                  let achievementStatus = data["userAchievementStatus"] as? [Bool],
                  let a1LearnedWords = data["userA1LearnedWords"] as? [[String : Any]],
                  let a2LearnedWords = data["userA2LearnedWords"] as? [[String : Any]],
                  let b1LearnedWords = data["userB1LearnedWords"] as? [[String : Any]],
                  let b2LearnedWords = data["userB2LearnedWords"] as? [[String : Any]],
                  let c1LearnedWords = data["userC1LearnedWords"] as? [[String : Any]],
                  let c2LearnedWords = data["userC2LearnedWords"] as? [[String : Any]]
            else {
                self?.makeAlert(title: "Error", message: "Error retrieving user data!", presentingViewController: vc)
                return
            }
            
            user.userFullName = fullName
            user.userEmail = email
            user.userImage = imageUrl
            user.userRegistrationDate = registrationDate
            user.userNumberOfWordsLearned = numberOfWordsLearned
            user.userNumberOfCompletedCourseCategory = numberOfCompletedCourseCategory
            user.userAveragePronunciationScore = averagePronunciationScore
            user.userPronunciationNumberOfTrying = pronunciationNumberOfTrying
            user.userAchievementStatus = achievementStatus
            user.userA1LearnedWords = []
            user.userA2LearnedWords = []
            user.userB1LearnedWords = []
            user.userB2LearnedWords = []
            user.userC1LearnedWords = []
            user.userC2LearnedWords = []
            
            
            // Kullanıcının öğrendiği kelimeleri-databaseden- modele aktarma
            for wordDict in a1LearnedWords {
                let word = Word()
                word.wordEnglishMeaning = wordDict["wordEnglishMeaning"] as? String
                word.wordTurkishMeaning = wordDict["wordTurkishMeaning"] as? String
                user.userA1LearnedWords?.append(word)
            }
            for wordDict in a2LearnedWords {
                let word = Word()
                word.wordEnglishMeaning = wordDict["wordEnglishMeaning"] as? String
                word.wordTurkishMeaning = wordDict["wordTurkishMeaning"] as? String
                user.userA2LearnedWords?.append(word)
            }
            for wordDict in b1LearnedWords {
                let word = Word()
                word.wordEnglishMeaning = wordDict["wordEnglishMeaning"] as? String
                word.wordTurkishMeaning = wordDict["wordTurkishMeaning"] as? String
                user.userB1LearnedWords?.append(word)
            }
            for wordDict in b2LearnedWords {
                let word = Word()
                word.wordEnglishMeaning = wordDict["wordEnglishMeaning"] as? String
                word.wordTurkishMeaning = wordDict["wordTurkishMeaning"] as? String
                user.userB2LearnedWords?.append(word)
            }
            for wordDict in c1LearnedWords {
                let word = Word()
                word.wordEnglishMeaning = wordDict["wordEnglishMeaning"] as? String
                word.wordTurkishMeaning = wordDict["wordTurkishMeaning"] as? String
                user.userC1LearnedWords?.append(word)
            }
            for wordDict in c2LearnedWords {
                let word = Word()
                word.wordEnglishMeaning = wordDict["wordEnglishMeaning"] as? String
                word.wordTurkishMeaning = wordDict["wordTurkishMeaning"] as? String
                user.userC2LearnedWords?.append(word)
            }
            
            completion(user)
        }
    
    }
    
    
    // ## Fetching Categories Data ##
    func getCategoryData(docNames: [String], smallImageNames: [String], largeImageNames: [String], vc: UIViewController, completion: @escaping ([Category]) -> Void) {

        var categories = [Category]()
        var currentIndex = 0

        func fetchNextCategory() {
            if currentIndex < docNames.count {
                let newCategory = Category()
                let docRef = self.firestoreDatabase.collection("Category").document(docNames[currentIndex])
                
                docRef.getDocument { [weak self] snapshot, error in
                    if let error = error {
                        self?.makeAlert(title: "Error", message: error.localizedDescription, presentingViewController: vc)
                        return
                    }
                    
                    guard let data = snapshot?.data(),
                          let categoryLevel = data["categoryLevel"] as? String,
                          let categoryName = data["categoryName"] as? String,
                          let categoryWords = data["categoryWords"] as? [[String : Any]]
                    else {
                        self?.makeAlert(title: "Error", message: "Error retrieving categories data!", presentingViewController: vc)
                        return
                    }
                    
                    newCategory.categoryLevel = categoryLevel
                    newCategory.categoryName = categoryName
                    newCategory.categoryWords = []
                    newCategory.categorySmallImage = smallImageNames[currentIndex]
                    newCategory.categoryLargeImage = largeImageNames[currentIndex]
                    
                    for wordDict in categoryWords {
                        let word = Word()
                        word.wordEnglishMeaning = wordDict["wordEnglishMeaning"] as? String
                        word.wordTurkishMeaning = wordDict["wordTurkishMeaning"] as? String
                        newCategory.categoryWords?.append(word)
                    }
                    
                    categories.append(newCategory)
                    currentIndex += 1
                    fetchNextCategory()
                }
            }
            else {
                completion(categories)
            }
        }
        
        fetchNextCategory()
    }

    
    // Spesifik bir VC üzerinde alert gösterme
    private func makeAlert(title: String, message: String, presentingViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        presentingViewController.present(alert, animated: true)
    }
    
}

// "@escaping" Hakkında:
// Network işlemleri Main Queue'de çalışmaz. Asenkron çalışır.
// @escaping ile fonksiyon içindeki execute bitmeden, closure'un execute edilmemesini söylüyoruz.
// Yani aslında @escaping, closure'u store ediyor. Fonksiyon execute olduktan sonra, completion closure'nu execute ettiriyor.

// "defer" Hakkında:
// defer bloğu, fonksiyonun herhangi bir yerinde çalıştırılması gereken bir kod bloğunu "sona erteleyen" bir yapıcıdır.
// defer bloğu, çalıştırılması gereken kodunun işlevin normal yürütmesine karışmadan "en son çalıştırılmasını sağlar".
