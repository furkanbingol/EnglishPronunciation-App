//
//  MyAlertView.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 17.05.2023.
//

import UIKit

protocol MyAlertViewDelegate: AnyObject {
    func doneButtonTapped()
}

class MyAlertView: UIView {
    
    // MARK: - Delegate
    weak var delegate: MyAlertViewDelegate?
    
    
    // MARK: - UI Elements
    @IBOutlet weak var alertView: UIView! {
        willSet {
            newValue.layer.cornerRadius = 40
            newValue.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    func setup() {
        if let view = Bundle.main.loadNibNamed("MyAlertView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            view.backgroundColor = .white
            addSubview(view)
        }
    }
    
    public func configure(message: String) {
        messageLabel.text = message
    }
    
    // MARK: - Actions
    @IBAction func doneButtonTapped() {
        delegate?.doneButtonTapped()
    }

}
