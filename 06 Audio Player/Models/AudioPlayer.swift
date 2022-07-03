//
//  AudioPlayer.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 27.06.2022.
//

import Foundation
import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayerDidStoppPlaying()
    func audioPlayerDidStartPlaying()
    func audioPlayerDidFinishPlaying()
    func audioPlayerDidUpdateTrack()
}

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    static var shared = AudioPlayer()
    private var player = AVAudioPlayer()
    weak var delegate: AudioPlayerDelegate?
    
    var trackNumber: Int?
    var currentTrack: Song? {
        trackNumber == nil ? nil : songs[trackNumber!]
    }
    
    var songs: [Song] = [] {
        didSet {
            trackNumber = songs.isEmpty ? nil : 0
            updatePlayer(withTrack: currentTrack)
        }
    }
    
    private override init() {
        super.init()
    }

    // MARK: - Methods
    
    func pause() {
        player.pause()
        delegate?.audioPlayerDidStoppPlaying()
    }
    
    func play() {
        player.play()
        delegate?.audioPlayerDidStartPlaying()
    }
    
    func playPause() {
        if player.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func next() {
        if let current = trackNumber {
            let newTrackNumber = current + 1 >= songs.count ? 0 : current + 1
            play(newTrackNumber)
        }
    }
    
    func previous() {
        if let current = trackNumber {
            let newTrackNumber = current - 1 < 0 ? songs.count - 1 : current - 1
            play(newTrackNumber)
        }
    }
    
    func play(_ index: Int) {
        if index == trackNumber {
            playPause()
        } else {
            trackNumber = index
            updatePlayer(withTrack: currentTrack)
            play()
        }
    }
    
    private func updatePlayer(withTrack track: Song?) {
        guard let url = track?.fileURL else {
            print("song is nil")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            delegate?.audioPlayerDidUpdateTrack()
        } catch {
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.audioPlayerDidFinishPlaying()
    }
}
