//
//  AudioPlayer.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 27.06.2022.
//

import Foundation
import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeState isPlaying: Bool)
    func audioPlayer(_ audioPlayer: AudioPlayer, didFinishPlaying flag: Bool)
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateSongWith song: Song)
}

class AudioPlayer: NSObject {
//    static var shared = AudioPlayer()
    private var player = AVAudioPlayer()
    weak var delegate: AudioPlayerDelegate?
    
    var songs: [Song]?
    var songNumber: Int?
    var currentSong: Song? {
        songNumber == nil ? nil : songs?[songNumber!]
    }
    
    // MARK: - Inizializers
    
    init(delegate: AudioPlayerDelegate) {
        self.delegate = delegate
    }

    // MARK: - Methods
    
    func pause() {
        player.pause()
        delegate?.audioPlayer(self, didChangeState: player.isPlaying)
    }
    
    func play() {
        player.play()
        delegate?.audioPlayer(self, didChangeState: player.isPlaying)
    }
    
    func playPause() {
        if player.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func next() {
        if let current = songNumber {
            let newSongNumber = current + 1 >= songs!.count ? 0 : current + 1
            play(newSongNumber)
        }
    }
    
    func previous() {
        if let current = songNumber {
            let newSongNumber = current - 1 < 0 ? songs!.count - 1 : current - 1
            play(newSongNumber)
        }
    }
    
    func play(_ index: Int) {
        if index == songNumber {
            playPause()
        } else {
            songNumber = index
            updatePlayer(withSong: currentSong)
            play()
        }
    }
    
    private func updatePlayer(withSong song: Song?) {
        guard let url = song?.url else {
            print("songs is nil")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            delegate?.audioPlayer(self, didUpdateSongWith: song!)
        } catch {
            print(error)
        }
    }
    
    func updatePlaylist(withSongs songs: [Song]) {
        self.songs = songs
        songNumber = songs.isEmpty == true ? nil : 0
        updatePlayer(withSong: currentSong)
    }
    
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.audioPlayer(self, didFinishPlaying: flag)
    }
}
