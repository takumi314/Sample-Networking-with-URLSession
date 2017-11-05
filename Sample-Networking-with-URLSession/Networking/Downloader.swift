//
//  Downloader.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

protocol DownloaderDelegate {
    func didFinish(downloader: Downloader, downloadTask: URLSessionDownloadTask, downloadingTo  locaion: URL)
}

class Downloader: NSObject {

    enum Result: Equatable {
        case data(URL)
        case error(Error)

        static func ==(lhs: Result, rhs: Result) -> Bool {
            switch (lhs, rhs) {
            case (.data, .data):
                return true
            case (.error, .error):
                return true
            default:
                return false
            }
        }
    }

    private let engine: NetworkEngine

    init(_ engine: NetworkEngine) {
        self.engine = engine
    }

    func load(from url: URL, delegate: DownloaderDelegate?, completionHadler: @escaping (Result) -> Void) -> URLSessionDownloadTask {
        print("RequestURL: \(url)")
        return engine.performDownload(for: url) { (url, response, error) in
            if let error = error {
                return completionHadler(.error(error))
            }
            // コピー元のURL
            guard let url = url else {
                let error = CocoaError.error(.fileReadUnknown, userInfo: nil, url: nil)
                return completionHadler(.error(error))
            }
            completionHadler(.data(url))
        }
    }

    func load(with resumeData: Data) -> URLSessionDownloadTask {
        return engine.performDownload(with: resumeData)
    }
    func load(from url: URL) -> URLSessionDownloadTask {
        print("RequestURL: \(url)")
        return engine.performDownload(with: url)
    }

}

