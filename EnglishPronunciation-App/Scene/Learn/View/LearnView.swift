//
//  LearnView.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 23.03.2023.
//

import UIKit

protocol LearnViewDelegate: AnyObject {
    func categoryTapped(categoryNumber: Int)
}

class LearnView: UIView, UITableViewDelegate, UITableViewDataSource, SubjectTableViewCellDelegate {
    
    // MARK: - Delegate
    weak var delegate: LearnViewDelegate?
    
    
    // MARK: - UI Elements
    @IBOutlet var tableView: UITableView! {
        willSet {
            newValue.delegate = self
            newValue.dataSource = self
            newValue.register(SubjectTableViewCell.nib(), forCellReuseIdentifier: SubjectTableViewCell.identifier)
            newValue.register(LevelsTableViewCell.nib(), forCellReuseIdentifier: LevelsTableViewCell.identifier)
        }
    }
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        // xib dosyasındaki alt bileşenleri yükleme
        if let view = Bundle.main.loadNibNamed("LearnView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            view.backgroundColor = UIColor(hex: "#ffad33")
            addSubview(view)
        }
        
    }
    
    // MARK: - Delegate Function
    func categoryTapped(categoryNumber: Int) {
        delegate?.categoryTapped(categoryNumber: categoryNumber)
    }
    
    
    // MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6      // A1,A2,B1,B2,C1,C2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LevelsTableViewCell.identifier, for: indexPath) as? LevelsTableViewCell else {
                return UITableViewCell()
            }
            
            if indexPath.section == 0 { cell.configure(with: "Beginner") }
            else if indexPath.section == 1 { cell.configure(with: "Elementary") }
            else if indexPath.section == 2 { cell.configure(with: "Intermediate") }
            else if indexPath.section == 3 { cell.configure(with: "Upper Intermediate") }
            else if indexPath.section == 4 { cell.configure(with: "Advanced") }
            else if indexPath.section == 5 { cell.configure(with: "Proficiency") }
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTableViewCell.identifier, for: indexPath) as? SubjectTableViewCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self    // SubjectTableViewCell'deki kategoriye tıklandığında LearnView'in haberi olmalı.
            
            if indexPath.section == 0 { cell.configure(collectionNumber: 0, numberOfCategory: 8) }
            else if indexPath.section == 1 { cell.configure(collectionNumber: 1, numberOfCategory: 7) }
            else if indexPath.section == 2 { cell.configure(collectionNumber: 2, numberOfCategory: 9) }
            else if indexPath.section == 3 { cell.configure(collectionNumber: 3, numberOfCategory: 6) }
            else if indexPath.section == 4 { cell.configure(collectionNumber: 4, numberOfCategory: 8) }
            else if indexPath.section == 5 { cell.configure(collectionNumber: 5, numberOfCategory: 4) }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }

    
}
 
