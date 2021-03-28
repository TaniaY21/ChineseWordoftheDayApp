//
//  SettingsVC.swift
//  HSK 5 Chinese Word of the Day
//
//  Created by Tania Yeromiyan on 24/12/2020.
//

import UIKit
import UserNotifications
import NotificationCenter
import MessageUI
import StoreKit

class SettingsVC: UITableViewController {
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        tableView.tintColor = .purple
        tableView.separatorStyle = .singleLine
        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        
        configureTableContent()
        
    }
    
    // MARK: - Contents
    
    func configureTableContent() {
        
        models.append(Section(title: Constants.Settings.Notification, sectionRows: [
            
            .staticCell(model: SettingOption(title: Constants.Settings.NotificationSettings, icon: UIImage(systemName: Constants.Settings.PhoneIcon), handler: {
                
                self.openSettings()
            }
            )),
            
            .datePickerCell(model: DatePickerOption(title: Constants.Settings.SetNotificationTime, handler: {}
                                                    
            )),
        ]))
        
        models.append(Section(title: Constants.Settings.HelpAndSupport, sectionRows: [
            
            .staticCell(model: SettingOption(title: Constants.Settings.RateUs, icon: UIImage(systemName: Constants.Settings.HeartTextSquareIcon), handler: {
                if #available(iOS 14.0, *) {
                    self.rateOnAppStore()
                } else {
                    // Fallback on earlier versions
                }
            })),
            
            .staticCell(model: SettingOption(title: Constants.Settings.ShareYourSuggestions, icon: UIImage(systemName: Constants.Settings.Paperplane), handler: {
                self.sendEmail()
            }))
        ]))
        
        models.append(Section(title: Constants.Settings.About, sectionRows: [
            
            .staticCell(model: SettingOption(title: Constants.Settings.PrivacyPolicy, icon: UIImage(systemName: Constants.Settings.LockIcloudIcon), handler: {
                
                guard let url = URL(string: Constants.Settings.GithubPrivacy) else { return }
                UIApplication.shared.open(url)
                
            })),
            
            .staticCell(model: SettingOption(title: Constants.Settings.Terms, icon: UIImage(systemName: Constants.Settings.DocIcon), handler: {
                
                guard let url = URL(string: Constants.Settings.GithubTerms) else { return }
                UIApplication.shared.open(url)
                
            })),
        ]))
    }
    
    // MARK: - Functions when Cell Pressed
    
    func openSettings () {
        let alertController = UIAlertController (title: Constants.Settings.ChangeNotificationSetting, message: "", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: Constants.Settings.Settings, style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
            return
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @available(iOS 14.0, *)
    func rateOnAppStore() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].sectionRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.section].sectionRows[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingTableViewCell.identifier,
                    for: indexPath)
                    as? SettingTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            return cell
            
        case .datePickerCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DatePickerTableViewCell.identifier,
                    for: indexPath)
                    as? DatePickerTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].sectionRows[indexPath.row]
        switch type.self {
        
        case .staticCell(let model):
            model.handler()
            
        case .datePickerCell(let model):
            model.handler()
        }
    }
    
}

//MARK: - Mail composer
extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Constants.MyEmail])
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true)
            
        } else {
            
            let alertController = UIAlertController (title: Constants.MailAlert, message: Constants.MailAlertMessage, preferredStyle: .alert)
            
            let copyEmail = UIAlertAction(title: "Copy email", style: .default) { (success) in
                UIPasteboard.general.string = Constants.MyEmail
            }
            
            let cancel = UIAlertAction(title: "算了", style: .default, handler: nil)
            
            alertController.addAction(copyEmail)
            alertController.addAction(cancel)


            present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            //show error alert
            print("Could not send mail")
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled:
            print("cancelled")
        case .sent:
            print("email sent")
        case .failed:
            print("failed")
        case .saved:
            print("saved")
        @unknown default:
            print("new case")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Structs for TableView

struct Section {
    let title: String
    let sectionRows: [SettingOptionType]
}

enum SettingOptionType {
    case staticCell(model:SettingOption)
    case datePickerCell(model:DatePickerOption)
}

struct SettingOption {
    let title: String
    var icon:UIImage? = nil
    let handler: (()-> Void)
}

struct DatePickerOption {
    let title: String
    let handler: (() -> Void)
}
