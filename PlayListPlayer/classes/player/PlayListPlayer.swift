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
    public static let sharedInstance: PlayListPlayer = PlayListPlayer()

    public var didFinishPlayingTrack:(() -> Void)?
    public var didFinishPlayingPlayList:(() -> Void)?

    private let player: AVPlayer = AVPlayer()

    private(set) var playListURLs: [NSURL] = []
    private(set) var currentIndex: Int     = 0

    //MARK: - update PlayListPlayer properties

    public func setPlayList(urls: [NSURL]) {
        self.playListURLs = urls
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
        return !playListURLs.isEmpty
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
        let nextIndex: Int = currentIndex + 1

        if isValidIndex(nextIndex) {
            setCurrentIndex(nextIndex)
            player.play()
            return
        }

        player.pause()
        seekToTrackBeginning()
    }

    public func beginRewinding() {
        player.rate = -2.0
    }

    public func endRewinding() {
        resetPlayerRate()
    }

    public func jumpToPreviousTrack() {
        let previousIndex: Int = currentIndex - 1

        if isValidIndex(previousIndex) {
            setCurrentIndex(previousIndex)
            play()
            return
        }

        seekToTrackBeginning()
        play()
    }

    //MARK: - private

    private func setupPlayerItem() {
        if !hasPlayList() {
            return
        }
        if !isValidIndex(currentIndex) {
            return
        }

        guard let url: NSURL = playListURLs[currentIndex] else {
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
        return 0 <= index && index <= playListURLs.count - 1
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

        if currentIndex == playListURLs.count - 1 {
            didFinishPlayingPlayList?()
        }
    }
}
