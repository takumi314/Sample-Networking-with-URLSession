//
//  Download.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/23.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

struct Download {

    var track: Track
    init(track: Track) {
        self.track = track
    }

    // provided by Downloader
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?

    // provided by Downloader delegate
    var progress: Float = 0
}
