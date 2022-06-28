//
//  AudioPlayer.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 27.06.2022.
//

import AVFoundation

class AudioPlayer {
    
    private var player = AVAudioPlayer()
    private var songs: [Song]
    private var current: Int?
    
    var isPlaying: Bool { player.isPlaying }
    
    init(withSongs songs: [Song]) {
        self.songs = songs
        self.current = songs.isEmpty ? nil : 0
    }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        if player.prepareToPlay() {
            player.play()
        } else if let current = current {
            play(current)
        }
    }
    
    func play(_ index: Int) {
        current = index
        do {
            player = try AVAudioPlayer(contentsOf: songs[index].fileURL!)
            player.play()
        } catch {
            print(error)
        }
    }
    
    func next() {
        if let current = current {
            self.current = current + 1
            play(self.current!)
        }
    }
    
}
