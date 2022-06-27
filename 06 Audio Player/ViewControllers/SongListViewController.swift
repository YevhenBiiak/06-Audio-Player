//
//  SongListViewController.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit
import AVFoundation

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
        // get song URLs from Bundle
        guard let songURLs = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {
            return
        }
        for songURL in songURLs {
            var song = Song(artist: nil, track: nil, cover: nil, fileURL: songURL)
            let asset = AVAsset(url: songURL)
            for metaItem in asset.metadata {
                // take artist or set Unknown
                if let artist = metaItem.value as? String, metaItem.commonKey == .commonKeyArtist {
                    song.artist = artist.isEmpty ? "Unknown" : artist
                }
                // take title or song filename
                if let title = metaItem.value as? String, metaItem.commonKey == .commonKeyTitle {
                    song.track = title.isEmpty ? songURL.lastPathComponent.replacingOccurrences(of: "_", with: " ") : title
                }
                // take cover image if exsist
                if let data = metaItem.value as? Data, metaItem.commonKey == .commonKeyArtwork {
                    song.cover = UIImage(data: data)
                }
            }
            songList.append(song)
        }
    }
}
