//
//  DateToString.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 8.04.2023.
//

import Foundation

extension Date {
    func toString(format: String = "d MMMM, yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
}
