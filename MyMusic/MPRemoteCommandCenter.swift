//
//  MPRemoteCommandCenter.swift
//  MyMusic
//
//  Created by TTN on 19/12/21.
//

import Foundation
import MediaPlayer

enum NowPlayableCommand: CaseIterable {
    case play, pause, stop, togglePausePlay
    
    case nextTrack, previousTrack
    
    
    var remoteCommand: MPRemoteCommand {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        
        switch self {
        case .pause:
            return remoteCommandCenter.pauseCommand
        case .play:
            return remoteCommandCenter.playCommand
        case .stop:
            return remoteCommandCenter.stopCommand
        case .togglePausePlay:
            return remoteCommandCenter.togglePlayPauseCommand
        case .nextTrack:
            return remoteCommandCenter.nextTrackCommand
        case .previousTrack:
            return remoteCommandCenter.previousTrackCommand
        }
    }
    
    func removeHandler() {
        remoteCommand.removeTarget(nil)
    }
    
    // Install a handler for this command.
    
//    func addHandler(_ handler: @escaping (NowPlayableCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) {
//        
//        switch self {
//
//        case .skipBackward:
//            MPRemoteCommandCenter.shared().skipBackwardCommand.preferredIntervals = [15.0]
//
//        case .skipForward:
//            MPRemoteCommandCenter.shared().skipForwardCommand.preferredIntervals = [15.0]
//
//        default:
//            break
//        }
//
//        remoteCommand.addTarget { handler(self, $0) }
//    }
    
    // Disable this command.
    
    func setDisabled(_ isDisabled: Bool) {
        remoteCommand.isEnabled = !isDisabled
    }
}


