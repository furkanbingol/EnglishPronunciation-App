//
//  PronunciationViewController.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 22.03.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation
import Speech
import Differ
import MicrosoftCognitiveServicesSpeech


extension StringProtocol {
    var words: [SubSequence] {
        split(whereSeparator: \.isWhitespace)
    }
}


class PronunciationViewController: UIViewController, PronunciationViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    let firestoreDatabase = Firestore.firestore()
    
    // MARK: - Properties
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private let apiKey = "YOUR_API_KEY"
    private let region = "YOUR_REGION"
    
    // AVAudioPlayer - ses dalgasındaki kullanıcı 'sesini oynatabilmek' için
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    
    
    var pronunciationView: PronunciationView = {
        let pronunciationView = PronunciationView()
        return pronunciationView
    }()
    
    
    var user = User()
    var categories = [Category]()
    var score = Score.shared
   
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pronunciation"
        
        user = UserData.shared.user
        categories = CategoryData.shared.categories
        UserData.shared.allLearnedWords = getAllLearnedWords()
        let allLearnedWords = UserData.shared.allLearnedWords
        
        if allLearnedWords.count != 0 {
            pronunciationView.warningView.isHidden = true
            pronunciationView.containerView.isHidden = false
            pronunciationView.micButton.isHidden = false
            
            pronunciationView.englishTextLabel.text = allLearnedWords[0].wordEnglishMeaning!
            pronunciationView.turkishTextLabel.text = allLearnedWords[0].wordTurkishMeaning!
        } else {
            // Show warning view to inform the user
            pronunciationView.warningView.isHidden = false
            pronunciationView.containerView.isHidden = true
            pronunciationView.middleWaveformView.isHidden = true
            pronunciationView.audioWavePlayAndStopButton.isHidden = true
            pronunciationView.micButton.isHidden = true
            pronunciationView.stopButtonContainerView.isHidden = true
            pronunciationView.rightButton.isHidden = true
        }
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        self.view.backgroundColor = .systemRed
                    }
                }
            }
        } catch {
            self.view.backgroundColor = .systemRed
        }
         
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes?[.font] = UIFont.systemFont(ofSize: 17, weight: .regular)
        CategoryData.shared.option = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        
        var allLearnedWords = getAllLearnedWords()
        
        if allLearnedWords.count != 0 {
            pronunciationView.warningView.isHidden = true
            pronunciationView.containerView.isHidden = false
            pronunciationView.micButton.isHidden = false
            
            let previousText = pronunciationView.englishTextLabel.text!
            
            if previousText == "English Meaning" {
                UserData.shared.allLearnedWords = getAllLearnedWords()
                allLearnedWords = UserData.shared.allLearnedWords
                
                pronunciationView.englishTextLabel.text = allLearnedWords[0].wordEnglishMeaning!
                pronunciationView.turkishTextLabel.text = allLearnedWords[0].wordTurkishMeaning!
            }
            if CategoryData.shared.option != "" {
                pronunciationView.englishTextLabel.text = CategoryData.shared.selectedWordInRepeatPage.wordEnglishMeaning!
                pronunciationView.turkishTextLabel.text = CategoryData.shared.selectedWordInRepeatPage.wordTurkishMeaning!
                pronunciationView.middleWaveformView.isHidden = true
                pronunciationView.audioWavePlayAndStopButton.isHidden = true
                pronunciationView.rightButton.isHidden = true
                pronunciationView.tableView.isHidden = true
            }
        }
    }
    
    override func loadView() {
        self.view = pronunciationView
        pronunciationView.delegate = self
    }
    
    private func getAllLearnedWords() -> [Word] {
        let user = UserData.shared.user
        var allWords = [Word]()
        
        if (user.userA1LearnedWords == nil || user.userA1LearnedWords?.count == 0) &&
            (user.userA2LearnedWords == nil || user.userA2LearnedWords?.count == 0) &&
            (user.userB1LearnedWords == nil || user.userB1LearnedWords?.count == 0) &&
            (user.userB2LearnedWords == nil || user.userB2LearnedWords?.count == 0) &&
            (user.userC1LearnedWords == nil || user.userC1LearnedWords?.count == 0) &&
            (user.userC2LearnedWords == nil || user.userC2LearnedWords?.count == 0) {
            return []
        }
                
        for a1Word in user.userA1LearnedWords! {
            allWords.append(a1Word)
        }
        for a2Word in user.userA2LearnedWords! {
            allWords.append(a2Word)
        }
        for b1Word in user.userB1LearnedWords! {
            allWords.append(b1Word)
        }
        for b2Word in user.userB2LearnedWords! {
            allWords.append(b2Word)
        }
        for c1Word in user.userC1LearnedWords! {
            allWords.append(c1Word)
        }
        for c2Word in user.userC2LearnedWords! {
            allWords.append(c2Word)
        }
                
        allWords.shuffle()     // randomly
        return allWords
    }

    
    // MARK: - Delegate Functions {micButtonTapped and rightButtonTapped}
    func micButtonTapped() {
         if audioRecorder == nil {
            startRecording()
            
            pronunciationView.micButton.isHidden = true
            pronunciationView.stopButtonContainerView.isHidden = false
         } else {
            finishRecording(success: true)
            pronunciationView.stopButtonContainerView.isHidden = true
            pronunciationView.activityIndicator.startAnimating()
            
            let text = self.pronunciationView.englishTextLabel.text!
            DispatchQueue.global(qos: .userInitiated).async {
                self.pronunciationAssessment(referenceText: text)
            }
         }
    }

    func rightButtonTapped() {
        pronunciationView.rightButton.isHidden = true
        pronunciationView.middleWaveformView.isHidden = true
        pronunciationView.audioWavePlayAndStopButton.isHidden = true
        pronunciationView.tableView.isHidden = true
        
        UserData.shared.allLearnedWords = getAllLearnedWords()
        var allLearnedWords = UserData.shared.allLearnedWords
        
        if allLearnedWords.count != 1 {
            let previousText = pronunciationView.englishTextLabel.text!
            
            // for Randomness
            while previousText == allLearnedWords[0].wordEnglishMeaning! {
                UserData.shared.allLearnedWords = getAllLearnedWords()
                allLearnedWords = UserData.shared.allLearnedWords
            }
        }

        if CategoryData.shared.option != "" {
            CategoryData.shared.option = ""
        }
        
        pronunciationView.englishTextLabel.text = allLearnedWords[0].wordEnglishMeaning!
        pronunciationView.turkishTextLabel.text = allLearnedWords[0].wordTurkishMeaning!
    }
    
    func audioWavePlayAndStopButtonTapped() {
        let audioURL = PronunciationViewController.getAudioURL()
        
        if isPlaying {    // Ses oynatılıyorsa durdur
            audioPlayer?.stop()
            audioPlayer = nil
            isPlaying = false
            self.pronunciationView.audioWavePlayAndStopButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {   // Ses çalmıyorsa başlat
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                isPlaying = true
                self.pronunciationView.audioWavePlayAndStopButton.setBackgroundImage(UIImage(systemName: "stop.fill"), for: .normal)
            } catch {
                print("AudioPlayer Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Pronunciation
    private func pronunciationAssessment(referenceText: String) {
        var speechConfig: SPXSpeechConfiguration?
        do {
            try speechConfig = SPXSpeechConfiguration(subscription: apiKey, region: region)
        } catch {
            print("error \(error) happened")
            speechConfig = nil
            return
        }
        speechConfig?.speechRecognitionLanguage = "en-US"

        let path = PronunciationViewController.getAudioURL().absoluteURL.path
        
        let audioConfig = SPXAudioConfiguration.init(wavFileInput: path)
        if audioConfig == nil {
            print("Cannot find audio file!")
            return
        }
        
        var pronunciationConfig: SPXPronunciationAssessmentConfiguration?
        do {
            try pronunciationConfig = SPXPronunciationAssessmentConfiguration.init(referenceText,
                                                                                   gradingSystem: SPXPronunciationAssessmentGradingSystem.hundredMark,
                                                                                   granularity: SPXPronunciationAssessmentGranularity.word,
                                                                                   enableMiscue: true)
        // Error Types: None, Omission, Insertion, and Mispronunciation
        } catch {
            print("error \(error) happened")
            pronunciationConfig = nil
            return
        }

        
        let recognizer = try! SPXSpeechRecognizer(speechConfiguration: speechConfig!, audioConfiguration: audioConfig!)
        try! pronunciationConfig!.apply(to: recognizer)
        
        recognizer.addRecognizingEventHandler() {reco, evt in
            print("intermediate recognition result: \(evt.result.text ?? "(no result)")")
        }
        
        var sumAccuracy: Double = 0
        var sumDuration: TimeInterval = 0
        var validDuration: TimeInterval = 0
        var startOffset: TimeInterval = 0
        var endOffset: TimeInterval = 0
        var pronunciationScore = 0
        var pronWords: [SPXWordLevelTimingResult] = []
        var recognizedWords: [String] = []
        
        
        recognizer.addRecognizedEventHandler() {reco, evt in
            print("Received final result event. SessionId: \(evt.sessionId), recognition result: \(evt.result.text!). Status \(evt.result.reason). offset \(evt.result.offset) duration \(evt.result.duration) resultid: \(evt.result.resultId)\n")
            
            let pronunciationResult = SPXPronunciationAssessmentResult.init(evt.result)!
            let resultText = "Received final result event. \nrecognition result: \(evt.result.reason), Accuracy score: \(pronunciationResult.accuracyScore), Pronunciation score: \(pronunciationResult.pronunciationScore), Completeness Score: \(pronunciationResult.completenessScore), Fluency score: \(pronunciationResult.fluencyScore)"
            
            pronunciationScore = Int(pronunciationResult.pronunciationScore)
            print(resultText)
            print("------------------------------------------------------")
            
            for word in pronunciationResult.words! {
                pronWords.append(word)
                recognizedWords.append(word.word!)
                sumAccuracy += word.accuracyScore * Double(word.duration)
                sumDuration += word.duration;
                if (word.errorType == "None") {
                    validDuration += word.duration + 0.01
                }
                endOffset = word.offset + word.duration + 0.01
            }
        }

        
        var end = false
        recognizer.addSessionStoppedEventHandler() {reco, evt in
            end = true
        }

        print("----------------Assessing...------------------")

        try! recognizer.startContinuousRecognition()
        while !end {
            Thread.sleep(forTimeInterval: 1.0)
        }
        try! recognizer.stopContinuousRecognition()

        var referenceWords: [String] = []
        for w in referenceText.words {
            referenceWords.append(String(w).lowercased().trimmingCharacters(in: .punctuationCharacters))
        }
        
        
        let diff = referenceWords.outputDiffPathTraces(to: recognizedWords)
        var finalWords: [PronunciationWord] = []
        var validWordCount = 0
        for e in diff {
            if e.from.x + 1 == e.to.x && e.from.y + 1 == e.to.y {
                let v = pronWords[e.from.y]
                finalWords.append(PronunciationWord(word: v.word!, errorType: v.errorType!, accuracyScore: v.accuracyScore))
                validWordCount += 1
            } else if e.from.y < e.to.y {
                let v = pronWords[e.from.y]
                finalWords.append(PronunciationWord(word: v.word!, errorType: "Insertion"))
            } else {
                finalWords.append(PronunciationWord(word:referenceWords[e.from.x], errorType: "Omission"))
            }
        }

        if (recognizedWords.count > 0) {
            startOffset = pronWords[0].offset
            let fluencyScore: Double = Double(validDuration) / Double(endOffset - startOffset) * 100.0
            let completenessScore: Double = Double(validWordCount) / Double(referenceWords.count)
            var resultText = "Assessment finished. \nOverall accuracy score: \(sumAccuracy / Double(sumDuration)), fluency score: \(fluencyScore), completeness score: \(completenessScore)"

            for w in finalWords {
                resultText += "\n"
                resultText += " word: \(w.word)\taccuracy score: \(w.accuracyScore)\terror type: \(w.errorType);"
            }
            print(resultText)
        }
        
        // Butonları ayarlama ve Kullanıcının Pronunciation Denemesini Artırma
        DispatchQueue.main.async {
            self.score.words = finalWords
            self.score.pronunciationScore = pronunciationScore
            
            self.pronunciationView.activityIndicator.stopAnimating()
            self.pronunciationView.micButton.isHidden = false
            self.pronunciationView.rightButton.isHidden = false
            self.pronunciationView.middleWaveformView.isHidden = false
            self.pronunciationView.tableView.isHidden = false
            self.pronunciationView.tableView.reloadData()
            let audioURL = PronunciationViewController.getAudioURL()
            self.pronunciationView.updateWaveformImages(audioURL: audioURL)
            
            self.user.userPronunciationNumberOfTrying! += 1
            let avg = self.user.userAveragePronunciationScore!
            let numberOfTrying = self.user.userPronunciationNumberOfTrying!
            let newAverageScore = ((numberOfTrying - 1) * avg + self.score.pronunciationScore) / numberOfTrying
            self.user.userAveragePronunciationScore = newAverageScore
            
            self.updateFirestore()
        }
        
    }
    
    
    func startRecording() {
        let audioURL = PronunciationViewController.getAudioURL()
        print("AUDIO URL: \(audioURL.absoluteString)")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),    // kAudioFormatLinearPCM == .wav file
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if !success {
            let alert = UIAlertController(title: "Record failed", message: "There was a problem recording your audio; please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
    }
    
    
    private func updateFirestore() {
        var pronunciationAchievement = false
        let currentUserMail = user.userEmail!
        
        if user.userAchievementStatus![2] == false {
            user.userAchievementStatus![2] = true
            pronunciationAchievement = true
        }

        self.firestoreDatabase.collection("Users").whereField("userEmail", isEqualTo: currentUserMail).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            
            for document in snapshot.documents {
                let documentRef = self.firestoreDatabase.collection("Users").document(document.documentID)
                
                // update for pronunciationNumberOfTrying
                documentRef.updateData(["userPronunciationNumberOfTrying" : self.user.userPronunciationNumberOfTrying!]) { error in
                    guard error == nil else {
                        self.makeAlert(title: "Error", message: error!.localizedDescription)
                        return
                    }
                    
                    // update for averagePronunciationScore
                    documentRef.updateData(["userAveragePronunciationScore" : self.user.userAveragePronunciationScore!]) { error in
                        guard error == nil else {
                            self.makeAlert(title: "Error", message: error!.localizedDescription)
                            return
                        }
                        
                        if pronunciationAchievement {
                            // update for achievementStatus
                            documentRef.updateData(["userAchievementStatus" : self.user.userAchievementStatus!]) { error in
                                guard error == nil else {
                                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                                    return
                                }
                                self.writeUpdatesToFile()    // update file
                            }
                        }
                        else {
                            self.writeUpdatesToFile()    // update file
                        }
                    }
                }
            }
        }
    }
    
    
    private func writeUpdatesToFile() {
        let fileName = "userDatas"
        let documentDirectoryUrl = try! FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")

        guard let jsonString = try? String(contentsOfFile: fileUrl.path, encoding: .utf8),
              var json = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? [String: Any] else {
            return
        }
    
        
        // Updates
        if let _ = json["userPronunciationNumberOfTrying"] as? Int {
            json["userPronunciationNumberOfTrying"] = user.userPronunciationNumberOfTrying!
            json["userAveragePronunciationScore"] = user.userAveragePronunciationScore!
            json["userAchievementStatus"] = user.userAchievementStatus!
        }

        // Write to userDatas.txt file
        if let updatedJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
            try? updatedJsonString.write(to: fileUrl, atomically: true, encoding: .utf8)
        }
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    class func getAudioURL() -> URL {
        return getDocumentsDirectory().appendingPathExtension("recorded-audio.wav")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == false {
            finishRecording(success: false)
        }
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        self.pronunciationView.audioWavePlayAndStopButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
}
