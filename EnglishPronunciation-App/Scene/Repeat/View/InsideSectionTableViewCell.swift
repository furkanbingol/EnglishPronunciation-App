//
//  InsideSectionTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 26.05.2023.
//

import UIKit

class InsideSectionTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView! {
        willSet {
            newValue.layer.cornerRadius = 10
            newValue.layer.masksToBounds = true
        }
    }
    
    
    static let identifier = "InsideSectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "InsideSectionTableViewCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    // MARK: - Functions
    public func configureSubCell(with category: Category) {
        categoryLabel.text = category.categoryName!
        categoryImageView.image = UIImage(named: category.categorySmallImage!)
    }
    
    
}
