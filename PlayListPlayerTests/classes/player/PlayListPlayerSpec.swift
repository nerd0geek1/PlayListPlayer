import AVFoundation
import Quick
import Nimble

class PlayListPlayerSpec: QuickSpec {
    override func spec() {
        describe("PlayListPlayer") {
            let urls: [URL] = [FileHelper.audio1URL(),
                               FileHelper.audio2URL(),
                               FileHelper.movie1URL()]

            describe("set(playList: [URL])", {
                it("will update playListURLs", closure: {
                    let player: PlayListPlayer = PlayListPlayer()

                    player.set(playList: urls)

                    expect(player.hasPlayList()).to(beTrue())
                    expect(player.playList     ).to(equal(urls))
                })
            })
            describe("set(currentIndex: Int)", {
                var player: PlayListPlayer!
                beforeEach {
                    player = PlayListPlayer()
                    player.set(playList: urls)
                }
                context("when index is within playList index range", {
                    it("will return true, update current index", closure: {
                        expect(player.currentIndex).to(equal(0))

                        let index: Int   = 2
                        let result: Bool = player.set(currentIndex: index)

                        expect(result             ).to(beTrue())
                        expect(player.currentIndex).to(equal(index))
                    })
                })
                context("when index is beyond playList index range", {
                    it("will return false, don't update current index", closure: {
                        expect(player.currentIndex).to(equal(0))

                        let result: Bool = player.set(currentIndex: 3)

                        expect(result             ).to(beFalse())
                        expect(player.currentIndex).to(equal(0))
                    })
                })
            })

            describe("engine()", {
                it("will return AVPlayer instance", closure: {
                    let player: PlayListPlayer = PlayListPlayer()

                    expect(player.engine().currentItem).to(beNil())
                    expect(player.engine().rate       ).to(equal(0.0))
                })
            })

            describe("hasPlayList()", {
                context("when playList was set", {
                    it("will return true", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)

                        expect(player.hasPlayList()).to(beTrue())
                    })
                })
                context("when playList wasn't set", {
                    it("will return false", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        expect(player.hasPlayList()).to(beFalse())
                    })
                })
            })

            describe("currentTrackURL()", {
                context("playList was set", {
                    it("will return current track url", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)

                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
                context("playList wasn't set", {
                    it("will return nil", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        expect(player.currentTrackURL()).to(beNil())
                    })
                })
            })

            describe("isPlaying()", {
                context("when playList is empty", {
                    it("will return false", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
                context("when playList was set", {
                    var player: PlayListPlayer!
                    beforeEach {
                        player = PlayListPlayer()
                        player.set(playList: urls)
                    }

                    context(", then", {
                        it("will return false", closure: {
                            expect(player.isPlaying()).to(beFalse())
                        })
                    })
                    context(", and called play()", {
                        it("will return true", closure: {
                            player.play()

                            expect(player.isPlaying()).to(beTrue())
                        })
                    })
                    context(", and called beginFastForwarding()", {
                        it("will return true", closure: {
                            player.beginFastForwarding()

                            expect(player.isPlaying()).to(beTrue())
                        })
                    })
                    context(", and called pause()", {
                        it("will return false", closure: {
                            player.play()
                            player.pause()

                            expect(player.isPlaying()).to(beFalse())
                        })
                    })
                    context(", and called beginRewinding()", {
                        it("will return true", closure: {
                            player.beginRewinding()

                            expect(player.isPlaying()).to(beTrue())
                        })
                    })
                })
            })

            describe("play()", {
                context("when playList was set", {
                    it("will make rate 1.0, currentTrackURL() audio1URL()", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)
                        player.play()

                        expect(player.engine().rate    ).to(equal(1.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
            })

            describe("pause()", {
                context("when playList was set", {
                    it("will make rate 0.0, currentTrackURL() audio1URL()", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)
                        player.play()

                        expect(player.engine().rate).to(equal(1.0))

                        player.pause()

                        expect(player.engine().rate    ).to(equal(0.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
            })

            describe("beginFastForwarding()", {
                context("when playList was set", {
                    it("will make rate 2.0, currentTrackURL() audio1URL()", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)
                        player.beginFastForwarding()

                        expect(player.engine().rate    ).to(equal(2.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
            })

            describe("endFastForwarding()", {
                context("when playList was set", {
                    it("will make rate 1.0, currentTrackURL() audio1URL()", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)
                        player.endFastForwarding()

                        expect(player.engine().rate    ).to(equal(1.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
            })

            describe("skipToNextTrack()", {
                context("when playList was set,", {
                    var player: PlayListPlayer!
                    beforeEach {
                        player = PlayListPlayer()
                        player.set(playList: urls)
                    }

                    context("playMode is RepeatPlayList", {
                        context("and currentIndex is last index", {
                            it("will play first track from the beginning of it", closure: {
                                player.playMode = .repeatPlayList

                                player.set(currentIndex: 2)
                                player.play()

                                player.skipToNextTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(0))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                        context("and currentIndex is not last index", {
                            it("will play next track", closure: {
                                player.playMode = .repeatPlayList

                                player.play()
                                player.skipToNextTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(1))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                    })
                    context("playMode is RepeatItem", {
                        context("and currentIndex is last index", {
                            it("will play current track from the beginning of it", closure: {
                                player.playMode = .repeatItem

                                player.set(currentIndex: 2)
                                player.play()

                                player.skipToNextTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(2))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                        context("and currentIndex is not last index", {
                            it("will play current track from the beginning of it", closure: {
                                player.playMode = .repeatItem

                                player.play()

                                player.skipToNextTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(0))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                    })
                    context("playMode is NoRepeat", {
                        context("and currentIndex is last index", {
                            it("will pause at the beginning of first track", closure: {
                                player.playMode = .noRepeat

                                player.set(currentIndex: 2)
                                player.play()

                                player.skipToNextTrack()

                                expect(player.isPlaying()           ).to(beFalse())
                                expect(player.currentIndex          ).to(equal(0))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                        context("and currentIndex is not last index", {
                            it("will play next track", closure: {
                                player.playMode = .noRepeat

                                player.play()
                                
                                player.skipToNextTrack()
                                
                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(1))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                    })
                })
            })

            describe("beginRewinding()", {
                context("when playList was set", {
                    it("will make rate -2.0, currentTrackURL() audio1URL()", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)
                        player.beginRewinding()

                        expect(player.engine().rate    ).to(equal(-2.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
            })

            describe("endRewinding()", {
                context("when playList was set", {
                    it("will make rate 1.0, currentTrackURL() audio1URL()", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)
                        player.endRewinding()

                        expect(player.engine().rate    ).to(equal(1.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
            })

            describe("jumpToPreviousTrack()", {
                context("when playList was set,", {
                    var player: PlayListPlayer!
                    beforeEach {
                        player = PlayListPlayer()
                        player.set(playList: urls)
                    }

                    context("playMode is RepeatPlayList", {
                        context("and currentIndex is 0", {
                            it("will play first track from the beginning of it", closure: {
                                player.playMode = .repeatPlayList

                                player.play()

                                player.jumpToPreviousTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(0))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                        context("and currentIndex is not 0", {
                            it("will play previous track", closure: {
                                player.playMode = .repeatPlayList

                                player.play()
                                player.skipToNextTrack()

                                expect(player.currentIndex).to(equal(1))

                                player.jumpToPreviousTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(0))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                    })
                    context("playMode is RepeatItem", {
                        context("and currentIndex is 0", {
                            it("will play current track from the beginning of it", closure: {
                                player.playMode = .repeatItem

                                player.play()

                                player.jumpToPreviousTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(0))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                        context("and currentIndex is not 0", {
                            it("will play current track from the beginning of it", closure: {
                                player.playMode = .repeatItem

                                player.set(currentIndex: 1)
                                player.play()

                                expect(player.currentIndex).to(equal(1))

                                player.jumpToPreviousTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(1))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                    })
                    context("playMode is NoRepeat", {
                        context("and currentIndex is 0", {
                            it("will play first track from the beginning of it", closure: {
                                player.playMode = .noRepeat

                                player.play()

                                player.jumpToPreviousTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(0))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                        context("and currentIndex is not 0", {
                            it("will play previous track", closure: {

                                player.playMode = .noRepeat
                                player.play()
                                player.skipToNextTrack()

                                expect(player.currentIndex).to(equal(1))

                                player.jumpToPreviousTrack()

                                expect(player.isPlaying()           ).to(beTrue())
                                expect(player.currentIndex          ).to(equal(0))
                                expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            })
                        })
                    })
                })
            })

            describe("seekToBeginning()", {
                context("when playList was set", {
                    it("will make engine().currentItem?.currentTime() kCMTimeZero", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.set(playList: urls)
                        player.seek(to: 0.5)

                        expect(player.engine().currentItem?.currentTime()).notTo(equal(kCMTimeZero))

                        player.seekToBeginning()

                        expect(player.engine().currentItem?.currentTime()).to(equal(kCMTimeZero))
                    })
                })
            })

            describe("seekTo(position: Float)", {
                context("when playList was set", {
                    it("will update engine().currentItem?.currentTime() expected value", closure: {
                        let player: PlayListPlayer = PlayListPlayer()
                        let position: Float        = 0.5

                        player.set(playList: urls)
                        player.seek(to: position)

                        let currentTime: Float   = Float(player.engine().currentTime().value)
                        let duration: Float      = Float(player.engine().currentItem!.asset.duration.value)
                        let expectedValue: Float = duration * position

                        expect(currentTime).notTo(equal(0))
                        expect(currentTime).to(equal(expectedValue))
                    })
                })
            })
        }
    }
}
