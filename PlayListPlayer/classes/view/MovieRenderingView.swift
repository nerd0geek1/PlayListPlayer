//
//  MovieRenderingView.swift
//  PlayListPlayer
//
//  Created by Kohei Tabata on 8/2/16.
//  Copyright © 2016 nerd0geek1. All rights reserved.
//

import AVFoundation
import UIKit

public class MovieRenderingView: UIView {
    override public func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
    }

    override public class func layerClass () -> AnyClass {
        return AVPlayerLayer.self
    }

    // MARK: - public

    public func setPlayer(player: PlayListPlayer) {
        layer.setPlayer(player)
    }
}
