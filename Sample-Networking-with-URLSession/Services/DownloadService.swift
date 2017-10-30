//
//  DownloadService.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/24.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {

    private let downloader = Downloader(URLSession())

    var activeDownloads = [URL: Download]()

    func startDownload(_ track: Track) {
        var download = Download(track: track)
        download.task = downloader.load(from: track.previewURL) { print($0) }
        download.isDownloading = true
        activeDownloads[download.track.previewURL] = download
    }

    func pauseDownload(_ track: Track) {
        guard var download = activeDownloads[track.previewURL] else { return }
        if download.isDownloading {
            download.task?.cancel { data in
                download.resumeData = data
            }
            download.isDownloading = false
        }
    }

    func cancelDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        if download.isDownloading {
            download.task?.cancel()
            activeDownloads[track.previewURL] = nil
        }
    }

    func resumeDownload(_ track: Track) {
        guard var download = activeDownloads[track.previewURL] else { return }
        if !download.isDownloading {
            if let data = download.resumeData {
                download.task = downloader.load(with: data)
            } else {
                download.task = downloader.load(from: download.track.previewURL)
            }
            download.task!.resume()
            download.isDownloading = true
        }
    }

}
