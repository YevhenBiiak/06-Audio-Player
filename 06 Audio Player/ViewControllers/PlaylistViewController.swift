//
//  PlaylistViewController.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit
import MediaPlayer

class PlaylistViewController: UIViewController {
    
    lazy var playlistView = PlaylistView(delegate: self)
    lazy var audioPlayer = AudioPlayer()
    
    // MARK: - Life cycle and overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        audioPlayer.delegate = self
        audioPlayer.updatePlaylist(withSongs: Storage.loadSongs())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playlistView.playingSongNumber = audioPlayer.songNumber
        playlistView.currentSong = audioPlayer.currentSong
        playlistView.isPlaying = audioPlayer.isPlaying
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        switch event?.subtype {
        case .remoteControlPlay, .remoteControlPause:
            audioPlayer.playPause()
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
    }
    
    private func setConstraints() {
        playlistView.translatesAutoresizingMaskIntoConstraints = false
        playlistView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        playlistView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playlistView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        playlistView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - AudioPlayerDelegate

extension PlaylistViewController: AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeSong song: Song) {
        playlistView.update(withAudioPlayer: audioPlayer)
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeState isPlaying: Bool) {
        playlistView.isPlaying = isPlaying
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdatePlaylist songs: [Song]) {
        playlistView.updatePlaylist(with: songs)
    }
}

// MARK: - PlaylistViewDelegate

extension PlaylistViewController: PlaylistViewDelegate {
    func playlistView(_ playlistView: PlaylistView, didSelectSongAt index: Int) {
        audioPlayer.play(index)
    }
    func playlistView(_ playlistView: PlaylistView, didTapPlayPauseButton button: UIButton) {
        audioPlayer.playPause()
    }
    func playlistView(_ playlistView: PlaylistView, didTapNextSongButton button: UIButton) {
        audioPlayer.next()
    }
    func playlistView(_ playlistView: PlaylistView, didTapPlayingNowView view: UIView) {
        showPlayerViewController()
    }
    
    // helper methods
    private func showPlayerViewController() {
        let playerViewController = PlayerViewController(audioPlayer: audioPlayer)
        playerViewController.disappearHandler = { [unowned self] in
            audioPlayer.delegate = self
            // update view with current song and state
            playlistView.playingSongNumber = audioPlayer.songNumber
            playlistView.currentSong = audioPlayer.currentSong
            playlistView.isPlaying = audioPlayer.isPlaying
        }
        present(playerViewController, animated: true)
    }
}
