//
//  Category.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 3.04.2023.
//

import Foundation
import UIKit

class Category : Codable {
    var categoryLevel: String?
    var categoryName: String?
    var categoryWords: [Word]?
    var categorySmallImage: String?
    var categoryLargeImage: String?
    
    init(categoryLevel: String? = nil, categoryName: String? = nil, categoryWords: [Word]? = nil, categorySmallImage: String? = nil, categoryLargeImage: String? = nil) {
        self.categoryLevel = categoryLevel
        self.categoryName = categoryName
        self.categoryWords = categoryWords
        self.categorySmallImage = categorySmallImage
        self.categoryLargeImage = categoryLargeImage
    }
}
