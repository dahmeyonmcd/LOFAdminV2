//
//  lofTVVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import SwiftyJSON
import FirebaseFirestore
import Kingfisher

struct lofVideo {
    var id: String
    var uploader: String
    var name: String
    var description: String
    var date: String
    var time: String
}

class lofTVVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let sliderView: UISlider = {
        let slider = UISlider()
        slider.backgroundColor = .clear
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        slider.translatesAutoresizingMaskIntoConstraints = false
//        slider.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        slider.setThumbImage(UIImage(named: "trackImage"), for: .normal)
        slider.minimumValue = 0
        return slider
    }()
    
    let slideUpMenu: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 395).isActive = true
        return view
    }()
    
    let closeHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return view
    }()
    
    let topGestureHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let menuTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return view
    }()
    
    let menuSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alpha = 0.3
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        layout.sectionHeadersPinToVisibleBounds = true
        cv.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        return cv
    }()
    
    let categorieHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        layout.sectionHeadersPinToVisibleBounds = true
        cv.showsVerticalScrollIndicator = false
        layout.scrollDirection = .horizontal
        return cv
    }()
    
    let videoHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        return view
    }()
    
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(named: "Comment_Icon"), for: .normal)
        button.setTitle("", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(named: "igtv_search"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 57).isActive = true
        button.widthAnchor.constraint(equalToConstant: 57).isActive = true
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.setImage(UIImage(named: "Comment_Icon"), for: .normal)
        button.setImage(UIImage(named: "igtv_settings"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.tintColor = .white
        button.backgroundColor = .clear
//        button.tintColor = .white
        button.addTarget(self, action: #selector(handleCommentButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 57).isActive = true
        button.widthAnchor.constraint(equalToConstant: 57).isActive = true
        return button
    }()
    
    let midImage: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "igtv_down")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = image
        iv.tintColor = .white
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        return iv
    }()
    
    let downButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.setImage(UIImage(named: "Comment_Icon"), for: .normal)
//        button.setImage(UIImage(named: "igtv_down"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handleBrowseButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 57).isActive = true
        return button
    }()
    
    
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 9
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let botttomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topGradient: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TopGradient")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.75
        return imageView
    }()
    
    let bottomGradient: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BottomGradient")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.75
        return imageView
    }()
    
    let uploaderImage: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "bertoprofile")
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Play_Button"), for: .normal)
        button.setImage(UIImage(named: "Pause_Icon"), for: .selected)
        button.setTitle("", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    let browseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ""), for: .normal)
        button.setTitle("Browse", for: .normal)
        let color = UIColor.white.cgColor
        button.layer.borderColor = color
        button.layer.borderWidth = 1.2
        button.backgroundColor = .clear
        button.layer.cornerRadius = 6
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleBrowseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Like_Button"), for: .normal)
        button.setImage(UIImage(named: "didLike_Button"), for: .selected)
        button.setImage(UIImage(named: "didLike_Button"), for: .highlighted)
        button.setTitle("", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.addTarget(self, action: #selector(tapNewVideoLike), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Comment_Icon"), for: .normal)
        button.setTitle("", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleCommentButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Share_Icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleShareButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Close_Icon"), for: .normal)
        button.setTitle("", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleCloseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let viewsCommentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "0:00"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.contentMode = .center
        return label
    }()
    
    let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "---"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    let uploaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = ""
        label.textColor = .white
        label.contentMode = .center
//        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.alpha = 1
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "0 views"
        label.textColor = .white
        label.contentMode = .center
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.alpha = 0.7
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.text = "---"
        label.textColor = .white
        label.contentMode = .center
//        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.alpha = 1
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .white)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return av
    }()
    
    var isPlaying = false
    var didLike = false
    var isOpen = true
    var isVisible = false
    var selectedVideo = String()
    var selectedVideoURL = String()
    var selectedVideoName = String()
    var selectedVideoUploader = String()
    var selectedVideoDate = String()
    var selectedVideoViews = String()
    
    let menuArray = ["For You", "Popular"]
    
    let cellId = "lofTvCellId"
    let cellIdOne = "lofTvCellIdOne"
    
    var lofVideos = [lofVideo]()
    var popularVideos = [lofVideo]()
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var avPlayerLayer = AVPlayerLayer()
    var timeObserver: Any?
    var timer: Timer?
    
    var selection = String()
    
    let videoLink = "BackgroundVideo"
    let videoURL: NSURL = Bundle.main.url(forResource: "static", withExtension: ".mp4")! as NSURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        avpController.showsPlaybackControls = false
        
        view.backgroundColor = .black
        animateMain()
        
        selection = "For You"
        
        setupLayout()
        isPlaying = true
        
        cellHolder.register(LOFTvCell.self, forCellWithReuseIdentifier: cellId)
        categorieHolder.register(LOFCategoryCell.self, forCellWithReuseIdentifier: cellIdOne)
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        
        categorieHolder.dataSource = self
        categorieHolder.delegate = self
        
        activityIndicator.center = self.videoView.center
        activityIndicator.hidesWhenStopped = true
        
        closeButton.isUserInteractionEnabled = true
        closeButton.layer.zPosition = 100
        
        setupMenu()
        
        view.addSubview(closeHolder)
        closeHolder.addSubview(closeButton)
        
        let constraints = [
            closeHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            closeHolder.heightAnchor.constraint(equalToConstant: 50),
            closeHolder.widthAnchor.constraint(equalToConstant: 50),
            closeHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            closeButton.trailingAnchor.constraint(equalTo: closeHolder.trailingAnchor),
            closeButton.leadingAnchor.constraint(equalTo: closeHolder.leadingAnchor),
            closeButton.topAnchor.constraint(equalTo: closeHolder.topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: closeHolder.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapIt))
        tapGesture.numberOfTapsRequired = 1
        videoView.addGestureRecognizer(tapGesture)
        
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseButtonTapped))
        closeGesture.numberOfTapsRequired = 1
        closeButton.addGestureRecognizer(closeGesture)
        
        let tapFade = UITapGestureRecognizer(target: self, action: #selector(handleTapFade))
        tapFade.numberOfTapsRequired = 1
        videoView.addGestureRecognizer(tapFade)
        
//        let outsideGesture = UITapGestureRecognizer(target: self, action: #selector(outsideTap))
//        view.addGestureRecognizer(outsideGesture)
        
//        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubletap))
//        doubleTapGesture.numberOfTapsRequired = 2
//        videoView.addGestureRecognizer(doubleTapGesture)
        
        fetchInfo()
        
        let indexPath = IndexPath(item: 0, section: 0)
        categorieHolder.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        setupGestures()
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopVideo), name: Notification.Name("STOPVIDEO"), object: nil)
        
        
        
    }
    
    @objc func stopVideo() {
        player.pause()
        avPlayerLayer.removeFromSuperlayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopVideo()
    }
    
    func setupGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleCloseButtonTapped))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outsideTap))
        
        topGestureHolder.addGestureRecognizer(tapGesture)
    }
    
    func setupStatic() {
        player = AVPlayer(url: videoURL as URL)
//        playAudioMix()
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        avPlayerLayer = playerLayer
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayerLayer.zPosition = -1
        avPlayerLayer.frame = view.frame
        player?.pause()
        avPlayerLayer.removeFromSuperlayer()
        videoView.layer.addSublayer(avPlayerLayer)
        player?.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    func setupMenu() {
        view.addSubview(slideUpMenu)
        view.addSubview(topGestureHolder)
        
        slideUpMenu.addSubview(menuTopView)
        slideUpMenu.addSubview(cellHolder)
        slideUpMenu.addSubview(categorieHolder)

        menuTopView.addSubview(searchButton)
        menuTopView.addSubview(menuSpacer)
        menuTopView.addSubview(settingsButton)
        menuTopView.addSubview(downButton)
        downButton.addSubview(midImage)
        
        NSLayoutConstraint.activate([
            slideUpMenu.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            slideUpMenu.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            slideUpMenu.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            topGestureHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topGestureHolder.bottomAnchor.constraint(equalTo: slideUpMenu.topAnchor),
            topGestureHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topGestureHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            menuTopView.topAnchor.constraint(equalTo: slideUpMenu.topAnchor),
            menuTopView.leadingAnchor.constraint(equalTo: slideUpMenu.leadingAnchor),
            menuTopView.trailingAnchor.constraint(equalTo: slideUpMenu.trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: menuTopView.bottomAnchor, constant: 10),
            cellHolder.leadingAnchor.constraint(equalTo: slideUpMenu.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: slideUpMenu.trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: slideUpMenu.bottomAnchor, constant: -10),
            
            searchButton.topAnchor.constraint(equalTo: menuTopView.topAnchor, constant: 0),
            searchButton.leadingAnchor.constraint(equalTo: menuTopView.leadingAnchor, constant: 5),
            
            settingsButton.topAnchor.constraint(equalTo: menuTopView.topAnchor, constant: 0),
            settingsButton.trailingAnchor.constraint(equalTo: menuTopView.trailingAnchor, constant: -5),
            
            downButton.topAnchor.constraint(equalTo: menuTopView.topAnchor, constant: 0),
            downButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -5),
            downButton.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 5),
            
            categorieHolder.topAnchor.constraint(equalTo: downButton.bottomAnchor, constant: 2),
            categorieHolder.leadingAnchor.constraint(equalTo: menuTopView.leadingAnchor),
            categorieHolder.trailingAnchor.constraint(equalTo: menuTopView.trailingAnchor),
            categorieHolder.bottomAnchor.constraint(equalTo: menuTopView.bottomAnchor),
            
            menuSpacer.bottomAnchor.constraint(equalTo: menuTopView.bottomAnchor),
            menuSpacer.leadingAnchor.constraint(equalTo: menuTopView.leadingAnchor),
            menuSpacer.trailingAnchor.constraint(equalTo: menuTopView.trailingAnchor),
            
            midImage.centerYAnchor.constraint(equalTo: downButton.centerYAnchor),
            midImage.centerXAnchor.constraint(equalTo: downButton.centerXAnchor)
            ])
        
        self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: 0)
        self.topGestureHolder.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    private func setupLayout() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(uploaderLabel)
        stackViewOne.addArrangedSubview(dateLabel)
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.alignment = .leading
//        stackViewOne.distribution = .equalSpacing
        stackViewOne.spacing = 2
        stackViewOne.axis = .vertical
        
        let stackViewTwo = UIStackView()
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        stackViewTwo.addArrangedSubview(likeButton)
        stackViewTwo.addArrangedSubview(commentButton)
        stackViewTwo.addArrangedSubview(shareButton)
        stackViewTwo.axis = .horizontal
        stackViewTwo.spacing = -2
        stackViewTwo.alignment = .leading
        
        let stackViewThree = UIStackView()
        stackViewThree.translatesAutoresizingMaskIntoConstraints = false
        stackViewThree.addArrangedSubview(uploaderImage)
        stackViewThree.addArrangedSubview(stackViewOne)
        stackViewThree.axis = .horizontal
        stackViewThree.spacing = 10
        stackViewThree.alignment = .leading
        
        
        view.addSubview(videoView)
        videoView.addSubview(videoHolder)
        
        view.addSubview(topView)
        view.addSubview(botttomView)
        topView.addSubview(topGradient)
        botttomView.addSubview(bottomGradient)
        topView.addSubview(videoTitleLabel)
        topView.addSubview(stackViewThree)
        
        
