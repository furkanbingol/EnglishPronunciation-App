//
//  SubjectTableViewCell.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 23.03.2023.
//

import UIKit

protocol SubjectTableViewCellDelegate: AnyObject {
    func categoryTapped(categoryNumber: Int)
}

class SubjectTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Delegate
    weak var delegate: SubjectTableViewCellDelegate?
    
    
    // MARK: - Properties
    var categories = [Category]()
    var collectionNumber: Int = 0
    var numberOfCategory: Int = 0
    
    
    // MARK: - UI Elements
    @IBOutlet weak var collectionView: UICollectionView! {
        willSet {
            newValue.delegate = self
            newValue.dataSource = self
            newValue.register(InsideTableViewCollectionViewCell.nib(), forCellWithReuseIdentifier: InsideTableViewCollectionViewCell.identifier)
        }
    }
    
    static let identifier = "SubjectTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SubjectTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categories = CategoryData.shared.categories
        
        // Creating layout for collectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: (frame.size.width) / 1.3, height: (frame.size.width) / 1.4)
        
        collectionView.collectionViewLayout = layout
    }
    
    
    // MARK: - CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InsideTableViewCollectionViewCell.identifier, for: indexPath) as? InsideTableViewCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        
        if collectionNumber == 0 {          // Beginner - 8
            if indexPath.row == 0 { cell.configure(with: categories[0]) }
            else if indexPath.row == 1 { cell.configure(with: categories[1]) }
            else if indexPath.row == 2 { cell.configure(with: categories[2]) }
            else if indexPath.row == 3 { cell.configure(with: categories[3]) }
            else if indexPath.row == 4 { cell.configure(with: categories[4]) }
            else if indexPath.row == 5 { cell.configure(with: categories[5]) }
            else if indexPath.row == 6 { cell.configure(with: categories[6]) }
            else if indexPath.row == 7 { cell.configure(with: categories[7]) }
        }
        else if collectionNumber == 1 {     // Elementary - 7
            if indexPath.row == 0 { cell.configure(with: categories[8]) }
            else if indexPath.row == 1 { cell.configure(with: categories[9]) }
            else if indexPath.row == 2 { cell.configure(with: categories[10]) }
            else if indexPath.row == 3 { cell.configure(with: categories[11]) }
            else if indexPath.row == 4 { cell.configure(with: categories[12]) }
            else if indexPath.row == 5 { cell.configure(with: categories[13]) }
            else if indexPath.row == 6 { cell.configure(with: categories[14]) }
        }
        else if collectionNumber == 2 {     // Intermediate - 9
            if indexPath.row == 0 { cell.configure(with: categories[15]) }
            else if indexPath.row == 1 { cell.configure(with: categories[16]) }
            else if indexPath.row == 2 { cell.configure(with: categories[17]) }
            else if indexPath.row == 3 { cell.configure(with: categories[18]) }
            else if indexPath.row == 4 { cell.configure(with: categories[19]) }
            else if indexPath.row == 5 { cell.configure(with: categories[20]) }
            else if indexPath.row == 6 { cell.configure(with: categories[21]) }
            else if indexPath.row == 7 { cell.configure(with: categories[22]) }
            else if indexPath.row == 8 { cell.configure(with: categories[23]) }
        }
        else if collectionNumber == 3 {     // Upper Intermediate - 6
            if indexPath.row == 0 { cell.configure(with: categories[24]) }
            else if indexPath.row == 1 { cell.configure(with: categories[25]) }
            else if indexPath.row == 2 { cell.configure(with: categories[26]) }
            else if indexPath.row == 3 { cell.configure(with: categories[27]) }
            else if indexPath.row == 4 { cell.configure(with: categories[28]) }
            else if indexPath.row == 5 { cell.configure(with: categories[29]) }
        }
        else if collectionNumber == 4 {     // Advanced - 8
            if indexPath.row == 0 { cell.configure(with: categories[30]) }
            else if indexPath.row == 1 { cell.configure(with: categories[31]) }
            else if indexPath.row == 2 { cell.configure(with: categories[32]) }
            else if indexPath.row == 3 { cell.configure(with: categories[33]) }
            else if indexPath.row == 4 { cell.configure(with: categories[34]) }
            else if indexPath.row == 5 { cell.configure(with: categories[35]) }
            else if indexPath.row == 6 { cell.configure(with: categories[36]) }
            else if indexPath.row == 7 { cell.configure(with: categories[37]) }
        }
        else if collectionNumber == 5 {     // Proficiency - 4
            if indexPath.row == 0 { cell.configure(with: categories[38]) }
            else if indexPath.row == 1 { cell.configure(with: categories[39]) }
            else if indexPath.row == 2 { cell.configure(with: categories[40]) }
            else if indexPath.row == 3 { cell.configure(with: categories[41]) }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        var categoryNumber = 0
        if (self.collectionNumber == 0) { categoryNumber = 0 }
        else if (self.collectionNumber == 1) { categoryNumber = 8 }
        else if (self.collectionNumber == 2) { categoryNumber = 15 }
        else if (self.collectionNumber == 3) { categoryNumber = 24 }
        else if (self.collectionNumber == 4) { categoryNumber = 30 }
        else if (self.collectionNumber == 5) { categoryNumber = 38 }
        
        categoryNumber += indexPath.row
        
        delegate?.categoryTapped(categoryNumber: categoryNumber)
    }
         
        
    // MARK: - Functions
    func configure(collectionNumber: Int, numberOfCategory: Int) {
        self.collectionNumber = collectionNumber
        self.numberOfCategory = numberOfCategory
        collectionView.reloadData()
    }
    
}
