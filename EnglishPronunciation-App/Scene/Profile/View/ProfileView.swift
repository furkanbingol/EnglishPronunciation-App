//
//  ProfileView.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 26.03.2023.
//

import UIKit

protocol ProfileViewDelegate: AnyObject {
    func chooseImage()
    func logoutButtonTapped()
}

class ProfileView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ProfileViewDelegate?
    
    
    // MARK: - UI Elements
    @IBOutlet weak var topView: UIView! {
        willSet {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor(hex: "#800af5").cgColor, UIColor(hex: "#bf85fa").cgColor]
            gradientLayer.locations = [0.0, 0.7]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.frame = newValue.bounds
            newValue.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        willSet {
            newValue.contentMode = .scaleAspectFill
            newValue.layer.cornerRadius = 40
            newValue.layer.masksToBounds = true
            newValue.isUserInteractionEnabled = true
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var registrationDateLabel: UILabel!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView! {
        willSet {
            newValue.delegate = self
            newValue.dataSource = self
            newValue.separatorStyle = .singleLine
            newValue.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            newValue.register(TitleTableViewCell.nib(), forCellReuseIdentifier: TitleTableViewCell.identifier)
            newValue.register(StatsTableViewCell.nib(), forCellReuseIdentifier: StatsTableViewCell.identifier)
            newValue.register(AchievementsTableViewCell.nib(), forCellReuseIdentifier: AchievementsTableViewCell.identifier)
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        // Adding GestureRecognizer
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        let pencilTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(imageTapGestureRecognizer)
        pencilButton.addGestureRecognizer(pencilTapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        if let view = Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
    
    @objc func chooseImage() {
        delegate?.chooseImage()
    }
            
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        delegate?.logoutButtonTapped()
    }
    
        
    
    // MARK: TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 3 {
            return 300
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
                return UITableViewCell()
            }
            
            if indexPath.row == 0 { cell.configure(title: "Stats") }
            else { cell.configure(title: "Achievements") }
            
            return cell
        }
        else {
            if indexPath.row == 1 {
                // Stats
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.identifier, for: indexPath) as? StatsTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configure(user: UserData.shared.user)

                return cell
            }
            else {
                // Achievements
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AchievementsTableViewCell.identifier, for: indexPath) as? AchievementsTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configure(user: UserData.shared.user)
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
