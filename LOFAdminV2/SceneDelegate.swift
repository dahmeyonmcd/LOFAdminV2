//
//  SceneDelegate.swift
//  LOFAdminV2
//
//  Created by UnoEast on 1/11/20.
//  Copyright © 2020 LionsOfForex. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if UserDefaults.standard.string(forKey: "Update3") != nil {
            if isLoggedIn == true
            {
                let vc = NewDashboardVC()
                
                let mainNavigation = UINavigationController(rootViewController: vc)
                mainNavigation.isNavigationBarHidden = true
                
                window?.rootViewController = mainNavigation
            }else {
                KeychainWrapper.standard.removeObject(forKey: "accessToken")
                KeychainWrapper.standard.removeObject(forKey: "accessToken")
                KeychainWrapper.standard.removeObject(forKey: "passToken")
                KeychainWrapper.standard.removeObject(forKey: "nameToken")
                KeychainWrapper.standard.removeObject(forKey: "statusToken")
                KeychainWrapper.standard.removeObject(forKey: "emailStatusToken")
                KeychainWrapper.standard.removeObject(forKey: "selectedCourse")
                KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
                KeychainWrapper.standard.removeObject(forKey: "selectedCourseName")
                KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
                KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
                KeychainWrapper.standard.removeObject(forKey: "profileImageUrl")
                KeychainWrapper.standard.removeObject(forKey: "numberOfLions")
                KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateDate")
                KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateName")
                KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateCommision")
                KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateVisitors")
                KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateConversion")
                KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateStatus")
                KeychainWrapper.standard.removeObject(forKey: "profileImage")
                KeychainWrapper.standard.removeObject(forKey: "profileImageUrl")
                KeychainWrapper.standard.removeObject(forKey: "affiliatesVisitors")
                KeychainWrapper.standard.removeObject(forKey: "affiliatesEarned")
                KeychainWrapper.standard.removeObject(forKey: "affiliatesVisitors")
                KeychainWrapper.standard.removeObject(forKey: "affiliatesConversion")
                KeychainWrapper.standard.removeObject(forKey: "affiliateLock")
                KeychainWrapper.standard.removeObject(forKey: "selectedSymbol")
                KeychainWrapper.standard.removeObject(forKey: "selectedType")
                KeychainWrapper.standard.removeObject(forKey: "selectedSignalDate")
                KeychainWrapper.standard.removeObject(forKey: "selectedPips")
                KeychainWrapper.standard.removeObject(forKey: "selectedSL")
                KeychainWrapper.standard.removeObject(forKey: "selectedTP")
                KeychainWrapper.standard.removeObject(forKey: "selectedEntry")
                KeychainWrapper.standard.removeObject(forKey: "currentPackage")
                KeychainWrapper.standard.removeObject(forKey: "lofMembers")
                KeychainWrapper.standard.removeObject(forKey: "selectedUpdate")
                KeychainWrapper.standard.removeAllKeys()
                UserDefaults.standard.removeObject(forKey: "savedProfileImage")
                //            KeychainWrapper.standard.removeObject(forKey: "SignedInOnce")
                let vc = NewDashboardVC()
                
                let mainNavigation = UINavigationController(rootViewController: vc)
                mainNavigation.isNavigationBarHidden = true
                
                window?.rootViewController = mainNavigation
            }
        }else{
            KeychainWrapper.standard.removeObject(forKey: "accessToken")
            KeychainWrapper.standard.removeObject(forKey: "accessToken")
            KeychainWrapper.standard.removeObject(forKey: "passToken")
            KeychainWrapper.standard.removeObject(forKey: "nameToken")
            KeychainWrapper.standard.removeObject(forKey: "statusToken")
            KeychainWrapper.standard.removeObject(forKey: "emailStatusToken")
            KeychainWrapper.standard.removeObject(forKey: "selectedCourse")
            KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
            KeychainWrapper.standard.removeObject(forKey: "selectedCourseName")
            KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
            KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
            KeychainWrapper.standard.removeObject(forKey: "profileImageUrl")
            KeychainWrapper.standard.removeObject(forKey: "numberOfLions")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateDate")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateName")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateCommision")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateVisitors")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateConversion")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateStatus")
            KeychainWrapper.standard.removeObject(forKey: "profileImage")
            KeychainWrapper.standard.removeObject(forKey: "profileImageUrl")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesVisitors")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesEarned")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesVisitors")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesConversion")
            KeychainWrapper.standard.removeObject(forKey: "affiliateLock")
            KeychainWrapper.standard.removeObject(forKey: "selectedSymbol")
            KeychainWrapper.standard.removeObject(forKey: "selectedType")
            KeychainWrapper.standard.removeObject(forKey: "selectedSignalDate")
            KeychainWrapper.standard.removeObject(forKey: "selectedPips")
            KeychainWrapper.standard.removeObject(forKey: "selectedSL")
            KeychainWrapper.standard.removeObject(forKey: "selectedTP")
            KeychainWrapper.standard.removeObject(forKey: "selectedEntry")
            KeychainWrapper.standard.removeObject(forKey: "currentPackage")
            KeychainWrapper.standard.removeObject(forKey: "lofMembers")
            KeychainWrapper.standard.removeObject(forKey: "selectedUpdate")
            KeychainWrapper.standard.removeAllKeys()
            UserDefaults.standard.removeObject(forKey: "savedProfileImage")
            //            KeychainWrapper.standard.removeObject(forKey: "SignedInOnce")
            let vc = NewDashboardVC()
            
            let mainNavigation = UINavigationController(rootViewController: vc)
            mainNavigation.isNavigationBarHidden = true
            
            window?.rootViewController = mainNavigation
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

