//
//  SongListViewController.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class SongListViewController: UIViewController {
    
    private let songListView = SongListView()
    private let playingNowView = PlayingNowView()
    
    var songList: [Song] = [] {
        didSet {
            updatePlayList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSongs()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Play list"
        
        setupSongListView()
        setupPlayingNowView()
    }
    
    private func setupSongListView() {
        view.addSubview(songListView)
        songListView.setConstraints()
        songListView.tapHandler = { [unowned self] i in
            playingNowView.song = songList[i]
        }
    }
    
    private func setupPlayingNowView() {
        view.addSubview(playingNowView)
        playingNowView.setConstraints()
        playingNowView.song = songList.first
//        playingNowView.tapHandler = {
//            let playerViewController = PlayerViewController()
//            playerViewController.song = song
//        }
    }
    
    private func updatePlayList() {
        songListView.songList = songList
    }
    
    private func loadSongs() {
        songList = Song.testSet
    }
}
