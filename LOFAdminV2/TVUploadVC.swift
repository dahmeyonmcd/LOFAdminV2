//
//  TVUploadVC.swift
//  Mentorship App Admin
//
//  Created by UnoEast on 1/2/20.
//  Copyright © 2020 MiamiLabsTechnologies. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Lottie
import Photos
import AVFoundation

class TVUploadVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .vertical
        cv.backgroundColor = UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    let menuBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        // Shadow MARK *******
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 1, height: 4)
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    let pageOverLay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let textColor = UIColor.white
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.imageEdgeInsets = .init(top: 10, left: 15, bottom: 10, right: 15)
        button.addTarget(self, action: #selector(goBackTapped), for: .touchUpInside)
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.widthAnchor.constraint(equalToConstant: 45).isActive = true
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageView?.clipsToBounds = true
        button.tintColor = .red
        button.isHidden = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Poppins-Bold", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(1)
        label.text = "LOFTV Upload"
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    let loadingOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let progressOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.8
        return view
    }()
    
    let loadingHolder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 55).isActive = true
        view.widthAnchor.constraint(lessThanOrEqualToConstant: 55).isActive = true
        view.layer.cornerRadius = 9
        return view
    }()
    
    let percentLabel: UILabel = {
        let label = UILabel()
        let string = "0% Complete"
        label.text = string
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold) // 19
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    let promptLabel: UILabel = {
        let label = UILabel()
        let string = "Please stay on this page until upload is complete"
        label.text = string
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold) // 19
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "Cancel Upload"
        let textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        return button
    }()
    
    let animationView = AnimationView(name: "colorLoading")
    let progressView = AnimationView(name: "progress")
    
    var topAnchor: NSLayoutConstraint!
    
    var videoURL = String()
    
    var videoTask: StorageUploadTask!
    
    fileprivate let cellId = "UploadPageCellId"
    
    let imagePickerController = UIImagePickerController()
    
    var doneURL = NSURL()
    var doneAsset = PHAsset()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(UploadCell.self, forCellWithReuseIdentifier: cellId)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(openVideos), name: Notification.Name("OpenVideoTapped"), object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(continueTapped(_:)), name: Notification.Name("UploadContinueTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseIt), name: Notification.Name("AppEnteringBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeIt), name: Notification.Name("AppResumed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelTapped), name: Notification.Name("AppTerminated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(continueTapped(_:)), name: Notification.Name("CONTINUEMMTVUPLOADTAPPED"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(exitTapped), name: Notification.Name("EXITMMTVUPLOADTAPPED"), object: nil)
        
        
        setupViews()
    }
    
    @objc func exitTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pauseIt() {
        if videoTask != nil {
            videoTask.pause()
        }else{
            
        }
    }
    
    @objc func resumeIt() {
        if videoTask != nil {
            videoTask.resume()
            
            videoTask.observe(.progress) { (snapshot) in
                if let fraction = snapshot.progress?.fractionCompleted {
                    let progress = CGFloat(fraction)
                    let percentValue = ((progress * 100) * 10).rounded() / 10
                    let max = self.loadingOverlay.frame.height
                    self.topAnchor.constant = max * progress
                    self.progressOverlay.layoutIfNeeded()
                    self.percentLabel.text = "\(percentValue)% Complete"
                }
                
            }
        }else{
            
        }
        
    }
    
    @objc func cancelTapped() {
        self.stopLoading()
        if videoTask != nil {
            videoTask.cancel()
        }else{
            
        }
    }
    
    func startProgress() {
        loadingHolder.removeFromSuperview()
        
        view.addSubview(loadingOverlay)
        loadingOverlay.addSubview(progressOverlay)
        loadingOverlay.addSubview(percentLabel)
        loadingOverlay.addSubview(promptLabel)
        loadingOverlay.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressOverlay.leadingAnchor.constraint(equalTo: loadingOverlay.leadingAnchor, constant:0),
            progressOverlay.trailingAnchor.constraint(equalTo: loadingOverlay.trailingAnchor, constant: 0),
            progressOverlay.bottomAnchor.constraint(equalTo: loadingOverlay.bottomAnchor, constant: 0),
            
            percentLabel.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: loadingOverlay.leadingAnchor, constant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: loadingOverlay.trailingAnchor, constant: -30),
            cancelButton.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 20),
            
            promptLabel.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            promptLabel.bottomAnchor.constraint(equalTo: percentLabel.topAnchor, constant: -30),
            ])
        
        topAnchor = progressOverlay.topAnchor.constraint(equalTo: loadingOverlay.topAnchor, constant: -loadingOverlay.frame.height)
        topAnchor.isActive = true
        
    }
    
    func stopLoading() {
        self.loadingOverlay.removeFromSuperview()
        
    }
    
    private func setupViews() {
        view.addSubview(cellHolder)
        view.addSubview(menuBar)
        view.addSubview(menuTop)
        menuBar.addSubview(titleLabel)
        menuBar.addSubview(backButton)
        menuBar.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor, constant: 0),
            
            backButton.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 3),
            backButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor, constant: 0),
            
            infoButton.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -10),
            infoButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor, constant: 5),
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UploadCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    @objc func goBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openVideos() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func startLoading() {
        percentLabel.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        view.addSubview(loadingOverlay)
        loadingOverlay.addSubview(loadingHolder)
        loadingHolder.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingHolder.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            loadingHolder.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor),
            
            animationView.topAnchor.constraint(equalTo: loadingHolder.topAnchor, constant: 5),
            animationView.leadingAnchor.constraint(equalTo: loadingHolder.leadingAnchor, constant: 5),
            animationView.trailingAnchor.constraint(equalTo: loadingHolder.trailingAnchor, constant: -5),
            animationView.bottomAnchor.constraint(equalTo: loadingHolder.bottomAnchor, constant: -5),
            
            ])
        
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play()
        
    }
    
    @objc func deleteIt() {
        
        let uuid = UUID().uuidString
        
        let poststring = "\(uuid).mp4"
        
        let storageRef = Storage.storage().reference().child(poststring)
        
        storageRef.child(poststring).delete { (error) in
            if let error = error {
                print("ERROR DELETING OLD")
                print(error.localizedDescription)
            }else{
                print("DELETED OLD")
            }

        }
    }
    
    @objc func continueTapped(_ notification: Notification) {
        if let title = notification.userInfo?["title"] as? String {
            if let description = notification.userInfo?["description"] as? String {
                if doneURL.absoluteString != nil {
                    // SET LETS BEGIN
                    startProgress()
                    if let data = NSData(contentsOf: doneURL as URL) {
                        print("Filesize before compression: \(Double(data.length / 1048576)) mb")
                        guard let uid = UserDefaults.standard.string(forKey: "TokenID") else { return }
                        
                        let uuid = UUID().uuidString
                        
                        let poststring = "\(title).mp4"
                        
                        let storageRef = Storage.storage().reference().child(poststring)
                        
                        let uploadTask = storageRef.putData(data as Data, metadata: nil) { (storemeta, error) in
                            if let error = error {
                                self.stopLoading()
                                print(error.localizedDescription)
                                self.alert(message: error.localizedDescription, title: "Alert")
                            }else{
                                if let storemeta = storemeta {
                                    print(storemeta.description)
                                    storageRef.downloadURL(completion: { (url, urlError) in
                                        if let urlError = urlError {
                                            self.stopLoading()
                                            print(urlError.localizedDescription)
                                            self.alert(message: urlError.localizedDescription, title: "Alert")
                                        }else{
                                            if let url = url {
                                                print(url.absoluteString)
                                                // SET URL
                                                
                                                self.videoURL = url.absoluteString
                                                
                                                let sent = Int(Date().timeIntervalSince1970)
                                                
                                                let innerpoststr2 = ["id": uuid, "title": title, "date": String(sent), "description": description, "type": "for you", "uploader": uid, "url": self.videoURL]
                                                
                                                Firestore.firestore().collection("igtv").document(uuid).setData(innerpoststr2, merge: true, completion: { (ier) in
                                                    if let ier = ier {
                                                        // EROR
                                                        print(ier.localizedDescription)
                                                        self.stopLoading()
                                                        self.alert(message: ier.localizedDescription, title: "Alert")
                                                    }else{
                                                        // SUCCESS STOP LOADING
                                                        print("SUCCESSFULLY UPLOADED")
                                                        self.alert(message: "Successfully uploaded video", title: "Success")
                                                        NotificationCenter.default.post(name: Notification.Name("VideoUploadedSUCCESS"), object: nil)
                                                        self.stopLoading()
                                                    }
                                                })
                                            }
                                        }
                                    })
                                }
                            }
                        }
                        
                        // set task
                        videoTask = uploadTask
                        
                        videoTask.resume()
                        
                        videoTask.observe(.progress) { (snapshot) in
                            if let fraction = snapshot.progress?.fractionCompleted {
                                let progress = CGFloat(fraction)
                                let percentValue = ((progress * 100) * 10).rounded() / 10
                                let max = self.loadingOverlay.frame.height
                                self.topAnchor.constant = max * progress
                                self.progressOverlay.layoutIfNeeded()
                                self.percentLabel.text = "\(percentValue)% Complete"
                            }
                            
                        }
                        
                    }
                }else{
                    // ERROR
                     self.alert(message: "No video was selected", title: "Alert")
                }
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoURL = info[.mediaURL] as? URL {
            
            self.doneURL = videoURL as NSURL
            
            imagePickerController.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: Notification.Name("VideoUploaded"), object: nil)
            
        }else{
            print("DONE PICKING BUT WITH ERROR")
            
            if let videoURL = info[UIImagePickerController.InfoKey.init(rawValue: "UIImagePickerControllerReferenceURL")] as? URL {
                print(videoURL)
                
                self.doneURL = videoURL as NSURL
                if let data = NSData(contentsOf: videoURL) {
                    print(data.description)
                }else{
                    print("error before compressing")
                    print("forced this url: \(info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")] as! URL)")
                    
                    let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")] as! URL], options: nil)
                    
                    if let phAsset = fetchResult.firstObject {
                        PHImageManager.default().requestPlayerItem(forVideo: phAsset, options: nil) { (videoData, info) in
                            if let videoData = videoData {
                                guard let url = videoData.asset.dictionaryWithValues(forKeys: ["URL"]).values.first as? URL else { return }
                                self.doneURL = url as NSURL
                                
                            }
                        }
                    }
                }
                
                imagePickerController.dismiss(animated: true, completion: nil)
                
                NotificationCenter.default.post(name: Notification.Name("VideoUploaded"), object: nil)
                
            }
        }
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true, completion: nil)
    }
    
}

