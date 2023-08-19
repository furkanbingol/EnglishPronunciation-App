//
//  ScoreTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 30.05.2023.
//

import UIKit
import MBCircularProgressBar

class ScoreTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    @IBOutlet weak var wordText: UILabel!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var circularScoreView: MBCircularProgressBarView! {
        willSet {
            newValue.maxValue = 100
            newValue.fontColor = .black
            newValue.unitFontSize = 0
            newValue.valueFontSize = 14
            newValue.valueDecimalFontSize = 0
            newValue.progressAngle = 100
            newValue.progressLineWidth = 2
            newValue.emptyLineWidth = 0.5
            newValue.emptyLineColor = .systemGray2
            newValue.emptyLineStrokeColor = .systemGray2
            newValue.progressRotationAngle = 50
        }
    }
    
    
    static let identifier = "ScoreTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ScoreTableViewCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    
    // MARK: - Functions
    public func configureScoreCell(wordString: String, errorType: String, accuracyScore: Int) {
        wordText.text = wordString
        errorText.text = errorType
        circularScoreView.value = CGFloat(accuracyScore)
        
        if accuracyScore >= 0 && accuracyScore < 20 {
            circularScoreView.progressColor = UIColor(hex: "#ff0000")
            circularScoreView.progressStrokeColor = UIColor(hex: "#ff0000")
        }
        else if accuracyScore >= 20 && accuracyScore < 40 {
            circularScoreView.progressColor = UIColor(hex: "#ff9900")
            circularScoreView.progressStrokeColor = UIColor(hex: "#ff9900")
        }
        else if accuracyScore >= 40 && accuracyScore < 60 {
            circularScoreView.progressColor = UIColor(hex: "#ffcc80")
            circularScoreView.progressStrokeColor = UIColor(hex: "#ffcc80")
        }
        else if accuracyScore >= 60 && accuracyScore < 80 {
            circularScoreView.progressColor = UIColor(hex: "#5cd65c")
            circularScoreView.progressStrokeColor = UIColor(hex: "#5cd65c")
        }
        else if accuracyScore >= 80 && accuracyScore <= 100 {
            circularScoreView.progressColor = UIColor(hex: "#2eb82e")
            circularScoreView.progressStrokeColor = UIColor(hex: "#2eb82e")
        }
    }
    
}
