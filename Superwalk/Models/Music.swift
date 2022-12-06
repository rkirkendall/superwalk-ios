//
//  Music.swift
//  SUPERWALK
//
//  Created by Ricky Kirkendall on 12/6/22.
//

import Foundation
import MediaPlayer

class MusicPlayer {
    public static let shared = MusicPlayer()
    
    private let player = MPMusicPlayerController.systemMusicPlayer
    private var isPlaying = false
    
    public func play() {        
        player.play()
        isPlaying = true
    }
    
    public func pause() {
        player.pause()
        isPlaying = false
    }
}
