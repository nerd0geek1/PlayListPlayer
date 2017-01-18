//
//  CALayerExtensionSpec.swift
//  PlayListPlayer
//
//  Created by Kohei Tabata on 8/2/16.
//  Copyright © 2016 nerd0geek1. All rights reserved.
//

import AVFoundation
import Quick
import Nimble

class CALayerExtensionSpec: QuickSpec {
    override func spec() {
        describe("CALayer extension") {
            describe("for AVPlayer", {
                describe("setPlayer(player: PlayListPlayer)", {
                    context("with AVPlayerLayer class instance", {
                        it("assign PlayListPlayer.engine() as layer.player", closure: {
                            let layer: AVPlayerLayer   = AVPlayerLayer()
                            let player: PlayListPlayer = PlayListPlayer()

                            layer.set(player: player)

                            expect(layer.player).notTo(beNil())
                            expect(layer.player).to(equal(player.engine()))
                        })
                    })
                })
            })
        }
    }
}
