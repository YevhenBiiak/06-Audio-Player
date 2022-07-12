//
//  Song.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit
import MediaPlayer

class Song {
    let url: URL
    lazy var title: String? = getString(byMetadataKey: .commonKeyTitle)
    lazy var artist: String? = getString(byMetadataKey: .commonKeyArtist)
    lazy var artwork: UIImage? = getImage(byMetadataKey: .commonKeyArtwork)
    
    init(url: URL) {
        self.url = url
    }
}

private extension Song {
    func getString(byMetadataKey key: AVMetadataKey) -> String? {
        getValue(byKey: key) as? String
    }
    
    func getImage(byMetadataKey key: AVMetadataKey) -> UIImage? {
        if let data = getValue(byKey: key) as? Data {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    func getValue(byKey key: AVMetadataKey) -> (NSCopying & NSObjectProtocol)? {
        let asset = AVAsset(url: url)
        let metadata = asset.commonMetadata
        let metadataItem = metadata.first { $0.commonKey == key }
        return metadataItem?.stringValue == "" ? nil : metadataItem?.value
    }
}
