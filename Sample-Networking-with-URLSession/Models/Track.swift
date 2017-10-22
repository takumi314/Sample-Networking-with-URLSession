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
    let index: Int

    var downloaded = false

    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name       = name
        self.artist     = artist
        self.previewURL = previewURL
        self.index      = index
    }
}
