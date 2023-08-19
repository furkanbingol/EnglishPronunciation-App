//
//  LevelsTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 24.03.2023.
//

import UIKit

class LevelsTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    @IBOutlet weak var levelLabel: UILabel! {
        willSet {
            newValue.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
    }
    
    static let identifier = "LevelsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "LevelsTableViewCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    // MARK: - Functions
    public func configure(with levelText: String) {
        levelLabel.text = levelText
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [UIColor(hex: "#ffe5cc").cgColor, UIColor(hex: "#fff2e6").cgColor]
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
