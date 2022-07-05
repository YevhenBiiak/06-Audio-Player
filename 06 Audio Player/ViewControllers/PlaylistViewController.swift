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
    lazy var audioPlayer = AudioPlayer(delegate: self)
    
    var songs: [Song] = [] {
        didSet {
            playlistView.update(withSongs: songs)
            audioPlayer.updatePlaylist(withSongs: songs)
        }
    }
    
    // MARK: - Life cycle and overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.becomeFirstResponder()
        
        setupViews()
        songs = Storage.loadSongs()
    }
    
//    override var canBecomeFirstResponder: Bool {
//        true
//    }
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
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeState isPlaying: Bool) {
        playlistView.isPlaying = isPlaying
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didFinishPlaying flag: Bool) {
        audioPlayer.next()
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateSongWith song: Song) {
        playlistView.playingSongNumber = audioPlayer.songNumber
        playlistView.currentSong = song
        updateNowPlayingInfo(withSong: song)
    }
    
    private func updateNowPlayingInfo(withSong song: Song) {
        let title = song.title ?? song.url.lastPathComponent.replacingOccurrences(of: "_", with: " ")
        let artist = song.artist ?? "Unknown"
        let artwork = { () -> MPMediaItemArtwork? in
            guard let art = song.artwork else { return nil }
            return MPMediaItemArtwork(boundsSize: CGSize.init(width: 1, height: 1)) { _ in art }
        }()
        
        var nowPlayingInfo: [String: Any] = [:]
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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
        // present player vc
    }
}
