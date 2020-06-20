//
//  AppDelegate.swift
//  LOFAdminV2
//
//  Created by UnoEast on 1/11/20.
//  Copyright © 2020 LionsOfForex. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import UserNotifications
import Alamofire
import SwiftyJSON
import Firebase

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        // Configure Firebase
        // ------------------
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
         
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
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

