//
//  Word.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 2.04.2023.
//

import Foundation
import UIKit

class Word : Codable, Hashable {
    var wordEnglishMeaning: String?
    var wordTurkishMeaning: String?
    
    init(wordEnglishMeaning: String? = nil, wordTurkishMeaning: String? = nil) {
        self.wordEnglishMeaning = wordEnglishMeaning
        self.wordTurkishMeaning = wordTurkishMeaning
    }
    
    // Equatable protocol
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.wordEnglishMeaning! == rhs.wordEnglishMeaning!
    }
    
    // Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(wordEnglishMeaning!)
    }
}