class UploadCell: UICollectionViewCell {
    
    let holderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 180).isActive = true
//        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.layer.cornerRadius = 5
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        let string = "Click to select video from your library"
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        let characterSpacing: CGFloat = 0.5
        paragraphStyle.lineSpacing = 0
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length - 1))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let nameTextField: TextFieldVC = {
        let tf = TextFieldVC()
        let attrPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 60).isActive = true
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.tintColor = .black
        tf.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        tf.attributedPlaceholder = attrPlaceholder
        tf.layer.borderWidth = 0 // 1
        tf.textColor = .black
        return tf
    }()
    
    let descriptionTextField: TextFieldVC = {
        let tf = TextFieldVC()
        let attrPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 60).isActive = true
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.tintColor = .black
        tf.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        tf.attributedPlaceholder = attrPlaceholder
        tf.layer.borderWidth = 0 // 1
        tf.textColor = .black
        return tf
    }()
    
    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "Continue"
        let textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 97/255, green: 115/255, blue: 252/255, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 12
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.imageView?.clipsToBounds = true
        button.layer.shadowColor = UIColor.blue.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 1, height: 4)
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    let cameraImage: UIImageView = {
        let image = UIImage(named: "camera")
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return iv
    }()
    
    var success = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(selectVideo))
        holderView.addGestureRecognizer(selectGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
        
        let continueGesture = UITapGestureRecognizer(target: self, action: #selector(continueTapped))
        continueButton.addGestureRecognizer(continueGesture)
        
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoSelected), name: Notification.Name("VideoUploaded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(successChange), name: Notification.Name("VideoUploadedSUCCESS"), object: nil)
    }
    
    @objc func videoSelected() {
        holderView.backgroundColor = .black
        cameraImage.image = UIImage(named: "done")
    }
    
    @objc func successChange() {
        self.continueButton.setTitle("Upload Complete", for: .normal)
        self.continueButton.backgroundColor = .green
        self.success = true
    }
    
    @objc func selectVideo() {
        print("OPENING VIDEO")
        NotificationCenter.default.post(name: Notification.Name("OpenVideoTapped"), object: nil)
    }
    
    @objc func continueTapped() {
        if success == false {
            print("CONTINUE TAPPED")
            if nameTextField.text!.isEmpty {
                
            }else{
                // SUCCEDD
                guard let title = nameTextField.text else { return }
                let desc = descriptionTextField.text
                let userInfo = ["title": title, "description": desc ?? ""]
                NotificationCenter.default.post(name: Notification.Name("CONTINUEMMTVUPLOADTAPPED"), object: nil, userInfo: userInfo)
            }
        }else{
            NotificationCenter.default.post(name: Notification.Name("EXITMMTVUPLOADTAPPED"), object: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(holderView)
        holderView.addSubview(cameraImage)
        addSubview(nameTextField)
        addSubview(descriptionTextField)
        addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            holderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            holderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            holderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            cameraImage.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),
            cameraImage.centerYAnchor.constraint(equalTo: holderView.centerYAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: holderView.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            descriptionTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            continueButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 30),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
