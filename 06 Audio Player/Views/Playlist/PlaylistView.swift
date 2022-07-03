//
//  PlaylistView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 02.07.2022.
//

import UIKit

protocol PlaylistViewDelegate: AnyObject {
    func didSelectTrackAt(_ index: Int)
    func didTapPlayPauseButton(_ button: UIButton)
    func didTapNextTrackButton(_ button: UIButton)
    func didTapPlayingNowView(_ view: UIView)
}

class PlaylistView: UIView {
    
    // MARK: - Subviews
    
    private let songScrollView = SongScrollView()
    private let playingNowView = PlayingNowView()
    
    // MARK: - Properties
    
    var playingTrackNumber: Int? {
        didSet {
            songScrollView.playingTrackNumber = playingTrackNumber
        }
    }
    
    var currentTrack: Song! {
        didSet {
            playingNowView.song = currentTrack
        }
    }
    
    var isPlaying: Bool = false {
        didSet {
            playingNowView.isPlaying = isPlaying
        }
    }
    
    weak var delegate: PlaylistViewDelegate?
    
    // MARK: - Initializers and overridden methods
    
    init() {
        super.init(frame: .zero)
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
            delegate?.didTapPlayPauseButton(playingNowView.playPauseButton)
        }, for: .touchUpInside)
        
        // add action to nextTrackButton
        playingNowView.nextTrackButton.addAction( UIAction { [unowned self] _ in
            delegate?.didTapNextTrackButton(playingNowView.nextTrackButton)
        }, for: .touchUpInside )
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(playingNowDidTap(gesture:)))
        playingNowView.addGestureRecognizer(tap)
    }
    
    @objc private func playingNowDidTap(gesture: UITapGestureRecognizer) {
        delegate?.didTapPlayingNowView(playingNowView)
    }
    
    // MARK: - Configuration methods
    
    func reload(withSongs songs: [Song]) {
        songScrollView.reload(withSongs: songs)
        addTapGestures()
    }
    
    private func addTapGestures() {
        guard let songItemViews = songScrollView.stackView.arrangedSubviews as? [SongItemView] else {
            return
        }
        for (i, view) in songItemViews.enumerated() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(trackDidSelect(gesture:)))
            view.addGestureRecognizer(tap)
            view.tag = i
        }
    }
    
    @objc private func trackDidSelect(gesture: UITapGestureRecognizer) {
        let index = gesture.view!.tag
        delegate?.didSelectTrackAt(index)
    }
}
