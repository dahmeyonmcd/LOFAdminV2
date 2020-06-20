//
//  ExpandedVideoVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import VimeoNetworking
import AVKit
import Lottie

class ExpandedVideoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let topViewBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let fullScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "FullscreenBtn"), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        button.addTarget(self, action: #selector(openFullScreen), for: .touchUpInside)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    let exitFullScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeFullScreen), for: .touchUpInside)
        button.tintColor = .white
        button.setImage(UIImage(named: "FullscreenBtn"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    lazy var mainVC: EducationPageTwoVC = {
        let vc = EducationPageTwoVC()
        vc.MainController = self
        return vc
    }()
    
    let topVideoBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let topVideoBarTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let videoHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let videoHolderTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let infoHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let infoHolderTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let videoTopSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let nextVideoHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let videoTitleHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    let videoTitleHeaderOne: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    let upNextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .left
        label.text = "Next video"
        return label
    }()
    
    let videoCourseSubheading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "- views"
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.maximumTrackTintColor = .darkGray
        slider.minimumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .normal)
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .highlighted)
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .selected)
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .focused)
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .application)
        slider.isContinuous = true
        slider.maximumValue = 1
        slider.thumbImage(for: .normal)
        slider.thumbImage(for: .highlighted)
        slider.thumbImage(for: .selected)
        slider.thumbImage(for: .focused)
        slider.thumbImage(for: .application)
        slider.addTarget(self, action: #selector(handleSlider), for: .valueChanged)
        slider.value = 0
        return slider
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .white)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    let videoSliderTwo: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.maximumTrackTintColor = .darkGray
        slider.minimumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .normal)
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .highlighted)
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .selected)
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .focused)
        slider.setThumbImage(UIImage(named: "ThumbImage"), for: .application)
        slider.isContinuous = true
        slider.maximumValue = 1
        slider.thumbImage(for: .normal)
        slider.thumbImage(for: .highlighted)
        slider.thumbImage(for: .selected)
        slider.thumbImage(for: .focused)
        slider.thumbImage(for: .application)
        slider.addTarget(self, action: #selector(handleSliderTwo), for: .valueChanged)
        slider.value = 0
        return slider
    }()
    
    let videoUploaderName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    // MARK: All spacers go here
    let spacerOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.alpha = 0.6
        return view
    }()
    
    let spacerTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.alpha = 0.6
        return view
    }()
    
    let overlayTint: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    let overlayTintTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    let spacerThree: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.alpha = 0.6
        return view
    }()
    
    let uploaderImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 19
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 0.5
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.heightAnchor.constraint(equalToConstant: 38).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 38).isActive = true
        return iv
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "PauseBtn"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        return button
    }()
    
    let playButtonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "PauseBtn"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Like", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.setImage(UIImage(named: "ThumbsUp"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.imageView?.alpha = 1
        button.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
//        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let fullScreenOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dislike", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.setImage(UIImage(named: "ThumbsDown"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.imageView?.alpha = 1
        button.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
//        button.addTarget(self, action: #selector(handleDislikeButton), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let buttonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "DownloadBtn"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.imageView?.alpha = 0.4
        button.tintColor = .white
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Like"
        label.textColor = .gray
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        return label
    }()
    
    let dislikeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dislike"
        label.textColor = .gray
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        return label
    }()
    
    let downloadLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Download"
        label.textColor = .gray
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        return label
    }()
    
    let buttonThree: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DONE", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 38).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return button
    }()
    
    let videoLengthLabelOne: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return label
    }()
    
    let videoLengthLabelTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return label
    }()
    
    let fullscreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let pageOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        return view
        
    }()
    
    let lotContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    var isPlaying = Bool()
