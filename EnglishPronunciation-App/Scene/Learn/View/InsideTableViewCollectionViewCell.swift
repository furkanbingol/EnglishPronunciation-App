//
//  InsideTableViewCollectionViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 23.03.2023.
//

import UIKit

class InsideTableViewCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Elements
    @IBOutlet weak var subjectLabel: UILabel! {
        willSet {
            newValue.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            newValue.textAlignment = .center
            newValue.numberOfLines = 0
            newValue.sizeToFit()
            newValue.lineBreakMode = .byWordWrapping
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 20
            newValue.layer.masksToBounds = true
        }
    }
    
    static let identifier = "InsideTableViewCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "InsideTableViewCollectionViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    // MARK: - Functions
    public func configure(with category: Category) {
        subjectLabel.text = category.categoryName
        imageView.image = UIImage(named: category.categorySmallImage!)
    }
    
}
