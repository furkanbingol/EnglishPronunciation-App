//
//  LoginViewController.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 22.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController, LoginViewDelegate, SignupViewDelegate {
    
    let firestoreDatabase = Firestore.firestore()
    let network = Network.shared

    
    // MARK: - UI Elements
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        willSet {
            newValue.isHidden = true
            newValue.hidesWhenStopped = true
            newValue.style = .large
        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        willSet {
            newValue.layer.cornerRadius = 20
            newValue.layer.masksToBounds = true
        }
    }
    
    private var signupView: SignupView! {
        willSet {
            newValue.delegate = self
        }
    }
    private var loginView: LoginView! {
        willSet {
            newValue.delegate = self
        }
    }
    
    
    // MARK: - Properties
    var user = User()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loginView = LoginView(frame: containerView.bounds)
        signupView = SignupView(frame: containerView.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustUI()
        
        // Keyboard Dismiss
        view.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: - Functions
    func adjustUI() {
        // loginView'ı containerView'a ekleme
        containerView.frame.size.height = 278
        containerView.addSubview(loginView)
        containerView.bringSubviewToFront(segmentedControl)
        
        // Label'ların animasyonu
        let scaleTransform = CGAffineTransform(scaleX: 1.9, y: 1.9)
        UIView.animate(withDuration: 2) {
            self.welcomeLabel.transform = scaleTransform
            self.descriptionLabel.transform = scaleTransform
        }
    }
    
    @objc func keyboardDismiss(){
        view.endEditing(true)
    }
    
    
    // MARK: - Delegate Functions
    func loginButtonTapped() {
        guard let emailText = loginView.emailTextField.text, !emailText.isEmpty,
              let passwordText = loginView.passwordTextField.text, !passwordText.isEmpty else {
            
            makeAlert(title: "Error", message: "Email or Password field is empty.")
            return
        }
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { result, error in
            guard error == nil else {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.view.alpha = 0.85
                self.segmentedControl.isUserInteractionEnabled = false
                self.loginView.emailTextField.isUserInteractionEnabled = false
                self.loginView.passwordTextField.isUserInteractionEnabled = false
                self.loginView.eyeIcon.isUserInteractionEnabled = false
                self.loginView.loginButton.isUserInteractionEnabled = false
                
                self.activityIndicator.isHidden = false
                var point = self.view.center
                point.y += 12
                self.activityIndicator.center = point
                self.activityIndicator.startAnimating()
            }
            
            // Fetching user datas
            self.network.getUserData(emailText: emailText, vc: self) { user in
                
                UserData.shared.user = user

                let docNames = CategoryData.shared.docNames
                let smallImageNames = CategoryData.shared.smallImageNames
                let largeImageNames = CategoryData.shared.largeImageNames
                
                // Fetching category datas -42 categories-
                self.network.getCategoryData(docNames: docNames, smallImageNames: smallImageNames, largeImageNames: largeImageNames, vc: self) { categories in
                    
                    CategoryData.shared.categories = categories     // Singleton Principle
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        LoginViewController.createUserDataFile()        // add datas to userDatas.txt file
                        LoginViewController.createCategoryDataFile()    // add datas to categoryDatas.txt file
                    }
                    
                    let tabBarVC = MyTabBarController()
                    self.present(tabBarVC, animated: true)
                }
                
            }
        }
            
    }
    
    
    func signupButtonTapped() {
        guard let userFullName = signupView.fullNameTextField.text, !userFullName.isEmpty else {
            makeAlert(title: "Error", message: "The full name is empty.")
            return
        }
        
        guard let emailText = signupView.emailTextField.text,
              !emailText.isEmpty,
              signupView.isEmailValidLabel.isHidden == true else {
            
            makeAlert(title: "Error", message: "The email address is empty or badly formatted.")
            return
        }
        
        guard let passwordText = signupView.passwordTextField.text, passwordText.count >= 8 else {
            makeAlert(title: "Error", message: "The password must be at least 8 characters long.")
            return
        }
        
        guard let confirmPasswordText = signupView.confirmPasswordTextField.text,
              !confirmPasswordText.isEmpty,
              signupView.isPasswordMatchLabel.isHidden == true else {
            
            makeAlert(title: "Error", message: "Password does not match.")
            return
        }
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { result, error in
            guard error == nil else {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            
            // New User Operations
            self.user.userFullName = userFullName
            self.user.userEmail = emailText
            self.user.userPassword = passwordText
            self.user.userImage = "default"
            self.user.userRegistrationDate = Date().toString()
            self.user.userA1LearnedWords = []
            self.user.userA2LearnedWords = []
            self.user.userB1LearnedWords = []
            self.user.userB2LearnedWords = []
            self.user.userC1LearnedWords = []
            self.user.userC2LearnedWords = []
            
            
            // Adding data to Firestore
            let post = ["userFullName": self.user.userFullName!,
                        "userEmail": self.user.userEmail!,
                        "userImage": self.user.userImage!,
                        "userRegistrationDate": self.user.userRegistrationDate!,
                        "userNumberOfWordsLearned": self.user.userNumberOfWordsLearned!,
                        "userNumberOfCompletedCourseCategory": self.user.userNumberOfCompletedCourseCategory!,
                        "userAveragePronunciationScore": self.user.userAveragePronunciationScore!,
                        "userPronunciationNumberOfTrying": self.user.userPronunciationNumberOfTrying!,
                        "userAchievementStatus": self.user.userAchievementStatus!,
                        "userA1LearnedWords": self.user.userA1LearnedWords!,
                        "userA2LearnedWords": self.user.userA2LearnedWords!,
                        "userB1LearnedWords": self.user.userB1LearnedWords!,
                        "userB2LearnedWords": self.user.userB2LearnedWords!,
                        "userC1LearnedWords": self.user.userC1LearnedWords!,
                        "userC2LearnedWords": self.user.userC2LearnedWords!] as [String : Any]
           
            
            // _ : firestore reference diyebiliriz
            var _ = self.firestoreDatabase.collection("Users").addDocument(data: post) { error in
                guard error == nil else {
                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                    return
                }
                
                // Üstteki işlem bittikten sonra aşağıdaki signOut() çalışacak. Bu sayede uygulamaya signUp olduktan sonra uygulama kapatılsa dahi, tekrar girişte login isteyecek.
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("error")
                }
                
            }
            
            // UI Operations
            DispatchQueue.main.async {
                self.makeAlert(title: "Sign up successful", message: "Please login.")
                self.signupView.fullNameTextField.text = ""
                self.signupView.emailTextField.text = ""
                self.signupView.passwordTextField.text = ""
                self.signupView.confirmPasswordTextField.text = ""
            }
        }
    }
        
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Actions
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // Login View
            signupView.removeFromSuperview()
            containerView.addSubview(loginView)
            containerView.bringSubviewToFront(segmentedControl)
            UIView.animate(withDuration: 0.7) {
                self.containerView.frame.size.height = 278
            }
        case 1:
            // Signup View
            loginView.removeFromSuperview()
            containerView.addSubview(signupView)
            containerView.bringSubviewToFront(segmentedControl)
            UIView.animate(withDuration: 0.7) {
                self.containerView.frame.size.height = 400
            }
        default:
            break
        }
        
    }
    
    
    class func createUserDataFile() {
        let fileName = "userDatas"
        let documentDirectoryUrl = try! FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        print("Writing UserData File path \(fileUrl.path)")
        
        
        let jsonString = """
        {
            "userFullName": "\(UserData.shared.user.userFullName!)",
            "userEmail": "\(UserData.shared.user.userEmail!)",
            "userPassword": "",
            "userImage": "\(UserData.shared.user.userImage!)",
            "userRegistrationDate": "\(UserData.shared.user.userRegistrationDate!)",
            "userNumberOfWordsLearned": \(UserData.shared.user.userNumberOfWordsLearned!),
            "userNumberOfCompletedCourseCategory": \(UserData.shared.user.userNumberOfCompletedCourseCategory!),
            "userAveragePronunciationScore": \(UserData.shared.user.userAveragePronunciationScore!),
            "userPronunciationNumberOfTrying": \(UserData.shared.user.userPronunciationNumberOfTrying!),
            "userAchievementStatus": \(UserData.shared.user.userAchievementStatus!)
        }
        """

        let learnedWords = [
            (UserData.shared.user.userA1LearnedWords!, "userA1LearnedWords"),
            (UserData.shared.user.userA2LearnedWords!, "userA2LearnedWords"),
            (UserData.shared.user.userB1LearnedWords!, "userB1LearnedWords"),
            (UserData.shared.user.userB2LearnedWords!, "userB2LearnedWords"),
            (UserData.shared.user.userC1LearnedWords!, "userC1LearnedWords"),
            (UserData.shared.user.userC2LearnedWords!, "userC2LearnedWords")
        ]

        do {
            var jsonObject = try JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as! [String: Any]

            for (words, key) in learnedWords {
                let wordsData = words.map { word -> [String: String] in
                    return [
                        "wordEnglishMeaning": word.wordEnglishMeaning!,
                        "wordTurkishMeaning": word.wordTurkishMeaning!
                    ]
                }

                jsonObject[key] = wordsData
            }

            let updatedJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            let updatedJsonString = String(data: updatedJsonData, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "")
            
            do {
                try updatedJsonString!.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print (error)
            }
            
        } catch {
            print("Error encoding JSON: \(error)")
        }

    }
    
    class func createCategoryDataFile() {
        let fileName = "categoryDatas"
        let documentDirectoryUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        var categories = [Category]()
        for category in CategoryData.shared.categories {
            categories.append(category)
        }

        var jsonObject = [[String: Any]]()
        
        for category in categories {
            var categoryDictionary = [String: Any]()
            categoryDictionary["categoryLevel"] = category.categoryLevel
            categoryDictionary["categoryName"] = category.categoryName
            
            var wordsData = [[String: String]]()
            for word in category.categoryWords! {
                let wordData: [String: String] = [
                    "wordEnglishMeaning": word.wordEnglishMeaning!,
                    "wordTurkishMeaning": word.wordTurkishMeaning!
                ]
                wordsData.append(wordData)
            }
            categoryDictionary["categoryWords"] = wordsData
            
            jsonObject.append(categoryDictionary)
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {

                do {
                    try jsonString.write(to: fileUrl, atomically: true, encoding: .utf8)
                } catch let error as NSError {
                    print("Error writing Category Data file: \(error)")
                }
            }
        } catch {
            print("Error encoding Category Data: \(error)")
        }
    }

    
    class func readFile(fileName: String) -> Data {
        let documentDirectoryUrl = try! FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        var readFile = ""
        do {
            readFile = try String(contentsOf: fileUrl)
        } catch let error as NSError {
            print(error)
        }
        
        return readFile.data(using: .utf8)!
    }
}
