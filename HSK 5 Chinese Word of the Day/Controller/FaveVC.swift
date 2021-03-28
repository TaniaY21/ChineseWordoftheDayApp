//
//  FaveVC.swift
//  HSK 5 Chinese Word of the Day
//
//  Created by Tania Yeromiyan on 23/12/2020.
//

import UIKit
import RealmSwift


class FaveVC: UITableViewController {
    
    let realm = try! Realm()
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tintColor = Constants.blue

        
    }
    
    // MARK: - TableViews
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmManager.sharedInstance.retrieveFromRealm().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.favVCcell, for: indexPath) as UITableViewCell
        
        let index = UInt(indexPath.row) //?
        let savedWord = RealmManager.sharedInstance.retrieveFromRealm() [Int(index)] as SavedVocab
        cell.textLabel?.text = savedWord.savedWord
        return cell
    }
    
    
    func tableView (_tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let index = UInt(indexPath.row) //?
        let savedWord = RealmManager.sharedInstance.retrieveFromRealm() [Int(index)] as SavedVocab
        let savedFlashcard = RealmManager.sharedInstance.retrieveFlashcard() [Int(index)] as SavedFlashcard
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            RealmManager.sharedInstance.deleteSelectedFromRealm(word: savedWord, flashcard: savedFlashcard)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        
        let alertController = UIAlertController (title: "Delete all words?", message: "", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "是的", style: .default) { (_) -> Void in
            
            RealmManager.sharedInstance.deleteAllFromRealm()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "不要！", style: .default) { (_) -> Void in
            return
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func startFlashcards(_ sender: Any) {
        //sigue to UICollectionView
    }
    
}
