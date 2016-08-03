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

    var didFinishPlayingTrack:(() -> Void)? { get set }
    var didFinishPlayingPlayList:(() -> Void)? { get set }

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
}

public enum PlayMode: Int {
    case RepeatPlayList
    case RepeatItem
    case NoRepeat
}