//    var didLike = Bool()
//    var didDislike = Bool()
    
    var data1 = [[String: AnyObject]]()
    var videoString = String()
    var CurrentLink = String()
    
    var SelectedID = String()
    var SelectedName = String()
    let NextVideoCellId = "nextVideoCellId"
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoTapGestureHandler))
        videoHolder.addGestureRecognizer(videoTap)
        
        let videoTapTwo = UITapGestureRecognizer(target: self, action: #selector(videoTapGestureHandlerTwo))
        fullScreenOverlay.addGestureRecognizer(videoTapTwo)
        
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        

        
        cellHolder.register(NextVideoCell.self, forCellWithReuseIdentifier: NextVideoCellId)
        

//        setupFullScreenView()
        
        isPlaying = true
//        didLike = false
//        didDislike = false
        
        setupView()
        
        startAnimations()
        
    }
    
    func startAnimations() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.play()
        animationView.loopMode = .loop
        
        view.addSubview(pageOverlay)
        pageOverlay.addSubview(lotContainer)
        lotContainer.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            pageOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            pageOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            lotContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lotContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: lotContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: lotContainer.centerYAnchor),
            ])
        
        // MARK: Launch loading function.
        DispatchQueue.main.async {
            
            // execute
            self.fetchCollectionEducationData()
            self.setupLabels()
            self.setupVimeo()
            
            //
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("LandScape")
            openFullScreen()
        }else{
            print("portrait")
            closeFullScreen()
        }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    func fadeViewsAutomatically() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.viewWatcher()
        }
    }
    
    func fadeViewsAutomaticallyFullscreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.viewWatcherFull()
        }
    }
    
    @objc func closePage() {
        dismiss(animated: true, completion: nil)
        KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
        KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
        KeychainWrapper.standard.removeObject(forKey: "selectedVideoLink")
        KeychainWrapper.standard.removeObject(forKey: "selectedVideoID")
        KeychainWrapper.standard.removeObject(forKey: "LessonId")
        KeychainWrapper.standard.removeObject(forKey: "SelectedLessonVideoURL")
        
        if player != nil {
            player.pause()
        }else{
            print("novideo playing")
        }
        
    }
    
    func holdOffFade() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.viewWatcher()
        }
    }
    
    func keepViews() {
        self.topVideoBar.alpha = 1
        self.playButton.alpha = 1
        self.overlayTint.alpha = 0.3
    }
    
    func setupLabels() {
        let courseTitle: String? = KeychainWrapper.standard.string(forKey: "selectedLessonName")
//        let courseMainTitle: String? = KeychainWrapper.standard.string(forKey: "selectedCourseName")
        let courseAuthor: String? = KeychainWrapper.standard.string(forKey: "LessonAuthor")
        videoTitleHeader.text = courseTitle
        videoTitleHeaderOne.text = courseTitle
//        videoCourseSubheading.text = courseMainTitle
        videoUploaderName.text = courseAuthor
    }
    
    @objc func handlePlayButton() {
        if isPlaying == true {
            playButton.backgroundColor = .clear
            playButton.setImage(UIImage(named: "PlayBtn"), for: .normal)
            playButtonTwo.setImage(UIImage(named: "PlayBtn"), for: .normal)
            isPlaying = false
            player.pause()
            keepViews()
        }else {
            playButton.backgroundColor = .clear
            playButton.setImage(UIImage(named: "PauseBtn"), for: .normal)
            playButtonTwo.setImage(UIImage(named: "PauseBtn"), for: .normal)
            isPlaying = true
            holdOffFade()
            player.play()
        }
    }
    