//        topView.addSubview(closeButton)
//        topView.addSubview(uploaderImage)
        botttomView.addSubview(playButton)
        botttomView.addSubview(sliderView)
        botttomView.addSubview(stackViewTwo)
//        botttomView.addSubview(viewsCommentsLabel)
        botttomView.addSubview(browseButton)
        botttomView.addSubview(timeLabel)
        botttomView.addSubview(viewsLabel)
        
        // setup constraints here
        NSLayoutConstraint.activate([
            
            
            videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            videoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            videoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            videoHolder.topAnchor.constraint(equalTo: videoView.topAnchor),
            videoHolder.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -7),
//            videoHolder.bottomAnchor.constraint(equalTo: videoView.bottomAnchor),
            videoHolder.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
            videoHolder.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
            
            topView.topAnchor.constraint(equalTo: videoView.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 120),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topGradient.topAnchor.constraint(equalTo: topView.topAnchor),
            topGradient.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            topGradient.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            topGradient.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            videoTitleLabel.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 20),
            videoTitleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            videoTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            
            botttomView.bottomAnchor.constraint(equalTo: videoView.bottomAnchor),
            botttomView.heightAnchor.constraint(equalToConstant: 100),
            botttomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            botttomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomGradient.topAnchor.constraint(equalTo: botttomView.topAnchor),
            bottomGradient.bottomAnchor.constraint(equalTo: botttomView.bottomAnchor),
            bottomGradient.leadingAnchor.constraint(equalTo: botttomView.leadingAnchor),
            bottomGradient.trailingAnchor.constraint(equalTo: botttomView.trailingAnchor),
            
            browseButton.heightAnchor.constraint(equalToConstant: 35),
            browseButton.widthAnchor.constraint(equalToConstant: 90),
            
            playButton.bottomAnchor.constraint(equalTo: botttomView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            playButton.leadingAnchor.constraint(equalTo: botttomView.leadingAnchor, constant: 5),
            
            stackViewTwo.centerYAnchor.constraint(equalTo: browseButton.centerYAnchor, constant: 0),
            stackViewTwo.leadingAnchor.constraint(equalTo: botttomView.leadingAnchor, constant: 5),
            
            sliderView.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 2),
            
            timeLabel.heightAnchor.constraint(equalToConstant: 40),
            timeLabel.widthAnchor.constraint(equalToConstant: 55),
            timeLabel.trailingAnchor.constraint(equalTo: botttomView.trailingAnchor, constant: -5),
            timeLabel.bottomAnchor.constraint(equalTo: botttomView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            sliderView.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -2),
            sliderView.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
