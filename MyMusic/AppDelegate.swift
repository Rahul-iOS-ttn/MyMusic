//
//  AppDelegate.swift
//  MyMusic
//
//  Created by TTN on 03/12/21.
//

import UIKit
import Intents
import AVFoundation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var player: AVAudioPlayer?
    
    var window: UIWindow?
    // for api calling
    let viewModel = ViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // filling the data souce
        ViewController.shared.configureSongs() // DataSource should be configured beforehand this won't
        // be a problem in our case as we are pulling the data from an API.
        
        // for Notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if error != nil {
                print("Request authorization failed!")
            } else {
                print("Request authorization succeeded!")
                self.showAlert()
            }
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
    
    // MARK:- Siri Intent Handling
    
    /// This function handles the INPlayMediaIntent that comes from our implemented intent Handler after running INPlayMediaMediaItemResolutionResult with success code in resolvedMediaItems
    /// - Parameters:
    ///   - application: UIApplication
    ///   - intent: INIntent
    ///   - completionHandler: gives a response code depending on success or failure of the function using INPlayMediaIntentResponse
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
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard userActivity.activityType == NSStringFromClass(INPlayMediaIntent.self), let playMediaIntent = userActivity.interaction?.intent as? INPlayMediaIntent else {
            return false
        }
        
        songPlay(mediaItemToPlay: playMediaIntent.mediaItems?.first)
        
        //configuring where to send the view controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailPage = storyBoard.instantiateViewController(withIdentifier: "Player") as! PlayerViewController
        
        detailPage.position = 1
        detailPage.songs = ViewController.shared.songs
        
        let navigationController = window?.rootViewController as? UINavigationController
        
        navigationController?.pushViewController(detailPage, animated: false)
        
        return true
    }
    
}


// MARK:- Song Play configuration
extension AppDelegate {
    func songPlay(mediaItemToPlay: INMediaItem?) {
        
        var songToPlay: Song?
        //        let song = song
        // indexCounter for songs
        // we have to make this index counter update to next song when we get next intent
        let indexCounter: Int = 0
        
        
        // configuring if I can play the playlist
        
        if mediaItemToPlay?.identifier?.lowercased() == "songs" {
            songToPlay = ViewController.shared.songs[indexCounter]
        } else {
            for song in ViewController.shared.songs where song.songName.lowercased() == mediaItemToPlay?.title?.lowercased() {
                songToPlay = song
            }
        }
        
        // print(songToPlay!)
        getData()
        
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

extension AppDelegate {
    
    //MARK:- Data Call for API
    
    func getData() {
        viewModel.getInformation { (dataFetchSuccess, error) in
            if dataFetchSuccess {
                print(self.viewModel.genreItems[0].genreMovies[0].title ?? "No Data I guess")
            } else {
                print(error)
            }
        }
    }
    
    func showAlert() {
        let objAlert = UIAlertController(title: "Alert", message: "Request authorization succeeded", preferredStyle: UIAlertController.Style.alert)

        objAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //self.presentViewController(objAlert, animated: true, completion: nil)

        UIApplication.shared.keyWindow?.rootViewController?.present(objAlert, animated: true, completion: nil)
    }
    
}
