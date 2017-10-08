import AVFoundation

import Quick
import Nimble

class MovieRenderingViewSpec: QuickSpec {
    override func spec() {
        describe("MovieRenderingView") {
            it("will have AVPlayerLayer instance as layer", closure: {
                let layer: CALayer = MovieRenderingView().layer

                expect(layer is AVPlayerLayer).to(beTrue())
            })
            describe("setPlayer(player: PlayListPlayer)") {
                it("apply player to layer.player", closure: {
                    let view: MovieRenderingView = MovieRenderingView()
                    let player: PlayListPlayer   = PlayListPlayer()

                    view.set(player: player)

                    expect((view.layer as! AVPlayerLayer).player).to(equal(player.engine()))
                })
            }
        }
    }
}
