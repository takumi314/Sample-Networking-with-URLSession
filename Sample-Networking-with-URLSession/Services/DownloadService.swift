//
//  DownloadService.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/24.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

protocol DownloadServiceDelegate {
    func didFinish(_ service: DownloadService, download: Download)
}

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {

    private let downloader = Downloader(URLSession(configuration: URLSessionConfiguration.default))

    var delegate: DownloadServiceDelegate?
    var activeDownloads = [URL: Download]()

    func source(of download: Download) -> URL? {
        guard let sourceUrl = download.task?.originalRequest?.url else {
            return .none
        }
        return sourceUrl
    }

    func startDownload(_ track: Track) {
        var download = Download(track: track)
        download.task = downloader.load(from: track.previewURL, delegate: self) { [weak self] result in
            switch result {
            case .error(let error):
                print("could not download: \(error.localizedDescription)")
                return
            case .data(let location):
                do {
                    if let sourceUrl = self?.source(of: download) {
                        self?.activeDownloads[sourceUrl] = nil
                        let store = DownloadTaskStore(FileManager.default, from: sourceUrl, downloadingTo: location)
                        let destinationUrl = store.localPath(for: sourceUrl)

                        if store.copy(to: destinationUrl) {
                                download.track.downloaded = true

                                // 画面更新のために通知
                                self?.delegate?.didFinish(self!, download: download)
                        }
                    }
                }
                break
            }
        }
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
                download.task = downloader.load(with: data, delegate: self)
            } else {
                download.task = downloader.load(from: download.track.previewURL, delegate: self)
            }
            download.task!.resume()
            download.isDownloading = true
        }
    }

    private func stored(track: Track, at url: URL) -> Bool {
        return true
    }

}

extension DownloadService: DownloaderDelegate {
    func didFinish(downloader: Downloader, downloadTask: URLSessionDownloadTask, downloadingTo locaion: URL) {
        guard let sourceUrl = downloadTask.originalRequest?.url else {
            return
        }
        var download = activeDownloads[sourceUrl]
        activeDownloads[sourceUrl] = nil

        let store = DownloadTaskStore(FileManager.default, from: sourceUrl, downloadingTo: locaion)
        let destinationUrl = store.localPath(for: sourceUrl)
        print(destinationUrl)

        if store.copy(to: destinationUrl) {
            download?.track.downloaded = true

            // 画面更新のために通知
            delegate?.didFinish(self, download: download!)
        }
    }
    
}
