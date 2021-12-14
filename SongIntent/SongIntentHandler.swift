//
//  SongIntentHandler.swift
//  MyMusic
//
//  Created by TTN on 07/12/21.
//

import Foundation
import Intents

class SongIntentHandler: NSObject, INPlayMediaIntentHandling {
    func handle(intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
        // we have used handleInApp response code in order to handle the response in the background,
        // if we want our application to open we will us .continueInApp code
        completion(INPlayMediaIntentResponse(code: .handleInApp, userActivity: nil))
        
        // this is the statement for implementing the app open functionality
        
        //helping code https://github.com/ji3g4kami/Siri-shortcut-button
        // let userActivity = NSUserActivity(activityType: "INPlayMediaIntent");
        // completion(INPlayMediaIntentResponse(code: .continueInApp, userActivity: nil))
    }
    
    func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
        // completion([INPlayMediaMediaItemResolutionResult.unsupported()])
        
        // Initialised the response code using unsupported result error
        var result = INPlayMediaMediaItemResolutionResult.unsupported()
        
        // this can be treated as API call or configuration of music
        ViewController.shared.configureSongs()
        
        // here we are mapping the song which is requested by the user, the requested song's details will be available
        if let mediaName = intent.mediaSearch?.mediaName {
            if mediaName.lowercased() == "songs" { // for this I have to identify playnext intent
                let mediaItems = INMediaItem(identifier: "songs", title: "All Songs", type: .playlist, artwork: nil)
                print("This is for all songs")
                print(mediaItems)
                result = INPlayMediaMediaItemResolutionResult.success(with: mediaItems)
            } else {
                for song in ViewController.shared.songs where song.songName.lowercased() == mediaName.lowercased() {
                    let mediaItem = INMediaItem(identifier: song.songName, title: song.songName, type: .music, artwork: nil)
                    print(mediaItem)
                    result = INPlayMediaMediaItemResolutionResult.success(with: mediaItem)
                    break
                }
            }
        }
        completion([result])
    }
}
