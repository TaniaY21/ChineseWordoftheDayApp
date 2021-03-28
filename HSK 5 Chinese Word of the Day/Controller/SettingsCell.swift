//
//  SettingsCell.swift
//  HSK 5 Chinese Word of the Day
//
//  Created by Tania Yeromiyan on 24/12/2020.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let identifier = "SettingTableViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.tintColor =  Constants.blue
        image.contentMode = .center
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImage)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        
        label.frame = CGRect(x: 15,
                             y: 0,
                             width: contentView.frame.size.width - 15,
                             height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImage.image = nil
        label.text = nil
    }
    
    public func configure(with model: SettingOption) {
        label.text = model.title
        iconImage.image = model.icon
    }
}

// MARK: - DatePickerTableViewCell

class DatePickerTableViewCell: UITableViewCell {
    static let identifier = "DatePickerTableViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker  = UIDatePicker()
        datePicker.sizeToFit()
        datePicker.datePickerMode = .time
        datePicker.tintColor = Constants.blue
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    @objc  func pickerValueChanged(_ sender: UIDatePicker) {
        UserDefaults.standard.set(sender.date, forKey: Constants.UserDefaults.SavedTime)
        print(sender.date)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(datePicker)
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 15,
                             y: 0,
                             width: contentView.frame.size.width - 15,
                             height: contentView.frame.size.height)
        
        datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        datePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        
        
        datePicker.addTarget(self, action: #selector(pickerValueChanged(_:)), for: .valueChanged)
        let selectedTime = UserDefaults.standard.object(forKey: Constants.UserDefaults.SavedTime) as? Date
        datePicker.setDate(selectedTime ?? Date(), animated: false) // UDefaults reflected back to IB outlet interface
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with model: DatePickerOption) {
        label.text = model.title
    }
}

