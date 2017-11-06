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
    func updateProgress(_ service: DownloadService, download: Download, totalBytesExpectedToWrite: Int64)
}

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService: NSObject {
    private var downloader: Downloader?

    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        //        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    var delegate: DownloadServiceDelegate?
    var activeDownloads = [URL: Download]()

    func startDownload(_ track: Track) {
        downloader = Downloader(session)
        var download = Download(track: track)
        download.task = downloader?.load(from: track.previewURL)
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
        download.task?.cancel()
        activeDownloads[track.previewURL] = nil
    }

    func resumeDownload(_ track: Track) {
        guard var download = activeDownloads[track.previewURL] else { return }
        if !download.isDownloading {
            downloader = Downloader(session)
            if let data = download.resumeData {
                download.task = downloader?.load(with: data)
            } else {
                download.task = downloader?.load(from: download.track.previewURL)
            }
            download.isDownloading = true
        }
    }

    // MARK: - Privates

    private func storedTrack(of download: Download, downloadedTo location: URL ) -> Bool {
        guard let sourceUrl = requestURL(of: download) else {
            return false
        }
        activeDownloads[sourceUrl] = nil
        let store = DownloadTaskStore(FileManager.default, from: sourceUrl, downloadingTo: location)

        return store.copy()
    }

    private func requestURL(of download: Download) -> URL? {
        guard let sourceUrl = download.task?.originalRequest?.url else {
            return .none
        }
        return sourceUrl
    }

}

extension DownloadService: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        if let error = downloadTask.error {
            print("could not download: \(error.localizedDescription)")
            return
        }
        print("Finished downloading")
        guard let url = downloadTask.originalRequest?.url,
            let download = activeDownloads[url]  else {
                return
        }
        print("TemporatyPath: \(location)")
        if storedTrack(of: download, downloadedTo: location) {
            delegate?.didFinish(self, download: download)
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        if let error = downloadTask.error {
            print("could not download: \(error.localizedDescription)")
            return
        }
        print("Downloading ... ")
        guard let requestURL = downloadTask.originalRequest?.url else {
            return
        }
        if var download = activeDownloads[requestURL], download.isDownloading {
            download.task = downloadTask
            download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            delegate?.updateProgress(self, download: download, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
    }

}