//            sliderView.heightAnchor.constraint(equalToConstant: 50),
            
            browseButton.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -25),
            browseButton.trailingAnchor.constraint(equalTo: botttomView.trailingAnchor, constant: -15),
            
            viewsLabel.leadingAnchor.constraint(equalTo: stackViewTwo.leadingAnchor, constant: 11),
            viewsLabel.bottomAnchor.constraint(equalTo: stackViewTwo.topAnchor, constant: 0),

            stackViewThree.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: 15),
            stackViewThree.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            ])
        
        avpController.view.frame.size.height = videoHolder.frame.size.height
        avpController.view.frame.size.width = videoHolder.frame.size.width
        self.videoHolder.addSubview(avpController.view)
        
        self.topView.alpha = 0
        self.botttomView.alpha = 0
        
        setupStaticFunc()
        
    }
    
    func startStatic() {
        player = AVPlayer(url: videoURL as URL)
        avpController.player = player
        avpController.videoGravity = .resizeAspectFill
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        player?.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    func setupStaticFunc() {
        if selectedVideoURL == "" {
            player = AVPlayer(url: videoURL as URL)
            avpController.player = player
            avpController.videoGravity = .resizeAspectFill
            player?.actionAtItemEnd = .none
            player?.isMuted = true
            player?.play()
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
            }
        }else{
            
        }
    }
    
    func animateMain() {
        view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//        view.transform = CGAffineTransform(translationX: 400, y: 400)
        UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
//            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (_) in
            print("animation complete")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cellHolder {
            if selection == "For You" {
                if lofVideos.count > 0 {
                    return lofVideos.count
                }else{
                    return 0
                }
            }else{
                if popularVideos.count > 0 {
                    return popularVideos.count
                }else{
                    return 0
                }
            }
        }else{
            return menuArray.count
        }
    }
    

    func preSelectRow() {
//        if selection == "For You" {
//            if lofVideos.count > 0 {
//                // select the first vidwo
//                let section = cellHolder.numberOfSections - 1
//                let indexPath = IndexPath(item: 0, section: section)
//                cellHolder.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//                DispatchQueue.main.async {
//                    if self.selectedVideoName == "" {
//                        print("no video selected for prefetch")
//                    }else{
//                        print("successfully fetched 1 video for prefetch")
//                        self.newVideoTapped()
//                        self.startVideoFetch()
//                    }
//
//                }
//            }else{
//                print("cannot autoselect video")
//            }
//        }else{
//            if popularVideos.count > 0 {
//                // select the first vidwo
//                let section = cellHolder.numberOfSections - 1
//                let indexPath = IndexPath(item: 0, section: section)
//                cellHolder.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//                DispatchQueue.main.async {
//                    if self.selectedVideoName == "" {
//                        print("no video selected for prefetch")
//                    }else{
//                        print("successfully fetched 1 video for prefetch")
//                        self.newVideoTapped()
//                        self.startVideoFetch()
//                    }
//
//                }
//            }else{
//                print("cannot autoselect video")
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cellHolder {
            if selection == "For You" {
                let iP = lofVideos[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LOFTvCell
            
                cell.titleLabel.text = iP.name
                
                // SETS TIME HERE
                if iP.time == "" {
                    cell.timeLabel.isHidden = true
                    cell.timeLabel.text = iP.time
                }else{
                    cell.timeLabel.isHidden = false
                    cell.timeLabel.text = iP.time
                }
                
                if let imageFromCache = imageCache.object(forKey: iP.uploader as AnyObject) as? UIImage {
                    cell.profileImage.image = imageFromCache
                }else{
                    Firestore.firestore().collection("members").document(iP.uploader).getDocument { (snapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else{
                            if let snapshot = snapshot {
                                if let value = snapshot.data() {
                                    if let name = value["name"] as? String {
                                        cell.usernameLabel.text = name
                                        if let photo = value["photo"] as? String {
                                            if let photoURL = URL(string: photo) {
                                                KingfisherManager.shared.retrieveImage(with: photoURL) { result in
                                                    // Do something with `result`
                                                    if let image = try? result.get() {
                                                        let innerImage = image.image as UIImage
                                                        imageCache.setObject(innerImage, forKey: iP.uploader as AnyObject)
                                                        cell.profileImage.image = image.image
                                                    }
                                                }
                                            }
                                        }else{
                                            let innerImage = UIImage(named: "blankUser")
                                            imageCache.setObject(innerImage!, forKey: iP.uploader as AnyObject)
                                            cell.imageView.image = UIImage(named: "blankUser")
                                        }
                                    }
                                }
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
                                    let innerImage = UIImage(named: "placeholderImage")
                                    imageCache.setObject(innerImage!, forKey: iP.id as AnyObject)
                                    cell.imageView.image = UIImage(named: "placeholderImage")
                                }
                            }
                        }
                    }
                }
                
                return cell
            }else{
                let iP = popularVideos[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LOFTvCell
            
                cell.titleLabel.text = iP.name
            
                // SETS TIME HERE
                if iP.time == "" {
                    cell.timeLabel.isHidden = true
                    cell.timeLabel.text = iP.time
                }else{
                    cell.timeLabel.isHidden = false
                    cell.timeLabel.text = iP.time
                }
                
                if let imageFromCache = imageCache.object(forKey: iP.uploader as AnyObject) as? UIImage {
                    cell.profileImage.image = imageFromCache
                }else{
                    Firestore.firestore().collection("members").document(iP.uploader).getDocument { (snapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else{
                            if let snapshot = snapshot {
                                if let value = snapshot.data() {
                                    if let name = value["name"] as? String {
                                        cell.usernameLabel.text = name
                                        if let photo = value["photo"] as? String {
                                            if let photoURL = URL(string: photo) {
                                                KingfisherManager.shared.retrieveImage(with: photoURL) { result in
                                                    // Do something with `result`
                                                    if let image = try? result.get() {
                                                        let innerImage = image.image as UIImage
                                                        imageCache.setObject(innerImage, forKey: iP.uploader as AnyObject)
                                                        cell.profileImage.image = image.image
                                                    }
                                                }
                                            }
                                        }else{
                                            let innerImage = UIImage(named: "blankUser")
                                            imageCache.setObject(innerImage!, forKey: iP.uploader as AnyObject)
                                            cell.imageView.image = UIImage(named: "blankUser")
                                        }
                                    }
                                }
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
                                    let innerImage = UIImage(named: "placeholderImage")
                                    imageCache.setObject(innerImage!, forKey: iP.id as AnyObject)
                                    cell.imageView.image = UIImage(named: "placeholderImage")
                                }
                            }
                        }
                    }
                }
                
                return cell
            }
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOne, for: indexPath) as! LOFCategoryCell
            cell.titleLabel.text = menuArray[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cellHolder {
            return CGSize(width: 170, height: cellHolder.frame.height)
        }else{
            return CGSize(width: 80, height: categorieHolder.frame.height)
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
//        let cell = collectionView.cellForItem(at: indexPath) as! LOFTvCell
//        if cell.isSelected {
//
//        }else{
//
//        }
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cellHolder {
            return 5
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        if collectionView == cellHolder {
            if selection == "For You" {
                let iP = lofVideos[indexPath.row]
                let cell = collectionView.cellForItem(at: indexPath) as! LOFTvCell
                generator.impactOccurred()
                
                // SETS VIDEO
                selectedVideoName = iP.name
                selectedVideo = iP.id
                selectedVideoDate = iP.date
                
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                        }, completion: { (_) in
                            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                            }, completion: { (_) in
                                // Selected video
                            })
                        })
                    })
                    
                }
                cellHolder.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
                startVideoFetch()
            }else{
                let iP = popularVideos[indexPath.row]
                let cell = collectionView.cellForItem(at: indexPath) as! LOFTvCell
                generator.impactOccurred()
                
                // SETS VIDEO
                selectedVideoName = iP.name
                selectedVideo = iP.id
                selectedVideoDate = iP.date
                
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                        }, completion: { (_) in
                            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                            }, completion: { (_) in
                                // Selected video
                            })
                        })
                    })
                    
                }
                cellHolder.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
                startVideoFetch()
            }
        }else{
            categorieHolder.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
            if indexPath.row == 0 {
                print("For you selected")
                forYouSelected()
            }else if indexPath.row == 1 {
                print("Following selected")
                popularSelected()
            }else if indexPath.row == 2 {
                print("Popular selected")
            }else if indexPath.row == 3 {
                print("History selected")
            }else{
                print("For you selected")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    @objc func forYouSelected() {
        if selection != "For You" {
            self.selection = "For You"
            // fetch all
            self.fetchInfo()
        }else{
            // DO NOTHING
            
        }
    }
    
    @objc func popularSelected() {
        if selection != "Popular" {
            self.selection = "Popular"
            self.fetchInfo()
        }else{
            // DO NOTHING
        }
    }
    
    func handlePause() {
        if isPlaying {
            //            player.pause()
            playButton.setImage(UIImage(named: "vidPlaybtn"), for: .normal)
        } else {
            //            player.play()
            playButton.setImage(UIImage(named: "vidPause"), for: .normal)
        }


        isPlaying = !isPlaying
    }
    
    @objc func handlePlayButtonTapped() {
        if isPlaying {
            player.pause()
            playButton.setImage(UIImage(named: "Pause_Icon"), for: .normal)
        } else {
            player.play()
            playButton.setImage(UIImage(named: "Play_Button"), for: .normal)
        }
        
        
        isPlaying = !isPlaying
        
    }
    
    @objc func handlePlay() {
        if isPlaying {
//            player.pause()
            playButton.setImage(UIImage(named: "Pause_Icon"), for: .normal)
        } else {
//            player.play()
            playButton.setImage(UIImage(named: "Play_Button"), for: .normal)
        }
        
        
//        isPlaying = !isPlaying
        
    }
    
    @objc func handleDoubletap() {
        if isOpen == true {
            
        }else{
            print("liked this video")
            tapNewVideoLike()
        }
    }
    
    @objc func startTimer() {
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(lofTVVC.tapReader), userInfo: nil, repeats: false)
    }
    
    @objc func tapReader() {
        handleTapFade()
    }
    
    @objc func handleLikeTapped() {
        if selectedVideoURL == "" {
            
        }else{
            tapNewVideoLike()
        }
    }
    
    @objc func startVideoFetch() {
        if selectedVideo == "" {
            print("no video url set")
        }else{
            // MARK: start indicator
            self.videoTitleLabel.text = selectedVideoName
//            self.viewsLabel.text = selectedVideoViews
            if let timeInterval = TimeInterval(selectedVideoDate) {
                
                let date = Date.init(timeIntervalSince1970: timeInterval)
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                dateFormatter.timeZone = .current
                dateFormatter.dateFormat = "MMM dd"
                
                let localDate = dateFormatter.string(from: date)
                self.dateLabel.text = localDate
                
            }
            
            Firestore.firestore().collection("members").document(selectedVideoUploader).getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    if let snapshot = snapshot {
                        if let value = snapshot.data() {
                            if let name = value["name"] as? String {
                                self.uploaderLabel.text = name
                                if let photo = value ["photo"] as? String {
                                    if let photoURL = URL(string: photo) {
                                        self.uploaderImage.kf.setImage(with: photoURL, placeholder: UIImage(named: "blankUser"))
                                    }
                                }else{
                                    self.uploaderImage.image = UIImage(named: "blankUser")
                                }
                            }
                        }
                    }
                }
            }
            
            fetchVideo()
            print("starting video fetch")
        }
    }
    
    @objc func handleTapFade() {
        if selectedVideoURL == "" {
            print("DONT DO ANYTHING")
        }else{
            if isOpen == false {
                if isVisible == true {
                    self.topView.alpha = 1
                    self.botttomView.alpha = 1
                    UIView.animate(withDuration: 0.5, delay: 0.3, animations: {
                        self.topView.alpha = 0
                        self.botttomView.alpha = 0
                    }) { (_) in
                        // mark
                        self.isVisible = false
                    }
                }else{
                    //                self.topView.alpha = 0
                    //                self.botttomView.alpha = 0
                    UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
                        self.topView.alpha = 1
                        self.botttomView.alpha = 1
                    }) { (_) in
                        // mark
                        self.isVisible = true
                        self.startTimer()
                    }
                }
            }else{
                print("view not available")
            }
        }
    }
    
