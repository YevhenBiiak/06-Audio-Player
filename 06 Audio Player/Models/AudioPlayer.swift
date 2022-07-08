//
//  AudioPlayer.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 27.06.2022.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeSong song: Song)
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeState isPlaying: Bool)
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdatePlaylist songs: [Song])
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangePlayMode playMode: PlayMode)
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateVolume volume: Float)
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateCurrentTime currentTime: TimeInterval)
}
// make optional methods
extension AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdatePlaylist songs: [Song]) {}
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangePlayMode playMode: PlayMode) {}
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateVolume volume: Float) {}
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateCurrentTime currentTime: TimeInterval) {}
}

enum PlayMode {case repeatPlaylist, repeatSong, shuffle, once}

class AudioPlayer: NSObject {
    
    weak var delegate: AudioPlayerDelegate?
    
    var volumeObserver: NSKeyValueObservation!
    
    private var player = AVAudioPlayer()
    private var playMode: PlayMode = .repeatPlaylist
    private var songs: [Song]?
    
    var currentSong: Song? { songs?.first { player.url == $0.url }}
    var songNumber: Int? { songs?.firstIndex { player.url == $0.url }}
    var currentTime: TimeInterval { player.currentTime }
    var duration: TimeInterval { player.duration }
    var isPlaying: Bool { player.isPlaying }
    var volume: Float { AVAudioSession.sharedInstance().outputVolume }
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        volumeObserver = AVAudioSession.sharedInstance().observe(\.outputVolume, options: .new) { [unowned self] _, _ in
            delegate?.audioPlayer(self, didUpdateVolume: AVAudioSession.sharedInstance().outputVolume)
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] _ in
            delegate?.audioPlayer(self, didUpdateCurrentTime: currentTime)
        }
    }

    // MARK: - Behavior Methods
    func play() {
        player.play()
        delegate?.audioPlayer(self, didChangeState: isPlaying)
    }
    
    func pause() {
        player.pause()
        delegate?.audioPlayer(self, didChangeState: isPlaying)
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func next() {
        if let number = songNumber {
            let newNumber = number + 1 >= songs!.count ? 0 : number + 1
            updatePlayer(withSong: songs?[newNumber])
        }
    }
    
    func previous() {
        if let number = songNumber {
            let newNumber = number - 1 < 0 ? songs!.count - 1 : number - 1
             updatePlayer(withSong: songs?[newNumber])
        }
    }
    
    func play(_ number: Int) {
        if number == songNumber {
            playPause()
        } else {
            updatePlayer(withSong: songs?[number])
            play()
        }
    }
    
    // MARK: - Helper methods
    
    private func updatePlayer(withSong song: Song?) {
        let playingState = isPlaying
        if let song = song {
            player = try! AVAudioPlayer(contentsOf: song.url)
        } else {
            player = AVAudioPlayer()
        }
        setupPlayer()
        if playingState { play() }
    }
    
    private func setupPlayer() {
        player.delegate = self
        delegate?.audioPlayer(self, didChangeSong: currentSong!)
    }
    
    // MARK: - Updating methods
    
    func setVolume(_ volume: Float) {
        MPVolumeView.setVolume(volume)
    }
    
    func setCurrentTime(_ time: TimeInterval) {
        player.currentTime = time
    }
    
    func setPlayMode(_ mode: PlayMode) {
        playMode = mode
        delegate?.audioPlayer(self, didChangePlayMode: mode)
    }
    
    func updatePlaylist(withSongs songs: [Song]) {
        self.songs = songs
        delegate?.audioPlayer(self, didUpdatePlaylist: songs)
        if songs.isEmpty {
            updatePlayer(withSong: nil)
        } else if songs.contains(where: { $0.url == currentSong?.url }) {
            updatePlayer(withSong: currentSong)
        } else {
            updatePlayer(withSong: songs.first)
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switch playMode {
        case .repeatPlaylist:
            next()
            play()
        case .repeatSong:
            play()
        case .shuffle:
            updatePlayer(withSong: songs?.randomElement())
            play()
        case .once:
            break
        }
    }
}
