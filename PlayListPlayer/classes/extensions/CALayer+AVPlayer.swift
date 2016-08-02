//
//  CALayer+AVPlayer.swift
//  PlayListPlayer
//
//  Created by Kohei Tabata on 8/2/16.
//  Copyright © 2016 nerd0geek1. All rights reserved.
//

import Foundation
import AVFoundation

public extension CALayer {
    public func setPlayer(player: PlayListPlayer) {
        if let layer = self as? AVPlayerLayer {
            layer.player = player.engine()
        }
    }
}