//    @objc func handleLikeButton() {
//        if didLike == true {
//            likeButton.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
//            dislikeButton.tintColor = UIColor.white
//            didLike = false
//            didDislike = true
//        }else {
//            likeButton.tintColor = UIColor.white
//            dislikeButton.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
//            didLike = true
//            didDislike = false
//        }
//    }
//
//    @objc func handleDislikeButton() {
//        if didDislike == true {
//            likeButton.tintColor = UIColor.white
//            dislikeButton.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
//            didDislike = false
//            didLike = true
//        }else {
//            likeButton.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
//            dislikeButton.tintColor = UIColor.white
//            didDislike = true
//            didLike = false
//        }
//    }
    
    func viewWatcher() {
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.topVideoBar.alpha = 0
            self.playButton.alpha = 0
            self.overlayTint.alpha = 0
             self.videoSlider.setThumbImage(UIImage(named: "ThumbImage"), for: .normal)
        }) { (_) in
            // add more code here
        }
    }
    
    func viewWatcherFull() {
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.topVideoBarTwo.alpha = 0
            self.playButtonTwo.alpha = 0
            self.overlayTintTwo.alpha = 0
            self.videoSliderTwo.alpha = 0
            self.videoSliderTwo.setThumbImage(UIImage(named: "ThumbImage"), for: .normal)
            self.videoTitleHeaderOne.alpha = 0
        }) { (_) in
            // add more code here
        }
    }
    
    @objc func handleSlider() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek)
                in
            })
        }

    }
    @objc func handleSliderTwo() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSliderTwo.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek)
                in
            })
        }
        
    }
    
    @objc func videoTapGestureHandler() {
        if topVideoBar.alpha < 1 || playButton.alpha < 1 || overlayTint.alpha < 0 {
            UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                self.topVideoBar.alpha = 1
                self.playButton.alpha = 1
                self.overlayTint.alpha = 0.3
                self.videoSlider.setThumbImage(UIImage(named: "ThumbImage"), for: .normal)
                self.fadeViewsAutomatically()
            }) { (_) in
                // add more animations here
            }
        }else{
            UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                self.topVideoBar.alpha = 0
                self.playButton.alpha = 0
                self.overlayTint.alpha = 0
                self.videoSlider.setThumbImage(UIImage(named: ""), for: .normal)
            }) { (_) in
                // add more animations here
            }
        }
    }
    
    @objc func videoTapGestureHandlerTwo() {
        if topVideoBarTwo.alpha < 1 || playButtonTwo.alpha < 1 || overlayTintTwo.alpha < 0 {
            UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                self.topVideoBarTwo.alpha = 1
                self.playButtonTwo.alpha = 1
                self.overlayTintTwo.alpha = 0.3
                self.videoSliderTwo.alpha = 1
                self.videoTitleHeaderOne.alpha = 1
                self.videoSliderTwo.setThumbImage(UIImage(named: "ThumbImage"), for: .normal)
                self.fadeViewsAutomaticallyFullscreen()
            }) { (_) in
                // add more animations here
            }
        }else{
            UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                self.topVideoBarTwo.alpha = 0
                self.playButtonTwo.alpha = 0
                self.overlayTintTwo.alpha = 0
                self.videoSliderTwo.alpha = 0
                self.videoTitleHeaderOne.alpha = 0
                self.videoSliderTwo.setThumbImage(UIImage(named: "ThumbImage"), for: .normal)
            }) { (_) in
                // add more animations here
            }
        }
    }

    
    func setupVimeo() {
        let link: String? = KeychainWrapper.standard.string(forKey: "LessonId")
        print("here is your selected vimeo id: \(link ?? "")")
        DispatchQueue.main.async {
            self.configureVimeo()
        }
    }
    
    @objc func openFullScreen() {
        enterLandscape()
        
        DispatchQueue.main.async {
            let v2 = self.fullScreenOverlay
            
            self.view.addSubview(v2)
            v2.alpha = 1

            
            v2.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            v2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            v2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            v2.alpha = 1

            self.setupFullScreenView()
            
            
            DispatchQueue.main.async {
                self.avpController.view.frame.size.height = self.videoHolderTwo.frame.size.height
                self.avpController.view.frame.size.width = self.videoHolderTwo.frame.size.width
                self.videoHolderTwo.addSubview(self.avpController.view)
                self.avpController.showsPlaybackControls = false
            }
        }
        
    }
    
    @objc func closeFullScreen() {
        let v2 = fullScreenOverlay
        exitLandscape()
        view.addSubview(v2)
        v2.removeFromSuperview()
        v2.alpha = 0
        
        DispatchQueue.main.async {
            
            self.avpController.view.frame.size.height = self.videoHolder.frame.size.height
            self.avpController.view.frame.size.width = self.videoHolder.frame.size.width

            self.videoHolder.addSubview(self.avpController.view)
            
        }
    }
    
    func configureVimeo() {
        let appConfiguration = AppConfiguration(clientIdentifier: "9ac0f2c66e6fe0f69a390ffa51309df6dddee6ff", clientSecret: "tcuyVFep0S1O83R2Q14oQqJaYIZWE0wC81556u4r/oQY6bPlb8f2Dr2GSdV6NqQqcQfDroBcyXXFwoFCHojoG65QCk7tLUi1zv8bYUd5U6i9PPDFVFJAGsCoiU+a7Pin", scopes: [.Private, .Public, .Video_Files], keychainService: "")
        let vimeoClient = VimeoClient(appConfiguration: appConfiguration)
        let videoID: String? = KeychainWrapper.standard.string(forKey: "LessonId")
        let videoRequest = VideoRequest(path: "/videos/\(videoID ?? "")")
        let authenticationController = AuthenticationController(client: vimeoClient, appConfiguration: appConfiguration)
        authenticationController.accessToken(token: "1003b27f18b70a9d680fcd68cf0595ef")
        { (result) in
            switch result
            {
            case .success(let account):
                print("authenticated Successsfully: \(account)")
                DispatchQueue.main.async {
                    vimeoClient.request(videoRequest, completion: { (result) in
                        switch result {
                        case .success(let result):
                            
                            let video: VIMVideo = result.model
                            let newModel = result.json as NSDictionary
                            let viewCount = video.numPlays as! Int
                            let viewLike = video.likesCount()
//                            let viewDislikes = video.isLiked()
                            self.likeLabel.text = String(viewLike)
//                            let likeCount = video.isLiked()
                            
                            
                            let completeJSON = newModel.value(forKey: "files") as! NSArray
                            let subJSON = completeJSON.firstObject as! NSDictionary
                            let subSubJSON = subJSON.value(forKey: "link") as! String
                            self.videoCourseSubheading.text = "\(viewCount) views"
                            let link: String? = KeychainWrapper.standard.string(forKey: "SelectedLessonVideoURL")
                            if link != nil {
                                KeychainWrapper.standard.removeObject(forKey: "SelectedLessonVideoURL")
                                DispatchQueue.main.async {
                                    KeychainWrapper.standard.set(subSubJSON, forKey: "SelectedLessonVideoURL")
                                    DispatchQueue.main.async {
                                        self.playVideo()
                                    }
                                }
                            }else{
                                KeychainWrapper.standard.removeObject(forKey: "SelectedLessonVideoURL")
                                DispatchQueue.main.async {
                                    KeychainWrapper.standard.set(subSubJSON, forKey: "SelectedLessonVideoURL")
                                    DispatchQueue.main.async {
                                        self.playVideo()
                                    }
                                }
                            }
                            print("retrieved video: \(video)")
                        case .failure(let error):
                            print("error retrieving video: \(error)")
                        }
                    })
                }
            case .failure(let error):
                print("failure authenticating")
                print(error)
            }
        }
        
        DispatchQueue.main.async {
            print("video fetched")
        }
    }
    
    func playVideo() {
        
        let newURLLink: String? = KeychainWrapper.standard.string(forKey: "SelectedLessonVideoURL")
        print("this is yout new link\(newURLLink ?? "")")
        self.animationView.stop()
        self.pageOverlay.removeFromSuperview()
        let url = URL(string: newURLLink!)
        player = AVPlayer(url: url!)
        avpController.player = player
        avpController.showsPlaybackControls = false
        
        avpController.view.frame.size.height = videoHolder.frame.size.height
        avpController.view.frame.size.width = videoHolder.frame.size.width
        self.videoHolder.addSubview(avpController.view)
        
        let interval = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime)
            in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds) % 60)
            self.videoLengthLabelOne.text = "\(secondsString)"
            self.videoLengthLabelTwo.text = "\(secondsString)"
            if let duration = self.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self.videoSlider.value = Float(seconds / durationSeconds)
                self.videoSliderTwo.value = Float(seconds / durationSeconds)
            }
            
        })
        
        self.fadeViewsAutomatically()
        self.player.play()
        
    }
    
    func setupFullScreenView() {

        fullScreenOverlay.addSubview(videoHolderTwo)
        fullScreenOverlay.addSubview(overlayTintTwo)
        fullScreenOverlay.addSubview(topVideoBarTwo)
        fullScreenOverlay.addSubview(videoSliderTwo)
        fullScreenOverlay.addSubview(videoTitleHeaderOne)
        fullScreenOverlay.addSubview(playButtonTwo)
        fullScreenOverlay.addSubview(videoLengthLabelTwo)
        topVideoBarTwo.addSubview(exitFullScreenButton)
    
        NSLayoutConstraint.activate([
            topVideoBarTwo.heightAnchor.constraint(equalToConstant: 60),
            
            videoHolderTwo.topAnchor.constraint(equalTo: fullScreenOverlay.topAnchor),
            videoHolderTwo.bottomAnchor.constraint(equalTo: fullScreenOverlay.bottomAnchor),
            videoHolderTwo.leadingAnchor.constraint(equalTo: fullScreenOverlay.leadingAnchor),
            videoHolderTwo.trailingAnchor.constraint(equalTo: fullScreenOverlay.trailingAnchor),
            
            topVideoBarTwo.leadingAnchor.constraint(equalTo: fullScreenOverlay.leadingAnchor),
            topVideoBarTwo.trailingAnchor.constraint(equalTo: fullScreenOverlay.trailingAnchor),
            topVideoBarTwo.topAnchor.constraint(equalTo: fullScreenOverlay.safeAreaLayoutGuide.topAnchor),
            
            videoSliderTwo.bottomAnchor.constraint(equalTo: fullScreenOverlay.safeAreaLayoutGuide.bottomAnchor),
            videoSliderTwo.leadingAnchor.constraint(equalTo: fullScreenOverlay.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            videoSliderTwo.trailingAnchor.constraint(equalTo: fullScreenOverlay.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            exitFullScreenButton.topAnchor.constraint(equalTo: topVideoBarTwo.topAnchor, constant: 20),
            exitFullScreenButton.bottomAnchor.constraint(equalTo: topVideoBarTwo.bottomAnchor),
            exitFullScreenButton.trailingAnchor.constraint(equalTo: topVideoBarTwo.trailingAnchor, constant: -20),
            exitFullScreenButton.widthAnchor.constraint(equalTo: exitFullScreenButton.heightAnchor),
            
            videoTitleHeaderOne.leadingAnchor.constraint(equalTo: fullScreenOverlay.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            videoTitleHeaderOne.topAnchor.constraint(equalTo: fullScreenOverlay.safeAreaLayoutGuide.topAnchor, constant: 20),
            videoTitleHeaderOne.trailingAnchor.constraint(equalTo: exitFullScreenButton.leadingAnchor, constant: -40),
            
            playButtonTwo.heightAnchor.constraint(equalToConstant: 80),
            playButtonTwo.widthAnchor.constraint(equalToConstant: 80),
            playButtonTwo.centerXAnchor.constraint(equalTo: fullScreenOverlay.centerXAnchor),
            playButtonTwo.centerYAnchor.constraint(equalTo: fullScreenOverlay.centerYAnchor),
            
            overlayTintTwo.topAnchor.constraint(equalTo: fullScreenOverlay.topAnchor),
            overlayTintTwo.bottomAnchor.constraint(equalTo: fullScreenOverlay.bottomAnchor),
            overlayTintTwo.leadingAnchor.constraint(equalTo: fullScreenOverlay.leadingAnchor),
            overlayTintTwo.trailingAnchor.constraint(equalTo: fullScreenOverlay.trailingAnchor),
            
            videoLengthLabelTwo.leadingAnchor.constraint(equalTo: fullScreenOverlay.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            videoLengthLabelTwo.bottomAnchor.constraint(equalTo: videoSliderTwo.topAnchor, constant: -20)
            ])
    }
    
    func fadeFullscreenViews() {
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            print(change!)
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = Int(seconds) / 60
                
                videoLengthLabelOne.text = "\(minutesText):\(secondsText)"
                videoLengthLabelTwo.text = "\(minutesText):\(secondsText)"
                
            }
        }
    }
    
    func enterLandscape() {
        let orientationValue = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(orientationValue, forKey: "orientation")
    }
    
    func exitLandscape() {
        let orientationValue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationValue, forKey: "orientation")
    }
    
    func fetchCollectionEducationData() {
        let myUrl = URL(string: "http://api.lionsofforex.com/education/list_lessons")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let selectedCourseId: String? = KeychainWrapper.standard.string(forKey: "selectedCourse")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        
        let postString = ["course": selectedCourseId, "email": accessText] as! [String: String]
        // send http request to perform sign in
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    //                    print(jsondata)
                    if let da = jsondata["success"].arrayObject {
                        self.data1 = da as! [[String : AnyObject]]
                        
                    }
                    if self.data1.count > 0 {
                        self.cellHolder.reloadData()
                    }
                }
                
        }
    }
    
    func setupView() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(videoTitleHeader)
        stackViewOne.addArrangedSubview(videoCourseSubheading)
        stackViewOne.axis = .vertical
        stackViewOne.spacing = 5
        stackViewOne.distribution = .equalSpacing
        
        let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.addArrangedSubview(stackViewOne)
        containerStackView.spacing = 20
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.alignment = .center


        view.addSubview(topViewBackground)
        view.addSubview(videoTopSpacer)
        view.addSubview(infoHolder)
        infoHolder.addSubview(spacerOne)
        infoHolderTwo.addSubview(spacerTwo)
        view.addSubview(cellHolder)
        view.addSubview(nextVideoHolder)
        nextVideoHolder.addSubview(upNextLabel)
        
        infoHolder.addSubview(likeButton)
        infoHolder.addSubview(dislikeButton)
        infoHolder.addSubview(buttonTwo)
        infoHolder.addSubview(buttonThree)
