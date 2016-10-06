//
//  PlayListPlayerType.swift
//  PlayListPlayer
//
//  Created by Kohei Tabata on 7/18/16.
//  Copyright © 2016 nerd0geek1. All rights reserved.
//

import Foundation
import AVFoundation

public protocol PlayListPlayerType {

    var didStartPlayingTrack:(() -> Void)? { get set }
    var didFinishPlayingTrack:(() -> Void)? { get set }
    var didFinishPlayingPlayList:(() -> Void)? { get set }

    var playMode: PlayerPlayMode { get set }
    var playList: [NSURL] { get }
    var currentIndex: Int { get }

    func setPlayList(urls: [NSURL])
    func setCurrentIndex(index: Int) -> Bool

    func engine() -> AVPlayer
    func hasPlayList() -> Bool
    func currentTrackURL() -> NSURL?
    func isPlaying() -> Bool

    func play()
    func pause()
    func beginFastForwarding()
    func endFastForwarding()
    func skipToNextTrack()
    func beginRewinding()
    func endRewinding()
    func jumpToPreviousTrack()

    func seekToBeginning()
    //Position take values between 0.0(the beginning of a track) and 1.0(the end of a track).
    func seekTo(position: Float)
}

public enum PlayerPlayMode: Int {
    case RepeatPlayList
    case RepeatItem
    case NoRepeat
}
