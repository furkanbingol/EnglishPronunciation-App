//
//  UserData.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 8.04.2023.
//

import Foundation
import UIKit


// Singleton Class
class UserData {
    static let shared = UserData()
    var user = User()
    var allLearnedWords = [Word]()
    
    private init() {}
}
