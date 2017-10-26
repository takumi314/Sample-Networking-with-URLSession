//
//  Track.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/23.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

struct Track {
    let name: String
    let artist: String
    let previewURL: URL
    var index: Int?

    var downloaded = false

    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name       = name
        self.artist     = artist
        self.previewURL = previewURL
        self.index      = index
    }

    private enum TrackKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case previewURL = "previewUrl"
    }
}

extension Track: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TrackKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(artist, forKey: .artist)
        try container.encode(previewURL, forKey: .previewURL)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TrackKeys.self)

        self.name = try values.decode(String.self, forKey: .name)
        self.artist = try values.decode(String.self, forKey: .artist)
        self.previewURL = try values.decode(URL.self, forKey: .previewURL)
    }
}

struct SearchResults {
    let results: [Track]

    init(_ results: [Track]) {
        self.results = results
    }
    enum ResultsKeys: String, CodingKey {
        case results = "results"
    }
}

extension SearchResults: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ResultsKeys.self)
        self.results = try values.decode([Track].self, forKey: .results)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ResultsKeys.self)
        try container.encode(results, forKey: .results)
    }

}
