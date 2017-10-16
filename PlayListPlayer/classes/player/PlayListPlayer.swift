import Foundation
import AVFoundation

public class PlayListPlayer: PlayListPlayerType {

    // MARK: - public properties

    public static let shared: PlayListPlayer = PlayListPlayer()

    public var didStartPlayingTrack:(() -> Void)?
    public var didFinishPlayingTrack:(() -> Void)?
    public var didFinishPlayingPlayList:(() -> Void)?

    public var playMode: PlayerPlayMode = .repeatPlayList
    public var playList: [URL] {
        return urls
    }
    public var currentIndex: Int {
        return index
    }

    // MARK: - private properties

    private let player: AVPlayer = AVPlayer()

    private var urls: [URL] = []
    private var index: Int  = 0

    // MARK: - update PlayListPlayer properties

    public func set(playList: [URL]) {
        self.urls  = playList
        self.index = 0

        setupPlayerItem()
    }

    @discardableResult
    public func set(currentIndex: Int) -> Bool {
        guard isValid(index: currentIndex) else {
            return false
        }

        self.index = currentIndex
        setupPlayerItem()
        return true
    }

    // MARK: - PlayListPlayer properties

    public func engine() -> AVPlayer {
        return player
    }

    public func hasPlayList() -> Bool {
        return !urls.isEmpty
    }

    public func currentTrackURL() -> URL? {
        guard
            let currentItem: AVPlayerItem = player.currentItem,
            let asset: AVURLAsset = currentItem.asset as? AVURLAsset else {
                return nil
        }

        return asset.url
    }

    public func isPlaying() -> Bool {
        if player.currentItem == nil {
            return false
        }

        return player.rate != 0.0
    }

    // MARK: - operate PlayListPlayer

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
        case .repeatPlayList:
            set(currentIndex: nextIndex)
            play()
        case .repeatItem:
            seekToBeginning()
        case .noRepeat:
            set(currentIndex: nextIndex)
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
        case .repeatPlayList, .noRepeat:
            if isFirstTrack {
                seekToBeginning()
            } else {
                set(currentIndex: previousIndex)
            }
        case .repeatItem:
            seekToBeginning()
        }
    }

    public func seekToBeginning() {
        seek(to: 0)
        didStartPlayingTrack?()
    }

    public func seek(to position: Float) {
        guard let currentItem: AVPlayerItem = player.currentItem else {
            return
        }

        let duration: CMTime = currentItem.asset.duration
        let value: Float     = Float(duration.value) * position
        let seekTime: CMTime = CMTimeMake(CMTimeValue(value), duration.timescale)

        currentItem.seek(to: seekTime)
    }

    // MARK: - private

    private func setupPlayerItem() {
        if !isValid(index: currentIndex) {
            return
        }

        let url: URL = urls[currentIndex]

        NotificationCenter.default.removeObserver(self)

        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        didStartPlayingTrack?()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishTrackPlaying),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }

    private func isValid(index: Int) -> Bool {
        return hasPlayList() && 0 <= index && index <= lastTrackIndex()
    }

    private func lastTrackIndex() -> Int {
        return hasPlayList() ? urls.count - 1 : 0
    }

    private func resetPlayerRate() {
        player.rate = 1.0
    }

    // MARK: - Notification

    @objc private func playerDidFinishTrackPlaying(notification: NSNotification) {
        didFinishPlayingTrack?()

        if currentIndex == lastTrackIndex() {
            didFinishPlayingPlayList?()
        }

        skipToNextTrack()
    }
}
