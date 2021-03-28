//
//  FlashcardVC.swift
//  HSK 5 Chinese Word of the Day
//
//  Created by Tania Yeromiyan on 23/12/2020.
//

import UIKit
import AVFoundation
import GoogleMobileAds


class FlashcardVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.reloadData()
        
        currentVc = self
        admobDelegate.createFlashcardAd()
    }
    
    // MARK: - CollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RealmManager.sharedInstance.retrieveFlashcard().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellID, for: indexPath) as! CustomCell
        
        let index = UInt(indexPath.row) //?
        let flashcard = RealmManager.sharedInstance.retrieveFlashcard() [Int(index)] as SavedFlashcard // [4]
        
        //  let shuffled = flashcard.shuffled()
        let wotd = flashcard.savedChineseWord
        let pinyin = flashcard.savedPinyin
        let definition = flashcard.savedDefinition
        let ex1 = flashcard.savedEx1
        let ex1Pinyin = flashcard.savedEx1Pinyin
        let trans1 = flashcard.savedTrans1
        
        let ex2 = flashcard.savedEx2
        let ex2Pinyin = flashcard.savedEx2Pinyin
        let trans2 = flashcard.savedTrans2
        
        cell.chineseLabel.text = wotd
        cell.pinyinLabel.text = pinyin
        cell.definitionLabel.text = definition
        cell.ex1.text = ex1
        cell.pinyin1.text = ex1Pinyin
        cell.trans1.text = trans1
        cell.ex2.text = ex2
        cell.pinyin2.text = ex2Pinyin
        cell.trans2.text = trans2
        
        cell.definitionLabel.alpha = 0
        cell.trans1.alpha = 0
        cell.trans2.alpha = 0
        
        cell.readChinese(with: wotd)
        cell.readChinese(with: ex1)
        cell.readChinese(with: ex2)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

class CustomCell: UICollectionViewCell {
    
    static let identifier = Constants.collectionViewCellID
    
    @IBOutlet weak var chineseLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    
    @IBOutlet weak var ex1: UILabel!
    @IBOutlet weak var pinyin1: UILabel!
    @IBOutlet weak var trans1: UILabel!
    
    @IBOutlet weak var ex2: UILabel!
    @IBOutlet weak var pinyin2: UILabel!
    @IBOutlet weak var trans2: UILabel!
    
    @IBOutlet weak var revealAnswer: SparkButton!
    
    @IBAction func revealAnswer (_ sender: AnyObject) {
        
        revealAnswer.animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.definitionLabel.alpha = 1
            self.trans1.alpha = 1
            self.trans2.alpha = 1
        }
    }
    
    
    func readChinese(with word: String) {
        chineseLabel.isUserInteractionEnabled = true
        ex1.isUserInteractionEnabled = true
        ex2.isUserInteractionEnabled = true
        
        let wordTap = UITapGestureRecognizer(target: self, action: #selector(wordTapped))
        chineseLabel.addGestureRecognizer(wordTap)
        
        let setence1 = UITapGestureRecognizer(target: self, action: #selector(ex1Tapped))
        ex1.addGestureRecognizer(setence1)
        
        let setence2 = UITapGestureRecognizer(target: self, action: #selector(ex2Tapped))
        ex2.addGestureRecognizer(setence2)
        
    }
    
    @objc func wordTapped (sender: UITapGestureRecognizer) {
        guard let word = chineseLabel.text else {return}
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(identifier: Constants.SiriVoice.MeiJia)
        utterance.preUtteranceDelay = 0
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @objc func ex1Tapped (sender: UITapGestureRecognizer) {
        guard let ex1 = ex1.text else {return}
        let utterance = AVSpeechUtterance(string: ex1)
        utterance.voice = AVSpeechSynthesisVoice(identifier: Constants.SiriVoice.TingTing)
        utterance.preUtteranceDelay = 0
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @objc func ex2Tapped (sender: UITapGestureRecognizer) {
        guard let ex2 = ex2.text else {return}
        let utterance = AVSpeechUtterance(string: ex2)
        utterance.voice = AVSpeechSynthesisVoice(identifier: Constants.SiriVoice.MeiJia)
        utterance.preUtteranceDelay = 0
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

