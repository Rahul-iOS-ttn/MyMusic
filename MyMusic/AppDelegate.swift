//
//  AppDelegate.swift
//  MyMusic
//
//  Created by TTN on 03/12/21.
//

import UIKit
import Intents

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
    
    func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
        let playMediaIntent = intent as? INPlayMediaIntent
        
        // The command you will give to siri will come here in MediaSearch object
        let mediaName = playMediaIntent?.mediaSearch?.mediaName
        
        var response = INPlayMediaIntentResponse(code: INPlayMediaIntentResponseCode.failure, userActivity: userActivity)
        
        if (ViewController.shared.songs.contains(where: { (Song) -> Bool in
            (Song.songName == mediaName) ? true : false
        })){
            response = INPlayMediaIntentResponse(code: INPlayMediaIntentResponseCode.continueInApp, userActivity: nil)
        } else {
            response = INPlayMediaIntentResponse(code: INPlayMediaIntentResponseCode.failureUnknownMediaType, userActivity: nil)
        }
        
        return response
    }
}

