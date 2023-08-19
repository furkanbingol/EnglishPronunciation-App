//
//  WordTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 27.05.2023.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    @IBOutlet weak var wordEnglishLabel: UILabel!
    @IBOutlet weak var wordTurkishLabel: UILabel!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    
    
    static let identifier = "WordTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WordTableViewCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    
    // MARK: - Functions
    public func configureWordCell(with word: Word) {
        wordEnglishLabel.text = word.wordEnglishMeaning!
        wordTurkishLabel.text = word.wordTurkishMeaning!
    }
    
}
