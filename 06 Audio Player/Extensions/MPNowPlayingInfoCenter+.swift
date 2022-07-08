//
//  MPNowPlayingInfoCenter+.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 08.07.2022.
//

import MediaPlayer

extension MPNowPlayingInfoCenter {
    static func update(withAudioPlayer audioPlayer: AudioPlayer) {
        let song = audioPlayer.currentSong!
        
        // update nowPlayingInfo in remote controle center
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
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
