//
//  PlayMediaIntentHandler.swift
//  MediaIntent
//
//  Created by TTN on 05/12/21.
//

import Foundation
import Intents

class PlayMediaIntentHandler: NSObject, INPlayMediaIntentHandling, INAddMediaIntentHandling {
    
    
//    // INAddMediaIntent
    func handle(intent: INAddMediaIntent, completion: @escaping (INAddMediaIntentResponse) -> Void) {

        let userActivity = NSUserActivity(activityType: "INAddMediaIntent")
        let response = INAddMediaIntentResponse(code: INAddMediaIntentResponseCode.success, userActivity: userActivity)

        completion(response)

    }
    
    // INPlayMediaIntent
    func handle(intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
        let response = INPlayMediaIntentResponse(code: INPlayMediaIntentResponseCode.handleInApp, userActivity: nil)
        completion(response)
    }
    
    // now that the file is shared with the extension you can implement the Add media here.
}
