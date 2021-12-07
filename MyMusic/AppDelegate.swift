//
//  AppDelegate.swift
//  MyMusic
//
//  Created by TTN on 03/12/21.
//

import UIKit
import Intents
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var player: AVAudioPlayer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // filling the data souce
        ViewController.shared.configureSongs() // DataSource should be configured beforehand this won't
        // be a problem in our case as we are pulling the data from an API.
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
    
    // MARK:- Siri Intent Handling
    
    func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {
        if let playMediaIntent = intent as? INPlayMediaIntent {
            if let mediaItems = playMediaIntent.mediaItems {
                let mediaItemToPlay = mediaItems.first
                
                //print(mediaItemToPlay)
                
                
                songPlay(mediaItemToPlay: mediaItemToPlay)
                // do whatever to you do to play that media.
                
                completionHandler(INPlayMediaIntentResponse(code: .success, userActivity: nil))
            }
        }
    }
    
    
}


// MARK:- Song Play configuration
extension AppDelegate {
    func songPlay(mediaItemToPlay: INMediaItem?) {
        
        var songToPlay: Song?
        //        let song = song
        
        for song in ViewController.shared.songs where song.songName == mediaItemToPlay?.title {
            songToPlay = song
        }
        
        // print(songToPlay!)
        
        let urlString = Bundle.main.path(forResource: songToPlay?.trackName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                return
            }
            
            player.volume = 0.5
            
            player.play()
            
        } catch {
            print("Error Occured")
        }
    }
}
