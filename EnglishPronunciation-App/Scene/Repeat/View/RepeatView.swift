//
//  RepeatView.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 25.05.2023.
//

import UIKit
import Firebase


// Model
class Section {
    let title: String
    let options: [Category]
    var isOpened = false
    
    init(title: String, options: [Category], isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}


protocol RepeatViewDelegate: AnyObject {
    func categoryTapped(categoryNumber: Int)
}


class RepeatView: UIView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Delegate
    weak var delegate: RepeatViewDelegate?
    
    // MARK: - UI Elements
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var tableView: UITableView! {
        willSet {
            newValue.delegate = self
            newValue.dataSource = self
            newValue.sectionHeaderHeight = 25.0
            newValue.sectionFooterHeight = 0.0
            newValue.register(SectionTableViewCell.nib(), forCellReuseIdentifier: SectionTableViewCell.identifier)
            newValue.register(InsideSectionTableViewCell.nib(), forCellReuseIdentifier: InsideSectionTableViewCell.identifier)
        }
    }
    
    // MARK: - Properties
    var user = User()
    var categories = [Category]()
    var sections = [Section]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        user = UserData.shared.user
        categories = CategoryData.shared.categories
                
        adjustSections()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Functions
    private func setup() {
        if let view = Bundle.main.loadNibNamed("RepeatView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
    
    
    private func adjustSections() {
        
        sections = [
            Section(title: "Beginner", options: [categories[0], categories[1], categories[2], categories[3],
                                                categories[4], categories[5], categories[6], categories[7]]),
            
            Section(title: "Elementary", options: [categories[8], categories[9], categories[10], categories[11],
                                                   categories[12], categories[13], categories[14]]),
            
            Section(title: "Intermediate", options: [categories[15], categories[16], categories[17], categories[18],
                                                     categories[19], categories[20], categories[21], categories[22],
                                                     categories[23]]),
            
            Section(title: "Upper Intermediate", options: [categories[24], categories[25], categories[26], categories[27],
                                                           categories[28], categories[29]]),
            
            Section(title: "Advanced", options: [categories[30], categories[31], categories[32], categories[33],
                                                 categories[34], categories[35], categories[36], categories[37]]),
            
            Section(title: "Proficiency", options: [categories[38], categories[39], categories[40], categories[41]])
        ]
        
    }
    
    
    // MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count      // A1, A2, B1, B2, C1, C2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        
        if currentSection.isOpened {
            return currentSection.options.count + 1    // +1 --> Title Cell
        } else {
            return 1    // 1 --> Title Cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.identifier, for: indexPath) as? SectionTableViewCell else {
                return UITableViewCell()
            }
            
            if sections[indexPath.section].isOpened == true {
                cell.arrowImageView.image = UIImage(systemName: "chevron.up")
            } else {
                cell.arrowImageView.image = UIImage(systemName: "chevron.down")
            }
            
            cell.configureTitleCell(with: sections[indexPath.section].title,
                                    topColor: UIColor(hex: "E4FFE9"),
                                    bottomColor: UIColor(hex: "EBEBEC"))
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InsideSectionTableViewCell.identifier, for: indexPath) as? InsideSectionTableViewCell else {
                return UITableViewCell()
            }
            
            cell.backgroundColor = .white
            cell.configureSubCell(with: sections[indexPath.section].options[indexPath.row - 1])
            // -1: because of title cell!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentSection = indexPath.section
        
        if indexPath.row > 0 {
            var categoryNumber = indexPath.row - 1
            
            switch currentSection {
            case 0:
                categoryNumber += 0
            case 1:
                categoryNumber += 8
            case 2:
                categoryNumber += 15
            case 3:
                categoryNumber += 24
            case 4:
                categoryNumber += 30
            case 5:
                categoryNumber += 38
            default:
                print("error")
            }
            
            delegate?.categoryTapped(categoryNumber: categoryNumber)
        }
        else {
            // -- Expandable TableView --
            var i = 0
            if indexPath.row == 0 {
                while i < sections.count {
                    if i != currentSection && sections[i].isOpened == true {
                        sections[i].isOpened = false
                        tableView.reloadSections([i], with: .none)
                    }
                    i += 1
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.sections[currentSection].isOpened = !self.sections[currentSection].isOpened
                tableView.reloadSections([currentSection], with: .none)
                
                // using .scrollToRow() for scrolling tableView
                if self.sections[currentSection].isOpened == true {
                    let destinationIndexPath = IndexPath(row: 0, section: currentSection)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        tableView.scrollToRow(at: destinationIndexPath, at: .top, animated: true)
                    }
                }
            }
        }
        
    }
    
}
