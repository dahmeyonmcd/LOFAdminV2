//
//  SelectedCourseVideoVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/28/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import AVKit
import VimeoNetworking

class SelectedCourseVideoVC: UIView {
    
    let videoHolder: UIView = {
        let vh = UIView()
        vh.backgroundColor = .black
        vh.translatesAutoresizingMaskIntoConstraints = false
        return vh
    }()
    
    let videoComponentHolder: UIView = {
        let vh = UIView()
        vh.backgroundColor = .clear
        vh.translatesAutoresizingMaskIntoConstraints = false
        return vh
    }()
    
    let videoDescriptionHolder: UIView = {
        let vh = UIView()
        vh.translatesAutoresizingMaskIntoConstraints = false
        vh.backgroundColor = .clear
        return vh
    }()
    
    let gradientHolder: UIImageView = {
        let hv = UIImageView()
        hv.image = UIImage(named: "")
        hv.translatesAutoresizingMaskIntoConstraints = false
        hv.contentMode = .scaleToFill
        return hv
    }()
    
    let videoTitleLabel: UILabel = {
        let vh = UILabel()
        vh.text = "---"
        vh.textAlignment = .left
        vh.backgroundColor = .red
        vh.translatesAutoresizingMaskIntoConstraints = false
        return vh
    }()
    
    let videoCourseLabel: UILabel = {
        let vh = UILabel()
        vh.text = "---"
        vh.textAlignment = .left
        vh.backgroundColor = .blue
        vh.translatesAutoresizingMaskIntoConstraints = false
        return vh
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        fetchVideoAttributes()
        
    }
    
    
    func fetchVimeoVideo() {
        let appConfiguration = AppConfiguration(clientIdentifier: "", clientSecret: "", scopes: [.Private, .Public, .Interact], keychainService: "")
        let vimeoClient = VimeoClient(appConfiguration: appConfiguration)
        let videoID: String? = KeychainWrapper.standard.string(forKey: "selectedVideo")
        let videoRequest = VideoRequest(path: videoID!)
        
        let authenticationController = AuthenticationController(client: vimeoClient, appConfiguration: appConfiguration)
        authenticationController.accessToken(token: "")
        { (result) in
            switch result
            {
            case .success(let account):
                print("authenticated Successsfully: \(account)")
            case .failure(let error):
                print("failure authenticating")
                print(error)
            }
        }
        DispatchQueue.main.async {
            vimeoClient.request(videoRequest, completion: { (result) in
                switch result {
                case .success(let result):
                    let video: VIMVideo = result.model
//                    let jsonModel = result.json
                    print("retrieved video: \(video)")
                case .failure(let error):
                    print("error retrieving video: \(error)")
                }
            })
        }
        DispatchQueue.main.async {
            print("video fetched")
        }
    }
    
    
    func fetchVideoAttributes() {
        let videoCourseTitle: String? = KeychainWrapper.standard.string(forKey: "")
        let videoTitle: String? = KeychainWrapper.standard.string(forKey: "")
        
        // initialize labels
        videoTitleLabel.text = videoTitle
        videoCourseLabel.text = videoCourseTitle
    }
    
    func setupLayout() {
        addSubview(videoHolder)
        addSubview(videoDescriptionHolder)
        videoHolder.addSubview(videoComponentHolder)
        videoComponentHolder.addSubview(gradientHolder)
        videoComponentHolder.addSubview(videoTitleLabel)
        videoComponentHolder.addSubview(videoCourseLabel)
        
        
        // setup the view layout
        NSLayoutConstraint.activate([
            videoHolder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            videoHolder.widthAnchor.constraint(equalTo: widthAnchor),
            videoHolder.topAnchor.constraint(equalTo: topAnchor),
            videoHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoComponentHolder.heightAnchor.constraint(equalTo: videoHolder.heightAnchor, multiplier: 0.3),
            videoComponentHolder.leadingAnchor.constraint(equalTo: videoHolder.leadingAnchor),
            videoComponentHolder.trailingAnchor.constraint(equalTo: videoHolder.trailingAnchor),
            videoTitleLabel.heightAnchor.constraint(equalTo: videoComponentHolder.heightAnchor, multiplier: 0.7),
            videoTitleLabel.leadingAnchor.constraint(equalTo: videoComponentHolder.leadingAnchor,constant: 15),
            videoTitleLabel.trailingAnchor.constraint(equalTo: videoComponentHolder.trailingAnchor, constant: -15),
            videoCourseLabel.heightAnchor.constraint(equalTo: videoComponentHolder.heightAnchor, multiplier: 0.3),
            videoCourseLabel.leadingAnchor.constraint(equalTo: videoComponentHolder.leadingAnchor, constant: 15),
            videoCourseLabel.trailingAnchor.constraint(equalTo: videoComponentHolder.trailingAnchor, constant: -15),
            videoDescriptionHolder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            videoDescriptionHolder.widthAnchor.constraint(equalTo: widthAnchor),
            videoDescriptionHolder.topAnchor.constraint(equalTo: videoHolder.bottomAnchor),
            videoDescriptionHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoDescriptionHolder.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