//        infoHolder.addSubview(stackViewTwo)
//        infoHolder.addSubview(likeButton)
//        infoHolder.addSubview(dislikeButton)
        
        infoHolderTwo.addSubview(uploaderImage)
        infoHolderTwo.addSubview(videoUploaderName)
        
        view.addSubview(infoHolderTwo)
        topViewBackground.addSubview(videoHolder)
        topViewBackground.addSubview(overlayTint)
        topViewBackground.addSubview(topVideoBar)
        
        topVideoBar.addSubview(fullScreenButton)
//        topVideoBar.addSubview(closeButton)
        
        infoHolder.addSubview(stackViewOne)
        infoHolder.addSubview(likeLabel)
        infoHolder.addSubview(dislikeLabel)
        infoHolder.addSubview(downloadLabel)
        topViewBackground.addSubview(playButton)
        topViewBackground.addSubview(videoSlider)
        topViewBackground.addSubview(videoLengthLabelOne)
        
        
        NSLayoutConstraint.activate([
            
            topViewBackground.heightAnchor.constraint(equalToConstant: 250),
            topViewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topViewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topViewBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            videoTopSpacer.topAnchor.constraint(equalTo: view.topAnchor),
            videoTopSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            videoTopSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoTopSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            videoHolder.topAnchor.constraint(equalTo: topViewBackground.topAnchor),
            videoHolder.bottomAnchor.constraint(equalTo: topViewBackground.bottomAnchor),
            videoHolder.leadingAnchor.constraint(equalTo: topViewBackground.leadingAnchor),
            videoHolder.trailingAnchor.constraint(equalTo: topViewBackground.trailingAnchor),
            
            overlayTint.topAnchor.constraint(equalTo: topViewBackground.topAnchor),
            overlayTint.bottomAnchor.constraint(equalTo: topViewBackground.bottomAnchor),
            overlayTint.leadingAnchor.constraint(equalTo: topViewBackground.leadingAnchor),
            overlayTint.trailingAnchor.constraint(equalTo: topViewBackground.trailingAnchor),
            
            topVideoBar.heightAnchor.constraint(equalToConstant: 40),
            topVideoBar.leadingAnchor.constraint(equalTo: topViewBackground.leadingAnchor),
            topVideoBar.trailingAnchor.constraint(equalTo: topViewBackground.trailingAnchor),
            topVideoBar.topAnchor.constraint(equalTo: topViewBackground.topAnchor),
            
            playButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.widthAnchor.constraint(equalToConstant: 80),
            playButton.centerXAnchor.constraint(equalTo: topViewBackground.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: topViewBackground.centerYAnchor),
            
            stackViewOne.topAnchor.constraint(equalTo: infoHolder.topAnchor, constant: 15),
//            stackViewOne.bottomAnchor.constraint(equalTo: topVideoBar.bottomAnchor, constant: -20),
            stackViewOne.leadingAnchor.constraint(equalTo: infoHolder.leadingAnchor, constant: 20),
            stackViewOne.trailingAnchor.constraint(equalTo: infoHolder.trailingAnchor, constant: -20),
            
            infoHolder.topAnchor.constraint(equalTo: topViewBackground.bottomAnchor),
            infoHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoHolder.heightAnchor.constraint(equalToConstant: 135),
            
            likeButton.topAnchor.constraint(equalTo: stackViewOne.bottomAnchor, constant: 5),
            likeButton.leadingAnchor.constraint(equalTo: infoHolder.leadingAnchor, constant: 20),
            
            dislikeButton.topAnchor.constraint(equalTo: stackViewOne.bottomAnchor, constant: 5),
            dislikeButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            
            buttonTwo.topAnchor.constraint(equalTo: stackViewOne.bottomAnchor, constant: 5),
            buttonTwo.leadingAnchor.constraint(equalTo: dislikeButton.trailingAnchor, constant: 30),
            
            buttonThree.topAnchor.constraint(equalTo: stackViewOne.bottomAnchor, constant: 15),
            buttonThree.trailingAnchor.constraint(equalTo: infoHolder.trailingAnchor, constant: -20),
            
            infoHolderTwo.topAnchor.constraint(equalTo: infoHolder.bottomAnchor),
            infoHolderTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoHolderTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoHolderTwo.heightAnchor.constraint(equalToConstant: 55),
            
            cellHolder.topAnchor.constraint(equalTo: nextVideoHolder.bottomAnchor, constant: 0.5),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            uploaderImage.leadingAnchor.constraint(equalTo: infoHolderTwo.leadingAnchor, constant: 20),
            uploaderImage.centerYAnchor.constraint(equalTo: infoHolderTwo.centerYAnchor),
            
            videoUploaderName.centerYAnchor.constraint(equalTo: infoHolderTwo.centerYAnchor),
            videoUploaderName.leadingAnchor.constraint(equalTo: uploaderImage.trailingAnchor, constant: 8),
            videoUploaderName.trailingAnchor.constraint(equalTo: infoHolderTwo.trailingAnchor, constant: -20),
            
            spacerOne.bottomAnchor.constraint(equalTo: infoHolder.bottomAnchor),
            spacerOne.leadingAnchor.constraint(equalTo: infoHolder.leadingAnchor, constant: 0),
            spacerOne.trailingAnchor.constraint(equalTo: infoHolder.trailingAnchor, constant: 0),
            
            spacerTwo.bottomAnchor.constraint(equalTo: infoHolderTwo.bottomAnchor),
            spacerTwo.leadingAnchor.constraint(equalTo: infoHolderTwo.leadingAnchor, constant: 0),
            spacerTwo.trailingAnchor.constraint(equalTo: infoHolderTwo.trailingAnchor, constant: 0),
            
            nextVideoHolder.heightAnchor.constraint(equalToConstant: 45),
            nextVideoHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextVideoHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextVideoHolder.topAnchor.constraint(equalTo: infoHolderTwo.bottomAnchor),
            
//            spacerThree.bottomAnchor.constraint(equalTo: nextVideoHolder.bottomAnchor),
//            spacerThree.leadingAnchor.constraint(equalTo: nextVideoHolder.leadingAnchor, constant: 0),
//            spacerThree.trailingAnchor.constraint(equalTo: nextVideoHolder.trailingAnchor, constant: 0),
            
            upNextLabel.centerYAnchor.constraint(equalTo: nextVideoHolder.centerYAnchor),
            upNextLabel.leadingAnchor.constraint(equalTo: nextVideoHolder.leadingAnchor, constant: 20),
            upNextLabel.widthAnchor.constraint(equalToConstant: 110),
            
            videoSlider.leadingAnchor.constraint(equalTo: topViewBackground.leadingAnchor),
            videoSlider.trailingAnchor.constraint(equalTo: topViewBackground.trailingAnchor),
            videoSlider.bottomAnchor.constraint(equalTo: topViewBackground.bottomAnchor, constant: 10),
            
            fullScreenButton.topAnchor.constraint(equalTo: topVideoBar.topAnchor),
            fullScreenButton.bottomAnchor.constraint(equalTo: topVideoBar.bottomAnchor),
            fullScreenButton.trailingAnchor.constraint(equalTo: topVideoBar.trailingAnchor),
            fullScreenButton.widthAnchor.constraint(equalTo: fullScreenButton.heightAnchor),
            
//            closeButton.topAnchor.constraint(equalTo: topVideoBar.topAnchor),
//            closeButton.bottomAnchor.constraint(equalTo: topVideoBar.bottomAnchor),
//            closeButton.leadingAnchor.constraint(equalTo: topVideoBar.leadingAnchor),
//            closeButton.widthAnchor.constraint(equalTo: fullScreenButton.heightAnchor),
            
            likeLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            likeLabel.topAnchor.constraint(equalTo: likeButton.topAnchor, constant: 50),
            
            dislikeLabel.centerXAnchor.constraint(equalTo: dislikeButton.centerXAnchor),
            dislikeLabel.topAnchor.constraint(equalTo: dislikeButton.topAnchor, constant: 50),
            
            downloadLabel.centerXAnchor.constraint(equalTo: buttonTwo.centerXAnchor),
            downloadLabel.topAnchor.constraint(equalTo: buttonTwo.topAnchor, constant: 50),
            
            videoLengthLabelOne.leadingAnchor.constraint(equalTo: topViewBackground.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            videoLengthLabelOne.bottomAnchor.constraint(equalTo: videoSlider.topAnchor, constant: -20)
            
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data1.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NextVideoCellId, for: indexPath) as! NextVideoCell
        let iP = data1[indexPath.row]
        cell.videoTitleHeader.text = iP["name"] as? String
        
        
        if iP["author"] as? String == nil || iP["author"] as? String == "" {
            cell.videoSubtitle.text = "Berto Delvanicci"
        }else{
            cell.videoSubtitle.text = iP["author"] as? String
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removeAllThings()
        DispatchQueue.main.async {
            let selectedId = (self.data1[indexPath.row] as NSDictionary).object(forKey: "video") as? String
            let selectedIdName = (self.data1[indexPath.row] as NSDictionary).object(forKey: "name") as? String
            let selectedIdAuthor = (self.data1[indexPath.row] as NSDictionary).object(forKey: "author") as? String
            let selectedKeychainId: String? = KeychainWrapper.standard.string(forKey: "LessonId")
            
            if selectedIdAuthor == nil {
                KeychainWrapper.standard.set("Berto Delvanicci", forKey: "LessonAuthor")
                
            }else if selectedIdAuthor == "" {
                KeychainWrapper.standard.set("Berto Delvanicci", forKey: "LessonAuthor")
                
            }else {
                KeychainWrapper.standard.set(selectedIdAuthor!, forKey: "LessonAuthor")
            }
            
            if selectedKeychainId != nil {
                KeychainWrapper.standard.removeObject(forKey: "LessonId")
                KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
                DispatchQueue.main.async {
                    KeychainWrapper.standard.set(selectedId!, forKey: "LessonId")
                    KeychainWrapper.standard.set(selectedIdName!, forKey: "selectedLessonName")
                    DispatchQueue.main.async {
                        self.configureVimeo()
                        self.setupLabels()
                    }
                }
                
            }else{
                KeychainWrapper.standard.removeObject(forKey: "LessonId")
                KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
                DispatchQueue.main.async {
                    KeychainWrapper.standard.set(selectedId!, forKey: "LessonId")
                    KeychainWrapper.standard.set(selectedIdName!, forKey: "selectedLessonName")
                    DispatchQueue.main.async {
                        self.configureVimeo()
                        self.setupLabels()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func removeAllThings() {
        KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
        KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
        KeychainWrapper.standard.removeObject(forKey: "selectedVideoLink")
        KeychainWrapper.standard.removeObject(forKey: "selectedVideoID")
        KeychainWrapper.standard.removeObject(forKey: "LessonId")
        KeychainWrapper.standard.removeObject(forKey: "SelectedLessonVideoURL")
        KeychainWrapper.standard.removeObject(forKey: "LessonAuthor")
        player.pause()
        CurrentLink.removeAll()
        videoString.removeAll()
        SelectedID.removeAll()
        SelectedName.removeAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
        KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
        KeychainWrapper.standard.removeObject(forKey: "selectedVideoLink")
        KeychainWrapper.standard.removeObject(forKey: "selectedVideoID")
        KeychainWrapper.standard.removeObject(forKey: "LessonId")
        KeychainWrapper.standard.removeObject(forKey: "SelectedLessonVideoURL")
        KeychainWrapper.standard.removeObject(forKey: "LessonAuthor")
        
        if player != nil {
            player.pause()
        }else{
            print("no video playing")
        }
        
        isPlaying = false
        CurrentLink.removeAll()
        videoString.removeAll()
        SelectedID.removeAll()
        SelectedName.removeAll()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    

    
}
