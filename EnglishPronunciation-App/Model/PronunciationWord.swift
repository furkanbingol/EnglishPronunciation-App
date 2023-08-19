//
//  PronunciationWord.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 30.05.2023.
//

import Foundation
import UIKit

class PronunciationWord {
    var word: String
    var errorType: String
    var accuracyScore = 0.0
    
    init(word: String, errorType: String, accuracyScore: Double = 0.0) {
        self.word = word
        self.errorType = errorType
        self.accuracyScore = accuracyScore
    }
}
