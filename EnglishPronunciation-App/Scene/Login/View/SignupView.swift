//
//  SignupView.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 22.03.2023.
//

import UIKit

protocol SignupViewDelegate: AnyObject {
    func signupButtonTapped()
}

class SignupView: UIView {
    
    // MARK: - Delegate
    weak var delegate: SignupViewDelegate?
    
    // MARK: - UI Elements
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!

    @IBOutlet weak var isEmailValidLabel: UILabel!
    @IBOutlet weak var isPasswordValidLabel: UILabel!
    @IBOutlet weak var isPasswordMatchLabel: UILabel!
    
    @IBOutlet weak var eyeIconOne: UIButton!
    @IBOutlet weak var eyeIconTwo: UIButton!
    
    
    // MARK: - Properties
    var eyeIconClickOne = true      // for passwordTextField
    var eyeIconClickTwo = true      // for confirmPasswordTextField
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        adjustUI()
    }
    
    
    // MARK: - Functions
    private func setup() {
        // xib dosyasındaki alt bileşenleri yükleme
        if let view = Bundle.main.loadNibNamed("SignupView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
    
    private func adjustUI() {
        isEmailValidLabel.isHidden = true
        isPasswordValidLabel.isHidden = true
        isPasswordMatchLabel.isHidden = true
        eyeIconOne.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeIconTwo.setImage(UIImage(systemName: "eye"), for: .normal)
    }
    
    
    // MARK: - Actions
    @IBAction func eyeClickedOne(sender: UIButton) {
        if eyeIconClickOne {
            passwordTextField.isSecureTextEntry = false
            eyeIconOne.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeIconOne.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        eyeIconClickOne = !eyeIconClickOne
    }
    
    @IBAction func eyeClickedTwo(sender: UIButton) {
        if eyeIconClickTwo {
            confirmPasswordTextField.isSecureTextEntry = false
            eyeIconTwo.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
            eyeIconTwo.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        eyeIconClickTwo = !eyeIconClickTwo
    }
    
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        delegate?.signupButtonTapped()
    }
    
    
    @IBAction func emailAddressChanged(_ sender: UITextField) {
        if let text = sender.text {
            if text.count == 0 {
                isEmailValidLabel.isHidden = true
            } else if text.count >= 6 && text.contains("@") {
                isEmailValidLabel.isHidden = true
            } else {
                isEmailValidLabel.isHidden = false
            }
        }
        
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        if let text = sender.text {
            if let confirmPasswordText = confirmPasswordTextField.text {
                if text == confirmPasswordText  {
                    isPasswordMatchLabel.isHidden = true
                } else {
                    isPasswordMatchLabel.isHidden = false
                }
            }
            if text.count == 0 {
                isPasswordValidLabel.isHidden = true
            } else if text.count >= 8 {       // Passwords must be at least 8 characters long
                isPasswordValidLabel.isHidden = true
            } else {
                isPasswordValidLabel.isHidden = false
            }
        }
    }
    
    @IBAction func confirmPasswordChanged(_ sender: UITextField) {
        if let text = sender.text {
            if text.count == 0 {
                isPasswordMatchLabel.isHidden = true
            } else {
                if let passwordText = passwordTextField.text {
                    if text == passwordText {
                        isPasswordMatchLabel.isHidden = true
                    } else {
                        isPasswordMatchLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
