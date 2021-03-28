//
//  RealmManager.swift
//  HSK 5 Chinese Word of the Day
//
//  Created by Tania Yeromiyan on 23/12/2020.
//

import Foundation
import RealmSwift

class RealmManager {
    private var   realm: Realm
    static let   sharedInstance = RealmManager()
    
    private init() {
        realm = try! Realm()
    }
    
    func saveToRealm(with word: SavedVocab)   {
        try! realm.write {
            realm.add(word)
        }
    }
    
    func createChineseFlashard(savedChineseWord: SavedFlashcard, savedPinyin: SavedFlashcard, savedDefinition: SavedFlashcard, savedEx1: SavedFlashcard, savedEx1Pinyin: SavedFlashcard, savedTrans1: SavedFlashcard, savedEx2: SavedFlashcard, savedEx2Pinyin: SavedFlashcard, savedTrans2: SavedFlashcard) {
        try! realm.write {
            realm.add(savedChineseWord)
            realm.add(savedPinyin)
            realm.add(savedDefinition)
            
            realm.add(savedEx1)
            realm.add(savedEx1Pinyin)
            realm.add(savedTrans1)
            
            realm.add(savedEx2)
            realm.add(savedEx2Pinyin)
            realm.add(savedTrans2)
        }
    }
    
    func deleteSelectedFromRealm(word: SavedVocab, flashcard: SavedFlashcard)   {
        try!  realm.write {
            realm.delete(word)
            realm.delete(flashcard)
            
        }
    }
    
    func retrieveFromRealm() ->   Results<SavedVocab> {
        let favourites: Results<SavedVocab> =  realm.objects(SavedVocab.self)
        //let favourites = realm.objects(SavedVocab.self)
        return favourites
    }
    
    func retrieveFlashcard() -> Results<SavedFlashcard> {
        let flashcards: Results<SavedFlashcard> = realm.objects(SavedFlashcard.self)
        return flashcards
    }
    
    func deleteAllFromRealm()  {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}

// MARK: - Realm Structs

class SavedVocab: Object {
    @objc dynamic var savedWord: String = ""
}

class SavedFlashcard: Object {
    @objc dynamic var savedChineseWord: String = ""
    @objc dynamic var savedPinyin: String = ""
    @objc dynamic var savedDefinition: String = ""
    
    @objc dynamic var savedEx1: String = ""
    @objc dynamic var savedEx1Pinyin: String = ""
    @objc dynamic var savedTrans1: String = ""
    
    @objc dynamic var savedEx2: String = ""
    @objc dynamic var savedEx2Pinyin: String = ""
    @objc dynamic var savedTrans2: String = ""
    
}

