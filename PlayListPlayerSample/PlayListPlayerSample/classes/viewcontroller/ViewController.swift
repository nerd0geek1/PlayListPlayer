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

    private let player: PlayListPlayer = PlayListPlayer.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlayer()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        player.play()
    }

    //MARK: - private

    private func setupPlayer() {
        let url1: NSURL = NSBundle.mainBundle().URLForResource("sample_audio1", withExtension: "mp3")!
        let url2: NSURL = NSBundle.mainBundle().URLForResource("sample_audio2", withExtension: "mp3")!
        let url3: NSURL = NSBundle.mainBundle().URLForResource("sample_movie", withExtension: "mp4")!

        player.setPlayList([url1, url2, url3])
        movieRenderingView.setPlayer(player)
    }

    //MARK: - IBAction

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
