//
//  LoginView.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 22.03.2023.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginButtonTapped()
}

class LoginView: UIView {
    
    // MARK: - Delegate
    weak var delegate: LoginViewDelegate?
    
    
    // MARK: - UI Elements
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var eyeIcon: UIButton!
        

    // MARK: - Properties
    private var eyeIconClick = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        adjustUI()
    }
    
    
    // MARK: - Functions
    func setup() {
        // xib dosyasındaki alt bileşenleri yükleme
        if let view = Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
    
    private func adjustUI() {
        eyeIcon.setImage(UIImage(systemName: "eye"), for: .normal)
    }
    
    
    
    // MARK: - Actions
    @IBAction func eyeClicked(sender: UIButton) {
        if eyeIconClick {
            passwordTextField.isSecureTextEntry = false
            eyeIcon.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeIcon.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        eyeIconClick = !eyeIconClick
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        delegate?.loginButtonTapped()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
