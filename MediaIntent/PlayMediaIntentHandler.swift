//
//  PlayMediaIntentHandler.swift
//  MediaIntent
//
//  Created by TTN on 05/12/21.
//

import Foundation
import Intents

class PlayMediaIntentHandler: NSObject, INPlayMediaIntentHandling {
    func handle(intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
        completion(INPlayMediaIntentResponse(code: .handleInApp, userActivity: nil))
    }
    
    
}
