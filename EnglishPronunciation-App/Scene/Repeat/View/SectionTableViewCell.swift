//
//  SectionTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 26.05.2023.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellView: GradientView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    
    static let identifier = "SectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SectionTableViewCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    
    // MARK: - Functions
    public func configureTitleCell(with title: String, topColor: UIColor, bottomColor: UIColor) {
        titleLabel.text = title
        cellView.topColor = topColor
        cellView.bottomColor = bottomColor
    }
    
}
