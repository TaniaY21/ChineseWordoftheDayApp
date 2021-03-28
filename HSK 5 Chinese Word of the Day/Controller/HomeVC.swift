//
//  ViewController.swift
//  HSK 5 Chinese Word of the Day
//
//  Created by Tania Yeromiyan on 23/12/2020.
//

import UIKit
import AVFoundation
import UserNotifications
import NotificationCenter
import RealmSwift
import WidgetKit
import SwiftUI
import GoogleMobileAds


class HomeVC: UIViewController {
    
    //MARK: - Instances and labels
    @IBOutlet weak var chineseLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    
    @IBOutlet weak var ex1: UILabel!
    @IBOutlet weak var pinyin1: UILabel!
    @IBOutlet weak var trans1: UILabel!
    
    @IBOutlet weak var ex2: UILabel!
    @IBOutlet weak var pinyin2: UILabel!
    @IBOutlet weak var trans2: UILabel!
    
    @IBOutlet weak var likeButton: SparkButton!
    
    let realm = try! Realm()
    let userDefaults = UserDefaults(suiteName: "group.com.themodernmultilingual.HSK-5-Chinese-Word-of-the-Day")
    
    var isLiked:Bool!
    
    // MARK: - ViewDidLoad
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWhatsNew()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLiked = false
        isRefreshRequired()
        readChinese()
        
