//
//  CreateNewSignalVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/13/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class CreateNewCouponVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        layout.scrollDirection = .vertical
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.footerReferenceSize = CGSize(width: cv.frame.width, height: 400)
        cv.isScrollEnabled = true
        return cv
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "DashboardBackgroundImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let menuBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    let menuBar: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = .black
        return tView
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Adding New Signal"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let totalPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Admin"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Create New Coupon"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.contentMode = .bottomLeft
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.setImage(UIImage(named: "mb"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.layer.zPosition = 1
        button.layer.masksToBounds = true
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let durationOptions = ["AUDUSD", "CHFJPY", "EURUSD", "GBPAUD", "GBPJPY", "GBPNZD", "USDCAD", "USDCHF", "USDJPY", "XAUUSD"]
    let tradeTypes = ["Buy", "Sell", "Buy Limit", "Buy Stop", "Sell Limit", "Sell Stop"]
    let tradeStyle = ["Swing", "Scalp"]
    let emaLevel = ["20 EMA", "50 EMA", "200 EMA", "800 EMA"]
    
    fileprivate let cellId = "sendCouponCellId"
    fileprivate let headerId = "sendHeaderCouponCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(CreateCouponCell.self, forCellWithReuseIdentifier: cellId)
        
        cellHolder.register(CreateCouponFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerId)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeButtonTapped), name: Notification.Name("closeCreateCouponPage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: Notification.Name("SendCouponError"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorSending), name: Notification.Name("ErrorSendingCoupon"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displaySuccess), name: Notification.Name("SuccessfullySentCoupon"), object: nil)
        
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func updateButtonTapped() {
        print("open updates")
        let vc = CreateNewUpdateVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CreateCouponCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 800)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerId, for: indexPath) as! CreateCouponFooter
        return headerView
    }
    
    
    private func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(menuBar)
        view.addSubview(topSpacer)
        view.addSubview(cellHolder)
        topSpacer.addSubview(totalPipLabel)
        topSpacer.addSubview(secondPipLabel)
        topSpacer.addSubview(backButton)
        view.addSubview(bottomSpacer)
        
        //
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topSpacer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 50),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            totalPipLabel.leadingAnchor.constraint(equalTo: topSpacer.leadingAnchor, constant: 20),
            totalPipLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            secondPipLabel.leadingAnchor.constraint(equalTo: totalPipLabel.trailingAnchor, constant: 5),
            secondPipLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: topSpacer.trailingAnchor, constant: -20)
            ])
    }
    
    @objc func displayError() {
        self.displayMessage(userMessage: "Please fill out all fields.")
    }
    
    @objc func displaySuccess() {
        self.displayMessage(userMessage: "Notification successfully sent.")
    }
    
    @objc func displayErrorSending() {
        self.displayMessage(userMessage: "Could not send coupon.")
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    // Code in this block will trigger when OK button tapped
                    print("OK Button Tapped")
                    DispatchQueue.main.async {
                        alertController.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //    @objc func confirmButtonTapped() {
    //        print("Posting signal")
    //        // display message saying signal posted successfullly
    //        displayMessage(userMessage: "Signal successfully sent.")
    //    }
    //
    @objc func closeButtonTapped() {
        print("Posting coupon")
        navigationController?.popViewController(animated: true)
    }
    
}

class CreateCouponCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let couponDurationField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Duration", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponCodeField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponNameField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponStatusField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Status", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponDescriptionField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponAmountField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.keyboardType = .numbersAndPunctuation
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponTypeField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Type", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponPackageField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Package", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponStartDateField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Start date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponEndDateField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "End date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let couponMaxRedemptionField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.keyboardType = .numberPad
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Max redemptions", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let datePickerTwo: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let durationPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let typePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let statusPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let packagePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var startDate = NSDate()
    var endDate = NSDate()
    
    let durationOptions = ["forever", "1 week", "2 weeks", "1 month", "2 months"]
    let typeOptions = ["% off", "$ off"]
    let typeOptionsId = ["%", "$"]
    let statusOptions = ["Active", "Inactive"]
    let statusOptionsId = ["1", "0"]
    let packageOptions = ["Essentials Members", "Signals Members", "Advanced Members", "Elite Members", "All Members"]
    let packageOptionsId = ["14", "13", "15", "31", "14,13,15,31"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        durationPicker.delegate = self
        typePicker.delegate = self
        packagePicker.delegate = self
        statusPicker.delegate = self
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDatePickerOne(sender:)), for: .valueChanged)
        
        datePickerTwo.datePickerMode = .date
        datePickerTwo.addTarget(self, action: #selector(handleDatePickerTwo(sender:)), for: .valueChanged)
        
        couponDurationField.inputView = durationPicker
        couponTypeField.inputView = typePicker
        couponStatusField.inputView = statusPicker
        couponPackageField.inputView = packagePicker
        
        couponStartDateField.inputView = datePicker
        couponEndDateField.inputView = datePickerTwo
        
        backgroundColor = .clear
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendSignal), name: Notification.Name("createCouponTapped"), object: nil)
    }
    
    @objc func handleDatePickerOne(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .full
        timeFormatter.timeStyle = .none
//        timeFormatter.date
        couponStartDateField.text = timeFormatter.string(from: sender.date)
        startDate = datePicker.date as NSDate
        datePicker.endEditing(true)
    }
    
    @objc func handleDatePickerTwo(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .full
        timeFormatter.timeStyle = .none
        couponEndDateField.text = timeFormatter.string(from: sender.date)
        endDate = datePickerTwo.date as NSDate
        datePickerTwo.endEditing(true)
    }
    
    private func setupView() {
        addSubview(couponNameField)
        addSubview(couponCodeField)
        addSubview(couponDurationField)
        addSubview(couponTypeField)
        addSubview(couponPackageField)
        addSubview(couponDescriptionField)
        addSubview(couponAmountField)
        addSubview(couponStatusField)
        addSubview(couponStartDateField)
        addSubview(couponEndDateField)
        addSubview(couponMaxRedemptionField)
        
        //
        NSLayoutConstraint.activate([
            couponNameField.heightAnchor.constraint(equalToConstant: 55),
            couponNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponNameField.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            couponCodeField.heightAnchor.constraint(equalToConstant: 55),
            couponCodeField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponCodeField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponCodeField.topAnchor.constraint(equalTo: couponNameField.bottomAnchor, constant: 15),
            
            couponDurationField.heightAnchor.constraint(equalToConstant: 55),
            couponDurationField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponDurationField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponDurationField.topAnchor.constraint(equalTo: couponCodeField.bottomAnchor, constant: 15),
            
            couponDescriptionField.heightAnchor.constraint(equalToConstant: 55),
            couponDescriptionField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponDescriptionField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponDescriptionField.topAnchor.constraint(equalTo: couponDurationField.bottomAnchor, constant: 15),
            
            couponAmountField.heightAnchor.constraint(equalToConstant: 55),
            couponAmountField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponAmountField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponAmountField.topAnchor.constraint(equalTo: couponDescriptionField.bottomAnchor, constant: 15),
            
            couponTypeField.heightAnchor.constraint(equalToConstant: 55),
            couponTypeField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponTypeField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponTypeField.topAnchor.constraint(equalTo: couponAmountField.bottomAnchor, constant: 15),
            
            couponPackageField.heightAnchor.constraint(equalToConstant: 55),
            couponPackageField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponPackageField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponPackageField.topAnchor.constraint(equalTo: couponTypeField.bottomAnchor, constant: 15),
            
            couponStatusField.heightAnchor.constraint(equalToConstant: 55),
            couponStatusField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponStatusField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponStatusField.topAnchor.constraint(equalTo: couponPackageField.bottomAnchor, constant: 15),
            
            couponStartDateField.heightAnchor.constraint(equalToConstant: 55),
            couponStartDateField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponStartDateField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponStartDateField.topAnchor.constraint(equalTo: couponStatusField.bottomAnchor, constant: 15),
            
            couponEndDateField.heightAnchor.constraint(equalToConstant: 55),
            couponEndDateField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponEndDateField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponEndDateField.topAnchor.constraint(equalTo: couponStartDateField.bottomAnchor, constant: 15),
            
            couponMaxRedemptionField.heightAnchor.constraint(equalToConstant: 55),
            couponMaxRedemptionField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            couponMaxRedemptionField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            couponMaxRedemptionField.topAnchor.constraint(equalTo: couponEndDateField.bottomAnchor, constant: 15),
            
            ])
    }
    
    // MARK: UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typePicker {
            return typeOptions.count
        }else if pickerView == durationPicker {
            return durationOptions.count
        }else if pickerView == statusPicker {
            return statusOptions.count
        }else {
            return packageOptions.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker {
            return typeOptions[row]
        }else if pickerView == durationPicker {
            return durationOptions[row]
        }else if pickerView == statusPicker {
            return statusOptions[row]
        }else {
            return packageOptions[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePicker {
            couponTypeField.text = typeOptionsId[row]
        }else if pickerView == durationPicker {
            couponDurationField.text = durationOptions[row]
        }else if pickerView == statusPicker {
            couponStatusField.text = statusOptionsId[row]
        }else {
            couponPackageField.text = packageOptionsId[row]
        }
    }
    
    func sendNewCoupon() {
        let myUrl = URL(string: "http://api.lionsofforex.com/adminv2/create_coupon")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        guard let description = couponDescriptionField.text else { return }
        guard let amount = couponAmountField.text else { return }
        guard let code = couponCodeField.text else { return }
        guard let name = couponNameField.text else { return }
        guard let duration = couponDurationField.text else { return }
        guard let type = couponTypeField.text else { return }
        guard let package = couponPackageField.text else { return }
        guard let status = couponStatusField.text else { return }
//        guard let start = couponStartDateField.text else { return }
//        guard let end = couponEndDateField.text else { return }
        guard let max = couponMaxRedemptionField.text else { return }
        
        let start1 = startDate.timeIntervalSince1970
        let end1 = endDate.timeIntervalSince1970
        
        let startInt = Int((start1 * 1000.0).rounded())
        let endInt = Int((end1 * 1000.0).rounded())
        
        let startAt: String = String(startInt)
        let endAt: String = String(endInt)
        
        
        print("access token is: \(accessText!)")
        let postString: [String: Any] = ["dsc_name": name, "dsc_code": code, "dsc_duration": "", "dsc_description": description, "dsc_amount": amount, "dsc_type": type, "dsc_package": package, "dsc_status": status, "dsc_startDate": startAt, "dsc_endDate": endAt, "dsc_max_redemptions": max]
        // send http request to perform sign in
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    if let userId = json.object(forKey: "success") {
                        print(userId)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name("SuccessfullySentCoupon"), object: nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name("ErrorSendingCoupon"), object: nil)
                        }
                    }
                    
                }
        }
    }
    
    @objc func sendSignal() {
        if (couponNameField.text?.isEmpty)! || (couponCodeField.text?.isEmpty)! || (couponDurationField.text?.isEmpty)! || (couponDescriptionField.text?.isEmpty)! || (couponAmountField.text?.isEmpty)! || (couponTypeField.text?.isEmpty)! || (couponPackageField.text?.isEmpty)! || (couponStatusField.text?.isEmpty)! {
            print("sending...")
            NotificationCenter.default.post(name: Notification.Name("SendCouponError"), object: nil)
        }else{
            sendNewCoupon()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CreateCouponFooter: UICollectionViewCell {
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CREATE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    let cancelButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("CANCEL", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .darkGray
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 7
//        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(confirmButtonTapped))
        confirmButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupViews() {
        addSubview(confirmButton)
//        addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            confirmButton.heightAnchor.constraint(equalToConstant: 55),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
//            cancelButton.heightAnchor.constraint(equalToConstant: 55),
//            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            cancelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
    }
    
    @objc func closeButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("closeCreateCouponPage"), object: nil)
    }
    
    @objc func confirmButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("createCouponTapped"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension Date {
    
}
