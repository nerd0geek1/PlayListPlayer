import Foundation
import AVFoundation

public protocol PlayListPlayerType {

    var didStartPlayingTrack:(() -> Void)? { get set }
    var didFinishPlayingTrack:(() -> Void)? { get set }
    var didFinishPlayingPlayList:(() -> Void)? { get set }

    var playMode: PlayerPlayMode { get set }
    var playList: [URL] { get }
    var currentIndex: Int { get }

    func set(playList: [URL])
    func set(currentIndex: Int) -> Bool

    func engine() -> AVPlayer
    func hasPlayList() -> Bool
    func currentTrackURL() -> URL?
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
    func seek(to position: Float)
}

public enum PlayerPlayMode: Int {
    case repeatPlayList
    case repeatItem
    case noRepeat
}
