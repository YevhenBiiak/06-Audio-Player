//
//  PlaylistViewController.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    let playlistView = PlaylistView()
    var audioPlayer = AudioPlayer.shared
    
    var songs: [Song] = [] {
        didSet {
            audioPlayer.songs = songs
            reloadPlaylistView()
        }
    }
    
    // MARK: - Life cycle and overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        
        songs = Storage.loadSongs()
        setupViews()
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    override func remoteControlReceived(with event: UIEvent?) {
        switch event?.subtype {
        case .remoteControlPlay:
            audioPlayer.play()
        case .remoteControlPause:
            audioPlayer.pause()
        case .remoteControlNextTrack:
            audioPlayer.next()
        case .remoteControlPreviousTrack:
            audioPlayer.previous()
        default: break
        }
    }
    
    // MARK: - Helper methods
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Music"
        
        view.addSubview(playlistView)
        setConstraints()
        
        audioPlayer.delegate = self
        playlistView.delegate = self
        playlistView.currentTrack = audioPlayer.currentTrack
        playlistView.playingTrackNumber = audioPlayer.trackNumber
    }
    
    private func setConstraints() {
        playlistView.translatesAutoresizingMaskIntoConstraints = false
        playlistView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        playlistView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playlistView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        playlistView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func reloadPlaylistView() {
        guard !songs.isEmpty else { return }
        playlistView.reload(withSongs: songs)
    }
}

// MARK: - AudioPlayerDelegate

extension PlaylistViewController: AudioPlayerDelegate {
    func audioPlayerDidStoppPlaying() {
        playlistView.isPlaying = false
    }

    func audioPlayerDidStartPlaying() {
        playlistView.isPlaying = true
    }

    func audioPlayerDidFinishPlaying() {
        audioPlayer.next()
        //audioPlayer.repeat()
    }
    
    func audioPlayerDidUpdateTrack() {
        playlistView.playingTrackNumber = audioPlayer.trackNumber
        playlistView.currentTrack = audioPlayer.currentTrack
    }
}

// MARK: - PlaylistViewDelegate

extension PlaylistViewController: PlaylistViewDelegate {
    func didSelectTrackAt(_ index: Int) {
        audioPlayer.play(index)
    }
    
    func didTapPlayPauseButton(_ button: UIButton) {
        audioPlayer.playPause()
    }
    
    func didTapNextTrackButton(_ button: UIButton) {
        audioPlayer.next()
    }
    
    func didTapPlayingNowView(_ view: UIView) {
        // present player vc
    }
}
