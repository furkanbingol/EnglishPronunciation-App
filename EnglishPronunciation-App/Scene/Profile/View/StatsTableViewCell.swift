//
//  StatsTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 26.03.2023.
//

import UIKit
import MBCircularProgressBar

class StatsTableViewCell: UITableViewCell {
        
    // MARK: - UI Elements
    @IBOutlet weak var numberOfWordsLearnedLabel: UILabel!
    @IBOutlet weak var numberOfCompletedCategoryLabel: UILabel!
    @IBOutlet weak var averagePronunciationScoreLabel: UILabel!
    @IBOutlet weak var circularProgressView: MBCircularProgressBarView! {
        willSet {
            newValue.maxValue = 100
            newValue.progressColor = .systemRed
            newValue.progressStrokeColor = .systemRed
            newValue.fontColor = .systemRed
            newValue.unitFontSize = 0
            newValue.valueFontSize = 13
            newValue.valueDecimalFontSize = 13
            newValue.progressAngle = 100
            newValue.progressLineWidth = 1
            newValue.emptyLineWidth = 0.5
            newValue.emptyLineColor = .systemGray2
            newValue.emptyLineStrokeColor = .systemGray2
            newValue.progressRotationAngle = 50
        }
    }
    
    @IBOutlet weak var a1StatsLabel: UILabel!
    @IBOutlet weak var a2StatsLabel: UILabel!
    @IBOutlet weak var b1StatsLabel: UILabel!
    @IBOutlet weak var b2StatsLabel: UILabel!
    @IBOutlet weak var c1StatsLabel: UILabel!
    @IBOutlet weak var c2StatsLabel: UILabel!
    
    @IBOutlet weak var a1ProgressView: UIProgressView! {
        willSet {
            newValue.progress = 0.0
        }
    }
    @IBOutlet weak var a2ProgressView: UIProgressView! {
        willSet {
            newValue.progress = 0.0
        }
    }
    @IBOutlet weak var b1ProgressView: UIProgressView! {
        willSet {
            newValue.progress = 0.0
        }
    }
    @IBOutlet weak var b2ProgressView: UIProgressView! {
        willSet {
            newValue.progress = 0.0
        }
    }
    @IBOutlet weak var c1ProgressView: UIProgressView! {
        willSet {
            newValue.progress = 0.0
        }
    }
    @IBOutlet weak var c2ProgressView: UIProgressView! {
        willSet {
            newValue.progress = 0.0
        }
    }
    
    
    
    // MARK: - Properties
    var categories = [Category]()
    var totalNumberOfA1Words = 0
    var totalNumberOfA2Words = 0
    var totalNumberOfB1Words = 0
    var totalNumberOfB2Words = 0
    var totalNumberOfC1Words = 0
    var totalNumberOfC2Words = 0
    
    
    static let identifier = "StatsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "StatsTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        categories = CategoryData.shared.categories
        
        totalNumberOfA1Words = categories[0].categoryWords!.count + categories[1].categoryWords!.count +
                               categories[2].categoryWords!.count + categories[3].categoryWords!.count +
                               categories[4].categoryWords!.count + categories[5].categoryWords!.count +
                               categories[6].categoryWords!.count + categories[7].categoryWords!.count
        
        totalNumberOfA2Words = categories[8].categoryWords!.count + categories[9].categoryWords!.count +
                               categories[10].categoryWords!.count + categories[11].categoryWords!.count +
                               categories[12].categoryWords!.count + categories[13].categoryWords!.count +
                               categories[14].categoryWords!.count
        
        totalNumberOfB1Words = categories[15].categoryWords!.count + categories[16].categoryWords!.count +
                               categories[17].categoryWords!.count + categories[18].categoryWords!.count +
                               categories[19].categoryWords!.count + categories[20].categoryWords!.count +
                               categories[21].categoryWords!.count + categories[22].categoryWords!.count +
                               categories[23].categoryWords!.count
        
        totalNumberOfB2Words = categories[24].categoryWords!.count + categories[25].categoryWords!.count +
                               categories[26].categoryWords!.count + categories[27].categoryWords!.count +
                               categories[28].categoryWords!.count + categories[29].categoryWords!.count
        
        totalNumberOfC1Words = categories[30].categoryWords!.count + categories[31].categoryWords!.count +
                               categories[32].categoryWords!.count + categories[33].categoryWords!.count +
                               categories[34].categoryWords!.count + categories[35].categoryWords!.count +
                               categories[36].categoryWords!.count + categories[37].categoryWords!.count
        
        totalNumberOfC2Words = categories[38].categoryWords!.count + categories[39].categoryWords!.count +
                               categories[40].categoryWords!.count + categories[41].categoryWords!.count
        
    }
    
    // MARK: - Functions
    public func configure(user: User) {
        numberOfWordsLearnedLabel.text = "Total number of words learned: \(user.userNumberOfWordsLearned!)"
        numberOfCompletedCategoryLabel.text = "Total number of completed category: \(user.userNumberOfCompletedCourseCategory!)"
        averagePronunciationScoreLabel.text = "Average pronunciation score: "
        
        a1StatsLabel.text = "\(user.userA1LearnedWords!.count)/\(totalNumberOfA1Words)"
        a2StatsLabel.text = "\(user.userA2LearnedWords!.count)/\(totalNumberOfA2Words)"
        b1StatsLabel.text = "\(user.userB1LearnedWords!.count)/\(totalNumberOfB1Words)"
        b2StatsLabel.text = "\(user.userB2LearnedWords!.count)/\(totalNumberOfB2Words)"
        c1StatsLabel.text = "\(user.userC1LearnedWords!.count)/\(totalNumberOfC1Words)"
        c2StatsLabel.text = "\(user.userC2LearnedWords!.count)/\(totalNumberOfC2Words)"
        
        a1ProgressView.setProgress(Float(user.userA1LearnedWords!.count) / Float(totalNumberOfA1Words), animated: true)
        a2ProgressView.setProgress(Float(user.userA2LearnedWords!.count) / Float(totalNumberOfA2Words), animated: true)
        b1ProgressView.setProgress(Float(user.userB1LearnedWords!.count) / Float(totalNumberOfB1Words), animated: true)
        b2ProgressView.setProgress(Float(user.userB2LearnedWords!.count) / Float(totalNumberOfB2Words), animated: true)
        c1ProgressView.setProgress(Float(user.userC1LearnedWords!.count) / Float(totalNumberOfC1Words), animated: true)
        c2ProgressView.setProgress(Float(user.userC2LearnedWords!.count) / Float(totalNumberOfC2Words), animated: true)
        
        
        // Circular Progress View configure
        self.circularProgressView.value = 0
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.75) {
                let val = CGFloat(user.userAveragePronunciationScore!)
                var color = UIColor()
                self.circularProgressView.value = val

                if val >= 0 && val < 20 { color = UIColor(hex: "#ff0000") }
                else if val >= 20 && val < 40 { color = UIColor(hex: "#ff9900") }
                else if val >= 40 && val < 60 { color = UIColor(hex: "#ffcc80") }
                else if val >= 60 && val < 80 { color = UIColor(hex: "#5cd65c") }
                else if val >= 80 && val <= 100 { color = UIColor(hex: "#2eb82e") }
                
                self.circularProgressView.progressColor = color
                self.circularProgressView.progressStrokeColor = color
                self.circularProgressView.fontColor = UIColor.black
            }
        }
        
    }
}
