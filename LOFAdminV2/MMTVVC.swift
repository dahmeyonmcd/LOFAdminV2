//
//  MMTVVC.swift
//  Mentorship App Admin
//
//  Created by UnoEast on 12/19/19.
//  Copyright © 2019 MiamiLabsTechnologies. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Lottie
import AVKit
import Kingfisher

struct mmtvVideo {
    var id: String
    var uploader: String
    var name: String
    var description: String
    var date: String
    var time: String
    var type: String
}

let imageCache = NSCache<AnyObject, AnyObject>()
let senderCache = NSCache<AnyObject, AnyObject>()
let resoursesCache = NSCache<AnyObject, AnyObject>()
let completedCache = NSCache<AnyObject, AnyObject>()

class MMTVVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let topHolder: UIView = {
        let view = UIView()
        let color = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.heightAnchor.constraint(equalToConstant: 65).isActive = true
        // Shadow MARK *******
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.15
        view.layer.cornerRadius = 0
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Poppins-Bold", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(1)
        label.text = "LOFtv"
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .vertical
        return cv
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
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        let textColor = UIColor.white
        button.setImage(UIImage(named: "addIcon"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(addNewQuote), for: .touchUpInside)
        return button
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 246/255,green: 246/255,blue: 252/255,alpha: 0.88)
        return view
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Poppins-Medium", size: 11)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Fetching course info please wait..."
        label.numberOfLines = 1
        return label
    }()
    
    let animationView = AnimationView(name: "loading")
    
    fileprivate let cellId = "MMTVIndividualCell"
    
    var videos = [mmtvVideo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 246/255,green: 246/255,blue: 252/255,alpha: 1)
        
        setupViews()
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(TVIndividualCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchVideos()
        
    }
    
    @objc func fetchVideos() {
        self.startLoading()
        self.videos.removeAll()
        Firestore.firestore().collection("igtv").getDocuments { (snapshot, error) in
            if let error = error {
                self.stopLoading()
                print(error.localizedDescription)
            }else{
                if let snapshot = snapshot {
                    if snapshot.documents.count == 0 {
                        self.cellHolder.reloadData()
                        self.stopLoading()
                    }else{
                        for doc in snapshot.documents {
                            let value = doc.data()
                            if let vId = value["id"] as? String {
                                if let name = value["title"] as? String {
                                    if let date = value["date"] as? String {
                                        if let desc = value["description"] as? String {
                                            if let uploader = value["uploader"] as? String {
                                                print("FOUND A FOR YOU VIDEO")
                                                if let type = value["type"] as? String {
                                                    if let time = value["time"] as? String {
                                                        print("FOUND A FOR YOU VIDEO")
                                                        let newVideo = mmtvVideo(id: vId, uploader: uploader, name: name, description: desc, date: date, time: time, type: type)
                                                        self.videos.append(newVideo)
                                                    }else{
                                                        print("FOUND A FOR YOU VIDEO")
                                                        let newVideo = mmtvVideo(id: vId, uploader: uploader, name: name, description: desc, date: date, time: "", type: type)
                                                        self.videos.append(newVideo)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        if self.videos.count > 0 {
                            let filtered = self.videos.filterDuplicates({$0.id == $1.id})
                            let sorted = filtered.sorted(by: {$0.date > $1.date})
                            
                            self.videos = sorted
                            
                            self.cellHolder.reloadData()
                            self.stopLoading()
                        }else{
                            self.cellHolder.reloadData()
                            self.stopLoading()
                        }
                    }
                    
                }
            }
        }
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func addNewQuote() {
        print("ADDING NEW QUOTE")
        if let navigationController = navigationController {
            let vc = TVUploadVC()
            navigationController.pushViewController(vc, animated: true)
        }else{
            
        }
    }
    
    private func setupViews() {
        view.addSubview(cellHolder)
        view.addSubview(topHolder)
        topHolder.addSubview(backButton)
        topHolder.addSubview(addButton)
        topHolder.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            topHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: topHolder.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: topHolder.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            addButton.centerYAnchor.constraint(equalTo: topHolder.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            titleLabel.centerYAnchor.constraint(equalTo: topHolder.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: topHolder.centerXAnchor),
            
        ])
    }
    
    func heightForText(text: String,Font: UIFont,Width: CGFloat) -> CGFloat{

        let constrainedSize = CGSize.init(width:Width, height: CGFloat(MAXFLOAT))

        let attributesDictionary = NSDictionary.init(object: Font, forKey:NSAttributedString.Key.font as NSCopying)

        let mutablestring = NSAttributedString.init(string: text, attributes: attributesDictionary as? [NSAttributedString.Key : Any])

        var requiredHeight = mutablestring.boundingRect(with:constrainedSize, options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), context: nil)

        if requiredHeight.size.width > Width {
            requiredHeight = CGRect.init(x: 0, y: 0, width: Width, height: requiredHeight.height)

        }
        return requiredHeight.size.height;
    }
    
    @objc func showAlert(id: String, type: String) {
        let alert = UIAlertController(title: nil, message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Play Video", style: .default , handler:{ (UIAlertAction) in
            print("User click play video button")
            self.playVideo(id: id)
        }))
        
        if type == "for you" {
            alert.addAction(UIAlertAction(title: "Add to Popular", style: .default, handler:{ (UIAlertAction) in
                print("User click Popular button")
                self.addToPopular(id: id)
            }))
        }else{
            alert.addAction(UIAlertAction(title: "Remove from Popular", style: .destructive, handler:{ (UIAlertAction) in
                print("User click remove Popular button")
                self.removeFromPopular(id: id)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Generate Thumbnail", style: .default, handler:{ (UIAlertAction) in
            print("User click generate button")
            self.fetchInfo(id: id)
        }))
        
        alert.addAction(UIAlertAction(title: "Edit Video", style: .default , handler:{ (UIAlertAction) in
            print("User click Edit button")
        }))
        
        alert.addAction(UIAlertAction(title: "Delete Video", style: .destructive , handler:{ (UIAlertAction) in
            print("User click Delete button")
            self.deleteVideo(id: id)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))
        
        
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func startLoading() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 65).isActive = true
        animationView.backgroundColor = .clear
        
        let stackViewTwo: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(animationView)
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.spacing = -5
            sv.axis = .vertical
            sv.alignment = .center
            return sv
        }()
        
        view.addSubview(overlayView)
        overlayView.addSubview(stackViewTwo)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackViewTwo.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            stackViewTwo.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
        ])
        
        animationView.play()
    }
        
    @objc func stopLoading() {
        overlayView.removeFromSuperview()
    }
    
    func addToPopular(id: String) {
        self.startLoading()
        let poststr = ["type": "popular"]
        Firestore.firestore().collection("igtv").document(id).setData(poststr, merge: true) { (error) in
            if error == nil {
                self.fetchVideos()
                self.alert(message: "Successfully added video to popular", title: "Alert")
            }else{
                // FAILED
                self.stopLoading()
                self.alert(message: "Failed to add video to popular", title: "Alert")
            }
        }
    }
    
    func removeFromPopular(id: String) {
        self.startLoading()
        let poststr = ["type": "for you"]
        Firestore.firestore().collection("igtv").document(id).setData(poststr, merge: true) { (error) in
            if error == nil {
                self.fetchVideos()
                self.alert(message: "Successfully removed video from popular", title: "Alert")
            }else{
                // FAILED
                self.stopLoading()
                self.alert(message: "Failed to remove video from popular", title: "Alert")
            }
        }
    }
    
    func fetchInfo(id: String) {
        self.startLoading()
        Firestore.firestore().collection("igtv").document(id).getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if let value = snapshot.data() {
                    if let videoURLSTR = value["url"] as? String {
                        if let videoURL = URL(string: videoURLSTR) {
                            if let image = self.previewImageForLocalVideo(url: videoURL) {
                                
                                let storageRef = Storage.storage().reference()
                                let uuid = UUID().uuidString
                                // Local file you want to upload
                                
                                guard let data = image.jpegData(compressionQuality: 0.6) else { return }
                                
                                let fileRef = storageRef.child("thumbnails/\(uuid).jpg")

                                // Create the file metadata
                                let metadata = StorageMetadata()
                                metadata.contentType = "\(uuid)/jpeg"
                                let uploadTask = fileRef.putData(data, metadata: metadata)

                                uploadTask.observe(.resume) { snapshot in
                                  // Upload resumed, also fires when the upload starts
                                }

                                uploadTask.observe(.pause) { snapshot in
                                  // Upload paused
                                }

                                uploadTask.observe(.progress) { snapshot in
                                    // Upload reported progress
                                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                                     print("\(Int(percentComplete))%")
                                }

                                uploadTask.observe(.success) { snapshot in
                                    // Upload completed successfully
                                    fileRef.downloadURL { (url, error) in
                                        if let error = error {
                                            self.stopLoading()
                                            print(error.localizedDescription)
                                            self.alert(message: "Error fetching download url from firebase", title: "Alert")
                                        }else{
                                            if let url = url {
                                                print(url)
                                                let poststr = ["photo": url.absoluteString]
                                                Firestore.firestore().collection("igtv").document(id).setData(poststr, merge: true) { (err) in
                                                    if let err = err {
                                                        print(err.localizedDescription)
                                                        self.stopLoading()
                                                        print("profile image upload failed")
                                                        self.alert(message: "Error uploading thumbnail photo", title: "Alert")
                                                    }else{
                                                        // SUCCESS
                                                        self.fetchVideos()
                                                        self.alert(message: "Thumbnail successfully generated", title: "Alert")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }else{
                                // FAILED
                                self.stopLoading()
                                self.alert(message: "Error fetching thumbnail photo", title: "Alert")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func previewImageForLocalVideo(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        var time = asset.duration
        //If possible - take not the first frame (it could be completely black or white on camara's videos)
        time.value = min(time.value, 2) // 2

        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            self.stopLoading()
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    func deleteVideo(id: String) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this video?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
            Firestore.firestore().collection("igtv").document(id).delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    // SUCCESS
                    self.fetchVideos()
                }
            }
        }
        alertController.addAction(OKAction)
        alertController.addAction(yesAction)
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func playVideo(id: String) {
        Firestore.firestore().collection("igtv").document(id).getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if let value = snapshot.data() {
                    if let path = value["url"] as? String {
                        if let url = URL(string: path) {
                            let player = AVPlayer(url: url)
                            let vc = AVPlayerViewController()
                            vc.player = player

                            self.present(vc, animated: true) {
                                vc.player?.play()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if videos.count > 0 {
            return videos.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TVIndividualCell
        if videos.count > 0 {
            let iP = videos[indexPath.row]
            cell.titleLabel.text = iP.name
            cell.descriptionLabel.text = iP.description
            
            Firestore.firestore().collection("members").document(iP.uploader).getDocument { (snapshot, error) in
                if let snapshot = snapshot {
                    if let value = snapshot.data() {
                        if let name = value["name"] as? String {
                            cell.uploaderLabel.text = name
                        }
                    }
                }
            }
            
            if let imageFromCache = imageCache.object(forKey: iP.id as AnyObject) as? UIImage {
                cell.imageView.image = imageFromCache
            }else{
                Firestore.firestore().collection("igtv").document(iP.id).getDocument { (snapshot, error) in
                    if let snapshot = snapshot {
                        if let value = snapshot.data() {
                            if let photo = value["photo"] as? String {
                                if let innerURL = URL(string: photo) {
                                    KingfisherManager.shared.retrieveImage(with: innerURL) { result in
                                        // Do something with `result`
                                        if let image = try? result.get() {
                                            let innerImage = image.image as UIImage
                                            imageCache.setObject(innerImage, forKey: iP.id as AnyObject)
                                            cell.imageView.image = image.image
                                        }
                                    }
                                }
                            }else{
                                cell.imageView.image = UIImage(named: "placeholderImage")
                            }
                        }
                    }
                }
            }
            
            if iP.type == "popular" {
                cell.popularLabel.isHidden = false
            }else{
                cell.popularLabel.isHidden = true
            }
            
            cell.uploadedLabel.text = iP.date
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if videos.count > 0 {
            let iP = videos[indexPath.row]
            self.showAlert(id: iP.id, type: iP.type)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 30, left: 0, bottom: 0, right: 0)
    }
}

class TVIndividualCell: UICollectionViewCell {
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white//UIColor.init(red: 97/255, green: 115/255, blue: 252/255, alpha: 1)//.white
        view.layer.cornerRadius = 15
        // Shadow MARK *******
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 1, height: 4)
        view.layer.shadowOpacity = 0.15
        return view
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.text = ""
        label.numberOfLines = 2
        return label
    }()
    
    let popularLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textAlignment = .right
        label.textColor = .red
        label.text = "Popular"
        label.numberOfLines = 1
        label.heightAnchor.constraint(equalToConstant: 15).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.isHidden = true
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.text = ""
        label.numberOfLines = 2
        return label
    }()
    
    let uploaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.text = ""
        label.numberOfLines = 1
        return label
    }()
    
    let uploadedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.text = "uploaded"
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupViews()
    }
    
    private func setupViews() {
        let stackViewOne: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(titleLabel)
            sv.addArrangedSubview(descriptionLabel)
            sv.addArrangedSubview(uploaderLabel)
            sv.addArrangedSubview(uploadedLabel)
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.spacing = 5
            sv.axis = .vertical
            sv.alignment = .fill
            return sv
        }()
        
        let stackViewTwo: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(imageView)
            sv.addArrangedSubview(stackViewOne)
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.spacing = 10
            sv.axis = .horizontal
            sv.alignment = .leading
            return sv
        }()
        
        addSubview(view)
        view.addSubview(stackViewTwo)
        view.addSubview(popularLabel)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            
            stackViewTwo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            
            popularLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            popularLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Array {

    func filterDuplicates(_ includeElement: (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()

        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }

        return results
    }
}
