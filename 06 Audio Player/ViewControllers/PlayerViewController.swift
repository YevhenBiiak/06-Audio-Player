//
//  PlayerViewController.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private lazy var playerView = PlayerView(delegate: self)
    private var audioPlayer: AudioPlayer!
    
    var disappearHandler: (() -> Void)?
    
    // MARK: - Life cycle and override methods
    
    init(audioPlayer: AudioPlayer) {
        super.init(nibName: nil, bundle: nil)
        self.audioPlayer = audioPlayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.audioPlayer.delegate = self
        
        playerView.isPlaying = audioPlayer.isPlaying
        playerView.updatePlayMode(audioPlayer.playMode)
        playerView.updateSongView(with: audioPlayer)
        playerView.updateCurrentTime(audioPlayer.currentTime)
        playerView.updateVolume(audioPlayer.volume)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disappearHandler?()
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
    
    // MARK: - Helper setup methods
    
    private func setupViews() {
        view.addSubview(playerView)
        playerView.frame = UIScreen.main.bounds
    }
}

extension PlayerViewController: AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeSong song: Song) {
        playerView.updateSongView(with: audioPlayer)
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeState isPlaying: Bool) {
        playerView.isPlaying = isPlaying
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangePlayMode playMode: PlayMode) {
        playerView.updatePlayMode(playMode)
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateVolume volume: Float) {
        playerView.updateVolume(volume)
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateCurrentTime currentTime: TimeInterval) {
        playerView.updateCurrentTime(currentTime)
    }
}

extension PlayerViewController: PlayerViewDelegate {
    func playerView(_ playerView: PlayerView, didTapPlayModeButton button: UIButton) {
        audioPlayer.changePlayMode()
    }
    func playerView(_ playerView: PlayerView, didTapPreviousButton button: UIButton) {
        audioPlayer.previous()
    }
    func playerView(_ playerView: PlayerView, didTapPlayPauseButton button: UIButton) {
        audioPlayer.playPause()
    }
    func playerView(_ playerView: PlayerView, didTapNextButton button: UIButton) {
        audioPlayer.next()
    }
    func playerView(_ playerView: PlayerView, didChangeSeekSlider slider: UISlider) {
        audioPlayer.setCurrentTime(TimeInterval(slider.value))
    }
    func playerView(_ playerView: PlayerView, didChangeVolumeSlider slider: UISlider) {
        audioPlayer.setVolume(slider.value)
    }
}
