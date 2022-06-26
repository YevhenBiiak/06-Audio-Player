//
//  Song.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

struct Song {
    static let testSet: [Song] = [
        Song(artist: "V $ X V PRiNCE", track: "Суета", cover: AppConstants.emptyCover),
        Song(artist: "Calvin Harris & Dua Lipa", track: "One Kiss", cover: AppConstants.emptyCover),
        Song(artist: "SHUMEI", track: "Біля тополі", cover: AppConstants.emptyCover),
        Song(artist: "YARMAK Feat. ALISA", track: "ДИКЕ ПОЛЕ", cover: AppConstants.emptyCover),
        Song(artist: "Pure N***a", track: "Cnv Sound, Vol. 14", cover: AppConstants.emptyCover),
        Song(artist: "Chico & Qatoshi", track: "Допоможе ЗСУ", cover: AppConstants.emptyCover),
        Song(artist: "Kate Bush", track: "Running Up That Hill (A Deal With God)", cover: AppConstants.emptyCover),
        Song(artist: "Chaos", track: "Rave", cover: AppConstants.emptyCover),
        Song(artist: "The Beatnuts Feat. Method Man", track: "Se Acabo Remix (Explicit)", cover: AppConstants.emptyCover),
        Song(artist: "V $ X V PRiNCE", track: "Суета", cover: AppConstants.emptyCover),
        Song(artist: "Calvin Harris & Dua Lipa", track: "One Kiss", cover: AppConstants.emptyCover),
        Song(artist: "SHUMEI", track: "Біля тополі", cover: AppConstants.emptyCover),
        Song(artist: "YARMAK Feat. ALISA", track: "ДИКЕ ПОЛЕ", cover: AppConstants.emptyCover),
        Song(artist: "Pure N***a", track: "Cnv Sound, Vol. 14", cover: AppConstants.emptyCover),
        Song(artist: "Chico & Qatoshi", track: "Допоможе ЗСУ", cover: AppConstants.emptyCover),
        Song(artist: "Kate Bush", track: "Running Up That Hill (A Deal With God)", cover: AppConstants.emptyCover),
        Song(artist: "Chaos", track: "Rave", cover: AppConstants.emptyCover),
        Song(artist: "The Beatnuts Feat. Method Man", track: "Se Acabo Remix (Explicit)", cover: AppConstants.emptyCover),
        Song(artist: "Ed Sheeran Feat. Antytila", track: "2step", cover: AppConstants.emptyCover)
    ]
    let artist: String
    let track: String
    let cover: UIImage?
    let fileURL: URL? = nil
}
