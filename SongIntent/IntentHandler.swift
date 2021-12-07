//
//  IntentHandler.swift
//  SongIntent
//
//  Created by TTN on 07/12/21.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        guard intent is INPlayMediaIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        
        return SongIntentHandler()
    }
    
}