//    @objc func handleTapFade() {
//        if selectedVideoURL == "" {
//            print("DONT DO ANYTHING")
//        }else{
//            if player.timeControlStatus == .paused {
//                print("DONT DO ANYTHING")
//
//            }else{
//                if isOpen == false {
//                    if isVisible == true {
//                        self.topView.alpha = 1
//                        self.botttomView.alpha = 1
//                        UIView.animate(withDuration: 0.5, delay: 0.3, animations: {
//                            self.topView.alpha = 0
//                            self.botttomView.alpha = 0
//                        }) { (_) in
//                            // mark
//                            self.isVisible = false
//                        }
//                    }else{
//                        //                self.topView.alpha = 0
//                        //                self.botttomView.alpha = 0
//                        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
//                            self.topView.alpha = 1
//                            self.botttomView.alpha = 1
//                        }) { (_) in
//                            // mark
//                            self.isVisible = true
//                            self.startTimer()
//                        }
//                    }
//                }else{
//                    print("view not available")
//                }
//            }
//        }
//    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handleShareButtonTapped() {
        
    }
    
    @objc func handleCommentButtonTapped() {
        
    }
    
    @objc func handleCloseButtonTapped() {
        print("pause button tapped")
        if player.timeControlStatus == .playing {
            player.pause()
            stopVideo()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }else if player.timeControlStatus == .paused {
            stopVideo()
            dismiss(animated: true, completion: nil)
        }else{
            player.pause()
            stopVideo()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func outsideTap() {
        if isOpen == false {
            print("view already closed")
             self.setupGestures()
        }else{
            self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: 460)
                self.botttomView.alpha = 1
                self.topView.alpha = 1
                self.isOpen = false
            }) { (_) in
                // Mark start
                
                self.setupGestures()
                self.startTimer()
            }
        }
    }
    
    @objc func handleBrowseButtonTapped() {
        if isOpen == false {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.topGestureHolder.transform = CGAffineTransform(translationX: 0, y: 0)
                self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: 0)
                self.botttomView.alpha = 0
                self.topView.alpha = 0
            }) { (_) in
                // Mark start
                self.isOpen = true
                 self.setupGestures()
            }
        }else{
            self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            self.topGestureHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: 460)
                self.topGestureHolder.transform = CGAffineTransform(translationX: 0, y: 3000)
                self.botttomView.alpha = 1
                self.topView.alpha = 1
            }) { (_) in
                // Mark start
                self.isOpen = false
                self.startTimer()
                 self.setupGestures()
            }
        }
    }
    
    @objc func tapIt() {
        if isOpen == false {
            
        }else{
            self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            self.topGestureHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            self.botttomView.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: 460)
                self.topGestureHolder.transform = CGAffineTransform(translationX: 0, y: 3000)
                self.botttomView.alpha = 1
                self.topView.alpha = 1
            }) { (_) in
                // Mark start
                self.isOpen = false
                self.startTimer()
            }
        }
    }
    
    @objc func handleTappedMenu() {
        
    }
    
    @objc func tapNewVideoLike() {
        print("liking this videooooooooo")
        // MARK SELECT VIDEO ID
        if selectedVideo == "" {
            
        }else{
            guard let user = UserDefaults.standard.string(forKey: "TokenID") else { return }
            let postLike = ["likes": FieldValue.arrayUnion([user])]
            let removeLike = ["likes": FieldValue.arrayRemove([user])]
            Firestore.firestore().collection("igtv").document(selectedVideo).getDocument { (snap, err) in
                if let err = err {
                    print(err.localizedDescription)
                }else{
                    if let snap = snap {
                        if let value = snap.data() {
                            if let likes = value["likes"] as? [String] {
                                if likes.contains(user) {
                                    // UNLIKE
                                    Firestore.firestore().collection("igtv").document(self.selectedVideo).setData(removeLike, merge: true) { (error) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        }else{
                                            // SUCCESS
                                            self.didLike = false
                                            self.likeButton.setImage(UIImage(named: "Like_Button"), for: .normal)
                                        }
                                    }
                                }else{
                                    //LIKE
                                    Firestore.firestore().collection("igtv").document(self.selectedVideo).setData(postLike, merge: true) { (error) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        }else{
                                            // SUCCESS
                                            self.didLike = true
                                            self.likeButton.setImage(UIImage(named: "didLike_Button"), for: .normal)
                                        }
                                    }
                                }
                            }else{
                                //LIKE
                                Firestore.firestore().collection("igtv").document(self.selectedVideo).setData(postLike, merge: true) { (error) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }else{
                                        // SUCCESS
                                        self.didLike = true
                                        self.likeButton.setImage(UIImage(named: "didLike_Button"), for: .normal)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func newVideoTapped() {
        print("selecting new video")
//        startStatic()
        // MARK SELECT VIDEO ID
        if selectedVideo == "" {
            
        }else{
            // MARK start animating the indicator
            startStatic()
            // LOGIC HERE
            guard let user = UserDefaults.standard.string(forKey: "TokenID") else { return }
            
            let postview = ["views": FieldValue.arrayUnion([UUID().uuidString])]
            
            Firestore.firestore().collection("igtv").document(selectedVideo).getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    if let snapshot = snapshot {
                        if let value = snapshot.data() {
                            if let vidURL = value["url"] as? String {
                                if let likes = value["likes"] as? [String] {
                                    if likes.contains(user) {
                                        // USER LIKED THIS
                                        self.didLike = true
                                        self.likeButton.setImage(UIImage(named: "didLike_Button"), for: .normal)
                                    }else{
                                        // USER DIDNT
                                        self.didLike = false
                                        self.likeButton.setImage(UIImage(named: "Like_Button"), for: .normal)
                                    }
                                }
                                
                                if let views = value["views"] as? [String] {
                                    self.viewsLabel.text = "\(views.count) views"
                                }else{
                                    self.viewsLabel.text = "0 views"
                                }
                                
                                Firestore.firestore().collection("igtv").document(self.selectedVideo).setData(postview, merge: true) { (err) in
                                    if let err = err {
                                        print(err.localizedDescription)
                                    }else{
                                        // SUCCESS
                                        self.selectedVideoURL = vidURL
                                        self.playVideo()
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func playVideo() {
        //MARK PLAY VIDEO
        let newURLLink = selectedVideoURL
        print("this is yout new link\(newURLLink)")
        
        if let url = URL(string: newURLLink) {
            player = AVPlayer(url: url)
            avpController.player = player
            avpController.showsPlaybackControls = false
            self.isPlaying = true
            self.player.play()
            
            let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { progressTime in
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                self.timeLabel.text = "\(minutesText):\(secondsText)"
            })
            
            setupAVPlayer()
        }
    }
    
    private func setupAVPlayer() {
        player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        if #available(iOS 10.0, *) {
            player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        } else {
            player.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(lofTVVC.tapReader), userInfo: nil, repeats: false)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === player {
            if keyPath == "status" {
                if player.status == .readyToPlay {
                    guard let currentTime = player?.currentTime() else { return }
                    let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
                    if let currentItem = player.currentItem {
                        sliderView.minimumValue = 0
                        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsedTime in
                            self.updateVideoPlayerSlider()
                        })
                        sliderView.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
                        sliderView.isUserInteractionEnabled = true
                        avpController.videoGravity = .resizeAspectFill
                        
                        player.play()
                        
                    }
                }else if player.status == .failed {
                    print("error fetching")
                }
            } else if keyPath == "timeControlStatus" {
                if #available(iOS 10.0, *) {
                    if player.timeControlStatus == .playing {
                        
                        self.startTimer()
                        setupLabels()
                        playButton.setImage(UIImage(named: "Pause_Icon"), for: .normal)
                        playButton.tintColor = .white
                        
                    }else if player.timeControlStatus == .paused {
                        
                        playButton.setImage(UIImage(named: "Play_Button"), for: .normal)
                        playButton.tintColor = .white
                        
                        if isOpen == false {
                            if isVisible == false {
                                UIView.animate(withDuration: 0, delay: 0, animations: {
                                    self.topView.alpha = 1
                                    self.botttomView.alpha = 1
                                }) { (_) in
                                    // mark
                                    self.isVisible = true
//                                    self.startTimer()
                                }
                            }else{
                                UIView.animate(withDuration: 0, delay: 0, animations: {
                                    self.topView.alpha = 1
                                    self.botttomView.alpha = 1
                                }) { (_) in
                                    // mark
                                    self.isVisible = true
                                    //                                    self.startTimer()
                                }
                            }
                        }else{
                            print("view not available")
                        }
                    }
                }
            } else if keyPath == "rate" {
                if player.rate > 0 {
                    
                } else {
                    
                }
            }
        }
    }
    
    func setupLabels() {
        guard let currentTime = player?.currentTime() else { return }
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        if let currentItem = player.currentItem {
            
            
            // Update time remaining label
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            
            let totalTimeInSeconds = CMTimeGetSeconds(duration)
            let remainingTimeInSeconds = totalTimeInSeconds - currentTimeInSeconds
            
            let mins = remainingTimeInSeconds / 60
            let secs = remainingTimeInSeconds.truncatingRemainder(dividingBy: 60)
            let timeformatter = NumberFormatter()
            timeformatter.minimumIntegerDigits = 2
            timeformatter.minimumFractionDigits = 0
            timeformatter.roundingMode = .down
            
        }
    }
    
    @objc func handleSliderChange() {
        print(sliderView.value)
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(sliderView.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //perhaps do something later here
                
            })
        }
    }
    
    func updateVideoPlayerSlider() {
        guard let currentTime = player?.currentTime() else { return }
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        sliderView.value = Float(currentTimeInSeconds)
        if let currentItem = player?.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let currentTime = currentItem.currentTime()
            sliderView.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    
    @objc func playButtonTapped(_ sender:UIButton) {
        if player?.rate == 0
        {
            player.play()
            
        } else {
            player.pause()
        }
    }
    
    func updateSlider() {
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        // 2 Alternatively, you could able to get current time from `currentItem` - videoPlayer.currentItem.duration
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        timeLabel.text = "\(minsStr):\(secsStr)"
        sliderView.value = Float(currentTimeInSeconds) // I don't think this is correct to show current progress, however, this update will fix the compile error
        
//         3 My suggestion is probably to show current progress properly
        if let currentItem = player.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                // Do sth
                return;
            }
            let currentTime = currentItem.currentTime()
            sliderView.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
    
    @objc func fetchInfo() {
        if selection == "For You" {
            self.popularVideos.removeAll()
            self.lofVideos.removeAll()
            self.cellHolder.reloadData()
            
            Firestore.firestore().collection("igtv").getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    if let snapshot = snapshot {
                        for doc in snapshot.documents {
                            let value = doc.data()
                            if let vId = value["id"] as? String {
                                if let name = value["title"] as? String {
                                    if let date = value["date"] as? String {
                                        if let desc = value["description"] as? String {
                                            if let uploader = value["uploader"] as? String {
                                                print("FOUND A FOR YOU VIDEO")
                                                if let type = value["type"] as? String {
                                                    if type == "for you" {
                                                        if let time = value["time"] as? String {
                                                            print("FOUND A FOR YOU VIDEO")
                                                            let newVideo = lofVideo(id: vId, uploader: uploader, name: name, description: desc, date: date, time: time)
                                                            self.lofVideos.append(newVideo)
                                                        }else{
                                                            print("FOUND A FOR YOU VIDEO")
                                                            let newVideo = lofVideo(id: vId, uploader: uploader, name: name, description: desc, date: date, time: "")
                                                            self.lofVideos.append(newVideo)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if self.lofVideos.count > 0 {
                            let filtered = self.lofVideos.filterDuplicates({$0.id == $1.id})
                            let sorted = filtered.sorted(by: {$0.date > $1.date})
                            
                            self.lofVideos = sorted
                            
                            self.cellHolder.reloadData()
                            
                            self.preSelectRow()
                        }
                    }
                    
                    if let first = snapshot?.documents.first {
                        let value = first.data()
                        if let vId = value["id"] as? String {
                            if let name = value["title"] as? String {
                                if let date = value["date"] as? String {
                                    if let uploader = value["uploader"] as? String {
                                        
                                        self.selectedVideoName = name
                                        self.selectedVideo = vId
                                        self.selectedVideoUploader = uploader
                                        self.selectedVideoDate = date
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else{
            self.popularVideos.removeAll()
            self.lofVideos.removeAll()
            self.cellHolder.reloadData()
            
            Firestore.firestore().collection("igtv").getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    if let snapshot = snapshot {
                        for doc in snapshot.documents {
                            let value = doc.data()
                            if let vId = value["id"] as? String {
                                if let name = value["title"] as? String {
                                    if let date = value["date"] as? String {
                                        if let desc = value["description"] as? String {
                                            if let uploader = value["uploader"] as? String {
                                                if let type = value["type"] as? String {
                                                    if type == "popular" {
                                                        if let time = value["time"] as? String {
                                                            let newVideo = lofVideo(id: vId, uploader: uploader, name: name, description: desc, date: date, time: time)
                                                            self.popularVideos.append(newVideo)
                                                            print(newVideo)
                                                        }else{
                                                            let newVideo = lofVideo(id: vId, uploader: uploader, name: name, description: desc, date: date, time: "")
                                                            self.popularVideos.append(newVideo)
                                                            print(newVideo)
                                                        }
                                                    }else{
                                                        // NOT A POPULAR ONE
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if self.popularVideos.count > 0 {
                            let filtered = self.popularVideos.filterDuplicates({$0.id == $1.id})
                            let sorted = filtered.sorted(by: {$0.date > $1.date})
                            
                            self.popularVideos = sorted
                            
                            self.cellHolder.reloadData()
                            
                            self.preSelectRow()
                        }
                    }
                    
                    if let first = snapshot?.documents.first {
                        let value = first.data()
                        if let vId = value["id"] as? String {
                            if let name = value["title"] as? String {
                                if let date = value["date"] as? String {
                                    if let uploader = value["uploader"] as? String {
                                        
                                        self.selectedVideoName = name
                                        self.selectedVideo = vId
                                        self.selectedVideoUploader = uploader
                                        self.selectedVideoDate = date
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func fetchVideo() {
        
        newVideoTapped()
    }
    
    @objc func handleLikeButtonTapped() {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class LOFTvCell: UICollectionViewCell {
    
    let holderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "0:00"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "---"
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "---"
        return label
    }()
    
    let badgeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 14).isActive = true
        view.widthAnchor.constraint(equalToConstant: 14).isActive = true
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 0
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        return view
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        return iv
    }()
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }()
    
    let verifiedImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "verified")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            holderView.layer.borderColor = isHighlighted ? UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor : UIColor.clear.cgColor
            holderView.layer.borderWidth = isHighlighted ? 2 : 0
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            holderView.layer.borderColor = isSelected ? UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor : UIColor.clear.cgColor
            holderView.layer.borderWidth = isSelected ? 2 : 0
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupViews()
    }
    
    public func getThumbnailFromUrl(_ url: String?, _ completion: @escaping ((_ image: UIImage?)->Void)) {

        guard let url = URL(string: url ?? "") else { return }
        DispatchQueue.main.async {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true

            let time = CMTimeMake(value: 2, timescale: 1)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                completion(thumbnail)
            } catch {
                print("Error :: ", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(usernameLabel)
        stackViewOne.addArrangedSubview(badgeView)
        stackViewOne.spacing = 5
        stackViewOne.axis = .horizontal
        stackViewOne.alignment = .center
        
        let stackViewTwo = UIStackView()
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        stackViewTwo.addArrangedSubview(imageHolder)
        stackViewTwo.addArrangedSubview(stackViewOne)
        stackViewTwo.spacing = 5
        stackViewTwo.axis = .horizontal
        stackViewTwo.alignment = .center
        
        let stackViewThree = UIStackView()
        stackViewThree.translatesAutoresizingMaskIntoConstraints = false
        stackViewThree.addArrangedSubview(titleLabel)
        stackViewThree.addArrangedSubview(stackViewTwo)
        stackViewThree.spacing = 5
        stackViewThree.axis = .vertical
        stackViewThree.alignment = .leading
//        stackViewThree.distribution = .fillProportionally
        
        addSubview(holderView)
        holderView.addSubview(imageView)
//        holderView.addSubview(imageHolder)
        holderView.addSubview(timeLabel)
        holderView.addSubview(stackViewThree)
        badgeView.addSubview(verifiedImageView)
        imageHolder.addSubview(profileImage)
        
        NSLayoutConstraint.activate([
            holderView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            holderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            holderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            holderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            timeLabel.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: -15),
            timeLabel.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 15),
            
//            imageHolder.leadingAnchor.constraint(equalTo: holderView.leadingAnchor, constant: 15),
//            imageHolder.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -15),
            
            imageView.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: holderView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: 0),
            
            verifiedImageView.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 0),
            verifiedImageView.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: 0),
            verifiedImageView.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 0),
            verifiedImageView.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: 0),
            
            profileImage.topAnchor.constraint(equalTo: imageHolder.topAnchor, constant: 0),
            profileImage.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: 0),
            profileImage.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 0),
            profileImage.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: 0),
            
            stackViewThree.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -15),
            stackViewThree.leadingAnchor.constraint(equalTo: holderView.leadingAnchor, constant: 15),
            stackViewThree.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: -15),
            
//            titleLabel.bottomAnchor.constraint(equalTo: imageHolder.topAnchor, constant: -5),
//            titleLabel.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: stackViewOne.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LOFCategoryCell: UICollectionViewCell {
    
    let selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alpha = 0
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.alpha = 0.4
        label.text = "For You"
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            selectedView.alpha = isHighlighted ? 1 : 0
            titleLabel.alpha = isHighlighted ? 1 : 0.4
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectedView.alpha = isSelected ? 1 : 0
            titleLabel.alpha = isSelected ? 1 : 0.4
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(selectedView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            selectedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
