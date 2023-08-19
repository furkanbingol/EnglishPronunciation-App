//
//  ProfileViewController.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 22.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

class ProfileViewController: UIViewController, ProfileViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let storage = Storage.storage().reference()
    let firestoreDatabase = Firestore.firestore()
    
    
    // MARK: - Properties
    private var profileView: ProfileView = {
        let profileView = ProfileView()
        return profileView
    }()
    
    var user = User()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        user = UserData.shared.user
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUserStatsAndAchievements()
    }
    
    override func loadView() {
        self.view = profileView
        profileView.delegate = self     // for successful delegate
    }
    
    
    func configureUI() {
        profileView.nameLabel.text = user.userFullName
        profileView.mailLabel.text = user.userEmail
        profileView.registrationDateLabel.text = user.userRegistrationDate
        
        if user.userImage == "default" {
            profileView.imageView.image = UIImage(named: "user")
        }
        else {
            let imageUrl = URL(string: user.userImage!)!
            profileView.imageView.kf.indicatorType = .activity
            profileView.imageView.kf.setImage(with: imageUrl)
        }
        
    }
    
    func configureUserStatsAndAchievements() {
        profileView.tableView.reloadData()
    }
    
    
    // MARK: - Delegate Functions
    func logoutButtonTapped() {
        let alert = UIAlertController(title: "Confirm Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            do {
                try Auth.auth().signOut()
                let vc = LoginViewController(nibName: "FirstScreenView", bundle: nil)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            catch {
                print("Error")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true

        present(pickerController, animated: true)
    }
    
    
    // MARK: - Alert Function
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // info: Dictionary
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        
        // Activity Indicator
        profileView.imageView.isHidden = true
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = profileView.imageView.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        // Adding image to Storage
        let uuid = UUID().uuidString
        let mediaFolder = storage.child("profilePhotos")
        let imageRef = mediaFolder.child("\(uuid).jpg")
        activityIndicator.isHidden = false
        
        imageRef.putData(imageData) { metadata, error in
            guard error == nil else {
                self.makeAlert(title: "Error!", message: error!.localizedDescription)
                return
            }
            
            // O image'in metadatasını(url) Firestore'da saklamalıyız.
            imageRef.downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let imageUrl = url.absoluteString

                // Adding data to Firestore
                let currentUserMail = (Auth.auth().currentUser?.email)!
                self.firestoreDatabase.collection("Users").whereField("userEmail", isEqualTo: currentUserMail).getDocuments { snapshot, error in     // Query
                    guard let snapshot = snapshot, error == nil else {
                        self.makeAlert(title: "Error", message: error!.localizedDescription)
                        return
                    }
                    
                    for document in snapshot.documents {
                        let documentRef = self.firestoreDatabase.collection("Users").document(document.documentID)
                        
                        documentRef.updateData(["userImage": imageUrl]) { error in
                            guard error == nil else {
                                self.makeAlert(title: "Error", message: error!.localizedDescription)
                                return
                            }
                            
                            // UI Operation must be in mainQueue
                            DispatchQueue.main.async {
                                self.writeUpdatesToFile(imageURL: imageUrl)
                                self.user.userImage = imageUrl
                                activityIndicator.isHidden = true
                                self.profileView.imageView.image = image
                                self.profileView.imageView.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func writeUpdatesToFile(imageURL: String) {
        // Profile photo updates writing to JSON file
        let fileName = "userDatas"
        let documentDirectoryUrl = try! FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")

        guard let jsonString = try? String(contentsOfFile: fileUrl.path, encoding: .utf8),
              var json = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? [String: Any] else {
            return
        }

        // Update userImage
        if let _ = json["userImage"] as? String {
            json["userImage"] = imageURL
        }

        // Write to userDatas.txt file
        if let updatedJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
            try? updatedJsonString.write(to: fileUrl, atomically: true, encoding: .utf8)
        }

    }
    
}
