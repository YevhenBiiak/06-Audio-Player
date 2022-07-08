//
//  PlaylistView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 02.07.2022.
//

import UIKit
import MediaPlayer

protocol PlaylistViewDelegate: AnyObject {
    func playlistView(_ playlistView: PlaylistView, didSelectSongAt index: Int)
    func playlistView(_ playlistView: PlaylistView, didTapPlayPauseButton button: UIButton)
    func playlistView(_ playlistView: PlaylistView, didTapNextSongButton button: UIButton)
    func playlistView(_ playlistView: PlaylistView, didTapPlayingNowView view: UIView)
}

class PlaylistView: UIView {
    
    // MARK: - Subviews
    
    private let songScrollView = SongScrollView()
    private let playingNowView = PlayingNowView()
    
    // MARK: - Properties
    
    var playingSongNumber: Int? {
        didSet {
            songScrollView.playingSongNumber = playingSongNumber
        }
    }
    
    var currentSong: Song? {
        didSet {
            playingNowView.song = currentSong
        }
    }
    
    var isPlaying: Bool = false {
        didSet {
            playingNowView.isPlaying = isPlaying
        }
    }
    
    weak var delegate: PlaylistViewDelegate?
    
    // MARK: - Initializers and overridden methods
    
    init(delegate: PlaylistViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper initialization methods
    
    private func setupViews() {
        // setup songScrollView
        self.addSubview(songScrollView)
        songScrollView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(H: "|[songScrollView]|", V: "|[songScrollView]|")
        
        // setup playingNowView
        self.addSubview(playingNowView)
        playingNowView.translatesAutoresizingMaskIntoConstraints = false
        playingNowView.topAnchor.constraint(equalTo: safeBottomAnchor, constant: -AppConstants.playingNowHeight).isActive = true
        playingNowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        playingNowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        playingNowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // setup actions
        addButtonActions()
        addTapGesture()
    }

    private func addButtonActions() {
        // add action to playPauseButton
        playingNowView.playPauseButton.addAction(UIAction { [unowned self] _ in
            delegate?.playlistView(self, didTapPlayPauseButton: playingNowView.playPauseButton)
        }, for: .touchUpInside)
        
        // add action to nextSongButton
        playingNowView.nextSongButton.addAction( UIAction { [unowned self] _ in
            delegate?.playlistView(self, didTapNextSongButton: playingNowView.nextSongButton)
        }, for: .touchUpInside )
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(playingNowDidTap(gesture:)))
        playingNowView.addGestureRecognizer(tap)
    }
    
    @objc private func playingNowDidTap(gesture: UITapGestureRecognizer) {
        delegate?.playlistView(self, didTapPlayingNowView: playingNowView)
    }
    
    // MARK: - Updating methods
    
    func update(withAudioPlayer audioPlayer: AudioPlayer) {
        let song = audioPlayer.currentSong!
        
        songScrollView.playingSongNumber = audioPlayer.songNumber
        playingNowView.song = song
        
        MPNowPlayingInfoCenter.update(withAudioPlayer: audioPlayer)
    }
    
    func updatePlaylist(with songs: [Song]) {
        songScrollView.reload(withSongs: songs)
        addTapGestures()
    }
    
    private func addTapGestures() {
        guard let songItemViews = songScrollView.stackView.arrangedSubviews as? [SongItemView] else {
            return
        }
        for (i, view) in songItemViews.enumerated() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(songDidSelect(gesture:)))
            view.addGestureRecognizer(tap)
            view.tag = i
        }
    }
    
    @objc private func songDidSelect(gesture: UITapGestureRecognizer) {
        let index = gesture.view!.tag
        delegate?.playlistView(self, didSelectSongAt: index)
    }
}
