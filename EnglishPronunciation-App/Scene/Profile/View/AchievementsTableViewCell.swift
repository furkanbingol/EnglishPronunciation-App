//
//  AchievementsTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 26.03.2023.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    @IBOutlet weak var firstTenWordsAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var firstOneHundredWordsAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var firstPronunciationAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var beginnerAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var elementaryAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var intermediateAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var upperIntermediateAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var advancedAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var proficiencyAchievement: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 15
            newValue.layer.masksToBounds = true
        }
    }
    
    // MARK: - Properties
    var imageViews = [UIImageView]()
    
    var grayImages = ["firstTenWords-gray", "firstOneHundredWords-gray", "firstPronunciation-gray",
                      "beginner-gray", "elementary-gray", "intermediate-gray",
                      "upperIntermediate-gray", "advanced-gray", "proficiency-gray"]
    
    var fullImages = ["firstTenWords", "firstOneHundredWords", "firstPronunciation",
                      "beginner", "elementary", "intermediate",
                      "upperIntermediate", "advanced", "proficiency"]
    
    
    
    static let identifier = "AchievementsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AchievementsTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageViews = [firstTenWordsAchievement, firstOneHundredWordsAchievement, firstPronunciationAchievement,
                      beginnerAchievement, elementaryAchievement, intermediateAchievement,
                      upperIntermediateAchievement, advancedAchievement, proficiencyAchievement]
    }
    
    
    // MARK: - Functions
    public func configure(user: User) {
        var k = 0
        
        while k < user.userAchievementStatus!.count {
            if user.userAchievementStatus![k] == false {
                imageViews[k].image = UIImage(named: grayImages[k])
            } else {
                imageViews[k].image = UIImage(named: fullImages[k])
            }
            k += 1
        }
        
    }
}
