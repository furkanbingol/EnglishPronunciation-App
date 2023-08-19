//
//  TitleTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 26.03.2023.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
     
    // MARK: - UI Elements
    @IBOutlet weak var titleLabel: UILabel! {
        willSet {
            newValue.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            newValue.textAlignment = .left
        }
    }
    
    
    static let identifier = "TitleTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TitleTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGradientColor()
        backgroundColor = .systemGray2
    }

    
    // MARK: - Functions
    func configure(title: String) {
        titleLabel.text = title
    }
        
    func addGradientColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#e6e6ff").cgColor, UIColor(hex: "#f7f7f7").cgColor]
        gradientLayer.locations = [0.0, 0.7]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
