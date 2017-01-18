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
    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }

    override public class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    // MARK: - public

    public func set(player: PlayListPlayer) {
        layer.set(player: player)
    }
}