        currentVc = self
        admobDelegate.createHomeAd()
 
    }
    
    // MARK: - Whats New popup
    
    func presentWhatsNew() {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        //if never presented before and the appversion is 1.1.1
        if userDefaults?.bool(forKey: "alertPresented") == false && appVersion == "1.1.1" {
            
            print("First time opening app")
            userDefaults?.set(true, forKey: "alertPresented")
            
            let alertController = UIAlertController (title: "What's new", message: "- You can now add widgets to your homescreen \n - Click on the Chinese to hear the pronunciation", preferredStyle: .alert)
            
            let image = UIImage(named: "homescreenWidget")
            alertController.addImage(image: image!)
            
            alertController.addAction(UIAlertAction(title: "好!", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else {
            
            userDefaults?.set(true, forKey: "alertPresented")
            print("Already presented popover once:")
        }
        
    }
    
    //MARK: - UserDefaults
    
    func saveToUserDefaults(with data: ChineseVocab) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaults?.set(encoded, forKey: Constants.UDselectedVocab)
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            } else {
                // Fallback on earlier versions
                return
            }
        }
    }
    
    func readFromUserDefaults() {
        if let savedVocab = userDefaults?.object(forKey: Constants.UDselectedVocab) as? Data {
            let decoder = JSONDecoder()
            if let wordOfTheDay = try? decoder.decode(ChineseVocab.self, from: savedVocab) {
                updateLabels(using: wordOfTheDay)
            } else {
                print("unable to load readFromUserDefaults()")
            }
        }
    }
    
    func isRefreshRequired() {
        
        let calendar = Calendar.current
        
        // IF FIRST TIME
        if userDefaults?.bool(forKey: Constants.UserDefaults.firstLaunch) == false {
            _ = updateWordOfTheDay()
            print("First time opening app")
            userDefaults?.set(true, forKey: Constants.UserDefaults.firstLaunch)
        }
        else {
            print("Not first time opening app")
            userDefaults?.set(true, forKey: Constants.UserDefaults.firstLaunch)
            
            
            let lastAccessDate = userDefaults?.object(forKey: Constants.UserDefaults.lastAccessDate) as? Date ?? Date()
            userDefaults?.set(Date(), forKey: Constants.UserDefaults.lastAccessDate)
            
            if calendar.isDateInToday(lastAccessDate) {
                readFromUserDefaults()
                print("No refresh required as it is the same day as lastAccessDate which was \(lastAccessDate)")
            }
            else {
                print("new day since lastAccessDate")
                _ = updateWordOfTheDay()
            }
        }
    }
    
    //MARK: - Text to Speech
    
    func readChinese() {
        
        chineseLabel.isUserInteractionEnabled = true
        let wordTap = UITapGestureRecognizer(target: self, action: #selector(wordTapped))
        view.addGestureRecognizer(wordTap)
        chineseLabel.addGestureRecognizer(wordTap)
        
        ex1.isUserInteractionEnabled = true
        ex1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.example1Tapped)))
        
        ex2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(example2Tapped))
        view.addGestureRecognizer(tap2)
        ex2.addGestureRecognizer(tap2)
    }
    
    @objc func wordTapped (sender: UITapGestureRecognizer) {
        guard let word = chineseLabel.text else {return}
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(identifier: Constants.SiriVoice.TingTing)
        utterance.preUtteranceDelay = 0
        utterance.rate = 0.4
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @objc func example1Tapped(sender: UITapGestureRecognizer) {
        guard let sentence = ex1.text else {return}
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.voice = AVSpeechSynthesisVoice(identifier: Constants.SiriVoice.MeiJia)
        utterance.preUtteranceDelay = 0
        utterance.rate = 0.4
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
    
    @objc func example2Tapped(sender: UITapGestureRecognizer) {
        guard let sentence = ex2.text else {return}
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.voice = AVSpeechSynthesisVoice(identifier: Constants.SiriVoice.TingTing)
        utterance.preUtteranceDelay = 0
        utterance.rate = 0.4
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    //MARK: - Vocab Data
    
    func retrieveVocab() -> ChineseVocab {
        
        var vocabData: [ChineseVocab] = []
        
        guard let jsonURL = Bundle.main.url(forResource: Constants.JSONFileName, withExtension: Constants.JSONFileEx) else {(fatalError())}
        guard let jsonString = try? String(contentsOf: jsonURL, encoding: String.Encoding.utf8) else {(fatalError())}
        do {
            vocabData = try JSONDecoder().decode([ChineseVocab].self, from: Data(jsonString.utf8))
            vocabData.shuffle()
        } catch {
            print("could not load JSON file \(error)")
        }
        let currentWord = vocabData.removeLast()
        return currentWord // just one element: vocabData.removeLast()
    }
    
    func updateWordOfTheDay() -> ChineseVocab {
        let wordOfTheDay = retrieveVocab()
        saveToUserDefaults(with: wordOfTheDay)
        updateLabels(using: wordOfTheDay)
        return wordOfTheDay
    } 
    
    
    //MARK: - Update Labels
    func updateLabels(using: ChineseVocab) {
        definitionLabel.text = using.Definition
        chineseLabel.text = using.Chinese
        pinyinLabel.text = using.Pinyin
        ex1.text = using.Ex1
        pinyin1.text = using.Pinyin1
        trans1.text = using.Trans1
        ex2.text = using.Ex2
        pinyin2.text = using.Pinyin2
        trans2.text = using.Trans2
        
    }
    
    
    //MARK: - addedToFavourites
    @IBAction func saveToFave (_ sender: AnyObject) {
        isLiked = !isLiked
        
        //for tableView
        let savedVocab = SavedVocab()
        let wordToSaveToRealm = savedVocab
        wordToSaveToRealm.savedWord = chineseLabel.text! + " " + pinyinLabel.text! + " | " + definitionLabel.text!
        
        //for flashcards
        let savedFlashcard = SavedFlashcard()
        let chineseWord = savedFlashcard, pinyin = savedFlashcard, definition = savedFlashcard, ex1FC = savedFlashcard, ex1PinyinFC = savedFlashcard, trans1FC = savedFlashcard, ex2FC = savedFlashcard, ex2PinyinFC = savedFlashcard, trans2FC = savedFlashcard
        
        chineseWord.savedChineseWord = chineseLabel.text ?? ""
        pinyin.savedPinyin =  pinyinLabel.text ?? ""
        definition.savedDefinition = definitionLabel.text ?? ""
        
        ex1FC.savedEx1 = ex1.text ?? ""
        ex1PinyinFC.savedEx1Pinyin = pinyin1.text ?? ""
        trans1FC.savedTrans1 = trans1.text ?? ""
        
        ex2FC.savedEx2 = ex2.text ?? ""
        ex2PinyinFC.savedEx2Pinyin = pinyin2.text ?? ""
        trans2FC.savedTrans2 = trans2.text ?? ""
        
        if isLiked == true {
            likeButton.setImage(UIImage(named: Constants.heartImage), for: UIControl.State())
            likeButton.likeBounce(0.6)
            likeButton.animate()
            
            RealmManager.sharedInstance.saveToRealm(with: wordToSaveToRealm)
            
            RealmManager.sharedInstance.createChineseFlashard(savedChineseWord: chineseWord, savedPinyin: pinyin, savedDefinition: definition, savedEx1: ex1FC, savedEx1Pinyin: ex1PinyinFC, savedTrans1: trans1FC, savedEx2: ex2FC, savedEx2Pinyin: ex2PinyinFC, savedTrans2: trans2FC)
            
            (sender as? UIButton)?.isEnabled = false
        }
    }
}




