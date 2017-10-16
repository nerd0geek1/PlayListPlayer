//
//  ViewController.swift
//  PlayListPlayerSample
//
//  Created by Kohei Tabata on 8/2/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import UIKit
import PlayListPlayer

class ViewController: UIViewController {

    @IBOutlet weak var movieRenderingView: MovieRenderingView!

    fileprivate let player: PlayListPlayer = PlayListPlayer.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlayer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        player.play()
    }

    // MARK: - private

    fileprivate func setupPlayer() {
        let url1: URL = Bundle.main.url(forResource: "sample_audio1", withExtension: "mp3")!
        let url2: URL = Bundle.main.url(forResource: "sample_audio2", withExtension: "mp3")!
        let url3: URL = Bundle.main.url(forResource: "sample_movie", withExtension: "mp4")!

        player.set(playList: [url1, url2, url3])
        movieRenderingView.set(player: player)
    }

    // MARK: - IBAction

    @IBAction
    func tapPrevious() {
        player.jumpToPreviousTrack()
    }

    @IBAction
    func tapPlay() {
        if player.isPlaying() {
            player.pause()
        } else {
            player.play()
        }
    }

    @IBAction
    func tapNext() {
        player.skipToNextTrack()
    }
}
