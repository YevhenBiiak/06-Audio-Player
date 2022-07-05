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
        guard let songURLs = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {
            return []
        }
        return songURLs.map { url in
            Song(url: url)
        }
    }
}
