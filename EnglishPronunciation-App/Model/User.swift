//
//  User.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 2.04.2023.
//

import Foundation
import UIKit

class User : Codable {
    var userFullName: String?
    var userEmail: String?
    var userPassword: String?
    var userImage: String?
    var userRegistrationDate: String?
    
    var userNumberOfWordsLearned: Int?                // 0
    var userNumberOfCompletedCourseCategory: Int?     // 0
    var userAveragePronunciationScore: Int?           // 0
    var userPronunciationNumberOfTrying: Int?         // 0
    
    var userAchievementStatus: [Bool]?
    var userA1LearnedWords: [Word]?
    var userA2LearnedWords: [Word]?
    var userB1LearnedWords: [Word]?
    var userB2LearnedWords: [Word]?
    var userC1LearnedWords: [Word]?
    var userC2LearnedWords: [Word]?
    
    init(userFullName: String? = nil, userEmail: String? = nil, userPassword: String? = nil, userImage: String? = nil, userRegistrationDate: String? = nil, userNumberOfWordsLearned: Int? = 0, userNumberOfCompletedCourseCategory: Int? = 0, userAveragePronunciationScore: Int? = 0, userPronunciationNumberOfTrying: Int? = 0, userAchievementStatus: [Bool]? = [false, false, false, false, false, false, false, false ,false], userA1LearnedWords: [Word]? = nil, userA2LearnedWords: [Word]? = nil, userB1LearnedWords: [Word]? = nil, userB2LearnedWords: [Word]? = nil, userC1LearnedWords: [Word]? = nil, userC2LearnedWords: [Word]? = nil) {
        self.userFullName = userFullName
        self.userEmail = userEmail
        self.userPassword = userPassword
        self.userImage = userImage
        self.userRegistrationDate = userRegistrationDate
        self.userNumberOfWordsLearned = userNumberOfWordsLearned
        self.userNumberOfCompletedCourseCategory = userNumberOfCompletedCourseCategory
        self.userAveragePronunciationScore = userAveragePronunciationScore
        self.userPronunciationNumberOfTrying = userPronunciationNumberOfTrying
        self.userAchievementStatus = userAchievementStatus
        self.userA1LearnedWords = userA1LearnedWords
        self.userA2LearnedWords = userA2LearnedWords
        self.userB1LearnedWords = userB1LearnedWords
        self.userB2LearnedWords = userB2LearnedWords
        self.userC1LearnedWords = userC1LearnedWords
        self.userC2LearnedWords = userC2LearnedWords
    }
    
}
