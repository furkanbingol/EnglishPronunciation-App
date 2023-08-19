//
//  PronunciationView.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 23.03.2023.
//

import UIKit
import DSWaveformImage
import DSWaveformImageViews

protocol PronunciationViewDelegate: AnyObject {
    func micButtonTapped()
    func rightButtonTapped()
    func audioWavePlayAndStopButtonTapped()
}

class PronunciationView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Delegate
    weak var delegate: PronunciationViewDelegate?
    
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView! {
        willSet {
            newValue.delegate = self
            newValue.dataSource = self
            newValue.isHidden = true
            newValue.register(ScoreHeaderTableViewCell.nib(), forCellReuseIdentifier: ScoreHeaderTableViewCell.identifier)
            newValue.register(ScoreTableViewCell.nib(), forCellReuseIdentifier: ScoreTableViewCell.identifier)
        }
    }
    @IBOutlet weak var middleWaveformView: WaveformImageView! {
        willSet {
            newValue.layer.cornerRadius = 20
            newValue.isHidden = true
            newValue.backgroundColor = .clear
            
            newValue.layer.shadowColor = UIColor.black.cgColor
            newValue.layer.shadowOpacity = 1
            newValue.layer.shadowOffset = .zero
            newValue.layer.shadowRadius = 100
        }
    }
    
    @IBOutlet var view: UIView!
    @IBOutlet var containerView: UIView! {
        willSet {
            newValue.backgroundColor = .systemGray5
            newValue.layer.cornerRadius = 40
            
            newValue.layer.shadowColor = UIColor.black.cgColor
            newValue.layer.shadowOpacity = 1
            newValue.layer.shadowOffset = .zero
            newValue.layer.shadowRadius = 7
        }
    }
    @IBOutlet weak var warningView: UIView! {
        willSet {
            newValue.layer.cornerRadius = 30
            newValue.isHidden = true
        }
    }
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var stopButtonContainerView: UIView! {
        willSet {
            newValue.layer.cornerRadius = 20
            newValue.isHidden = true
            newValue.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var englishTextLabel: UILabel!
    @IBOutlet weak var turkishTextLabel: UILabel!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var rightButton: UIButton! {
        willSet {
            newValue.isHidden = true
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        willSet {
            newValue.hidesWhenStopped = true
            newValue.isHidden = true
        }
    }
    @IBOutlet weak var audioWavePlayAndStopButton: UIButton! {
        willSet {
            newValue.isHidden = true
            newValue.tintColor = UIColor(red: 255.0/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1)
        }
    }
    
    
    // MARK: - Properties
    var score = Score.shared
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopContainerViewTapped))
        stopButtonContainerView.addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Functions
    func setup() {
        if let view = Bundle.main.loadNibNamed("PronunciationView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
        
    // MARK: - Functions
    func updateWaveformImages(audioURL: URL) {
        middleWaveformView.configuration = Waveform.Configuration(
            backgroundColor: .systemGroupedBackground.withAlphaComponent(0.15),
            style: .striped(.init(color: UIColor(red: 255.0/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1), width: 5, spacing: 5)),
            verticalScalingFactor: 0.7
        )
        middleWaveformView.waveformAudioURL = audioURL
        audioWavePlayAndStopButton.isHidden = false
    }
    
    
    // MARK: - Actions
    @IBAction func micButtonTapped(_ sender: UIButton) {
        delegate?.micButtonTapped()
    }
    
    @objc func stopContainerViewTapped() {
        delegate?.micButtonTapped()
    }
    
    @IBAction func rightButtonTapped() {
        delegate?.rightButtonTapped()
    }
    
    @IBAction func audioWavePlayAndStopButtonTapped() {
        delegate?.audioWavePlayAndStopButtonTapped()
    }
    

    // MARK: - TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return score.words.count + 1        // +1: for Header Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreHeaderTableViewCell.identifier, for: indexPath) as? ScoreHeaderTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as? ScoreTableViewCell else {
                return UITableViewCell()
            }
            
            if score.words.count > 0 {
                cell.configureScoreCell(wordString: score.words[indexPath.row - 1].word,
                                        errorType: score.words[indexPath.row - 1].errorType,
                                        accuracyScore: Int(score.words[indexPath.row - 1].accuracyScore))
            } else {
                print("word sayısı 0")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
  
}
