import Foundation
import AVFoundation

public extension CALayer {
    public func set(player: PlayListPlayer) {
        if let layer = self as? AVPlayerLayer {
            layer.player = player.engine()
        }
    }
}
