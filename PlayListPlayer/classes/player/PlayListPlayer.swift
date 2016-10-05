//
//  PlayListPlayer.swift
//  PlayListPlayer
//
//  Created by Kohei Tabata on 2016/08/02.
//  Copyright © 2016年 nerd0geek1. All rights reserved.
//

import Foundation
import AVFoundation

public class PlayListPlayer: PlayListPlayerType {

    //MARK: - public properties

    public static let sharedInstance: PlayListPlayer = PlayListPlayer()

    public var didFinishPlayingTrack:(() -> Void)?
    public var didFinishPlayingPlayList:(() -> Void)?

    public var playMode: PlayerPlayMode = .RepeatPlayList
    public var playList: [NSURL] {
        return urls
    }

    //MARK: - private properties

    private let player: AVPlayer = AVPlayer()

    private var urls: [NSURL] = []
    private(set) var currentIndex: Int     = 0


    //MARK: - update PlayListPlayer properties

    public func setPlayList(urls: [NSURL]) {
        self.urls = urls
        currentIndex = 0

        setupPlayerItem()
    }

    public func setCurrentIndex(index: Int) -> Bool {
        if !isValidIndex(index) {
            return false
        }

        currentIndex = index
        setupPlayerItem()
        return true
    }

    //MARK: - PlayListPlayer properties

    public func engine() -> AVPlayer {
        return player
    }

    public func hasPlayList() -> Bool {
        return !urls.isEmpty
    }

    public func currentTrackURL() -> NSURL? {
        guard let currentItem: AVPlayerItem = player.currentItem, asset: AVURLAsset = currentItem.asset as? AVURLAsset else {
            return nil
        }

        return asset.URL
    }

    public func isPlaying() -> Bool {
        if player.currentItem == nil {
            return false
        }

        return player.rate != 0.0
    }

    //MARK: - operate PlayListPlayer

    public func play() {
        player.play()
    }

    public func pause() {
        player.pause()
    }

    public func beginFastForwarding() {
        player.rate = 2.0
    }

    public func endFastForwarding() {
        resetPlayerRate()
    }

    public func skipToNextTrack() {
        let isLastTrack: Bool = currentIndex == lastTrackIndex()
        let nextIndex: Int    = isLastTrack ? 0 : currentIndex + 1

        switch playMode {
        case .RepeatPlayList:
            setCurrentIndex(nextIndex)
            play()
        case .RepeatItem:
            seekToTrackBeginning()
        case .NoRepeat:
            setCurrentIndex(nextIndex)
            if isLastTrack {
                pause()
            }
        }
    }

    public func beginRewinding() {
        player.rate = -2.0
    }

    public func endRewinding() {
        resetPlayerRate()
    }

    public func jumpToPreviousTrack() {
        let isFirstTrack: Bool = currentIndex == 0
        let previousIndex: Int = isFirstTrack ? 0 : currentIndex - 1

        switch playMode {
        case .RepeatPlayList, .NoRepeat:
            if isFirstTrack {
                seekToTrackBeginning()
            } else {
                setCurrentIndex(previousIndex)
            }
        case .RepeatItem:
            seekToTrackBeginning()
        }
    }

    //MARK: - private

    private func setupPlayerItem() {
        if !isValidIndex(currentIndex) {
            return
        }

        guard let url: NSURL = urls[currentIndex] else {
            return
        }

        NSNotificationCenter.defaultCenter().removeObserver(self)

        let playerItem: AVPlayerItem = AVPlayerItem(URL: url)
        player.replaceCurrentItemWithPlayerItem(playerItem)

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(playerDidFinishTrackPlaying),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: player.currentItem)
    }

    private func isValidIndex(index: Int) -> Bool {
        return hasPlayList() && 0 <= index && index <= lastTrackIndex()
    }

    private func lastTrackIndex() -> Int {
        return urls.count == 0 ? 0 : urls.count - 1
    }

    private func resetPlayerRate() {
        player.rate = 1.0
    }

    private func seekToTrackBeginning() {
        player.seekToTime(kCMTimeZero)
    }

    //MARK: - Notification

    @objc
    private func playerDidFinishTrackPlaying(notification: NSNotification) {
        didFinishPlayingTrack?()

        if currentIndex == lastTrackIndex() {
            didFinishPlayingPlayList?()
        }

        skipToNextTrack()
    }
}
