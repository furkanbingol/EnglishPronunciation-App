//
//  Score.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 30.05.2023.
//

import Foundation
import UIKit

// Singleton Class
class Score {
    static let shared = Score()
    var words = [PronunciationWord]()
    var pronunciationScore = 0
    
    private init() {}
}
