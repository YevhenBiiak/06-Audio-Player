//
//  Storage.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 01.07.2022.
//

import UIKit
import AVFoundation

class Storage {
    static func loadSongs() -> [Song] {
        var songList: [Song] = []
        // get song URLs from Bundle
        guard let songURLs = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {
            return []
        }
        for songURL in songURLs {
            var song = Song(artist: nil, track: nil, cover: nil, fileURL: songURL)
            let asset = AVAsset(url: songURL)
            for metaItem in asset.metadata {
                // take artist or set Unknown
                if let artist = metaItem.value as? String, metaItem.commonKey == .commonKeyArtist {
                    song.artist = artist.isEmpty ? "Unknown" : artist
                }
                // take title or song filename
                if let title = metaItem.value as? String, metaItem.commonKey == .commonKeyTitle {
                    song.track = title.isEmpty ? songURL.lastPathComponent.replacingOccurrences(of: "_", with: " ") : title
                }
                // take cover image if exsist
                if let data = metaItem.value as? Data, metaItem.commonKey == .commonKeyArtwork {
                    song.cover = UIImage(data: data)
                }
            }
            songList.append(song)
        }
        return songList
    }
}
