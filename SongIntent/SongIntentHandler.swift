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
        completion(INPlayMediaIntentResponse(code: .handleInApp, userActivity: nil))
    }
    
    func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
        // completion([INPlayMediaMediaItemResolutionResult.unsupported()])
        var result = INPlayMediaMediaItemResolutionResult.unsupported()
        ViewController.shared.configureSongs() // this can be treated as API call or configuration of music
        if let mediaName = intent.mediaSearch?.mediaName {
            for song in ViewController.shared.songs where song.songName == mediaName {
                let mediaItem = INMediaItem(identifier: song.songName, title: song.songName, type: .music, artwork: nil)
                print(mediaItem)
                result = INPlayMediaMediaItemResolutionResult.success(with: mediaItem)
                break
            }
        }
        completion([result])
    }
}
