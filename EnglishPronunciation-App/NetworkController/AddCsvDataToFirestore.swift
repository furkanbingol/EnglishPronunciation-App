//
//  AddCsvDataToFirestore.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 8.04.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class AddCsvDataToFirestore {
    
    static let csvFileToFirestore = AddCsvDataToFirestore()
    private let firestoreDatabase = Firestore.firestore()
    
    private init() { }
    
    
    func addDataToFirestore(csvFileName: String, documentName: String, wordCategoryLevel: String, wordCategoryName: String) {
        let path = Bundle.main.path(forResource: csvFileName, ofType: "csv")
        let content = try! String(contentsOfFile: path!)
        let lines = content.components(separatedBy: "\n")

        for line in lines {
            if line.isEmpty == true {     // Son satır için
                continue
            }
            let fields = line.components(separatedBy: ",")
            let english = fields[0]
            let turkish = fields[1]
            let dictionary = ["wordEnglishMeaning": english, "wordTurkishMeaning": turkish]
            
            
            self.firestoreDatabase.collection("Category").document(documentName).updateData([
                "categoryWords": FieldValue.arrayUnion([dictionary])
            ])
            self.firestoreDatabase.collection("Category").document(documentName).updateData(["categoryLevel": wordCategoryLevel])
            self.firestoreDatabase.collection("Category").document(documentName).updateData(["categoryName": wordCategoryName])
        }
    }
    
}
