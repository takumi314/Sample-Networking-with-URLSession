//
//  DownloadTaskStore.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/11/01.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

class DownloadTaskStore {

    private let manager: FileManager

    ///
    /// API request URL
    ///
    private let sourceURL: URL

    ///
    /// A temporary path in which the track will be
    ///
    private let tempPath: URL

    ///
    /// Finally, a path in which the track will be stored
    ///
    private var destinationPath: URL?

    init(_ manager: FileManager,from sourceURL: URL , downloadingTo tempPath: URL) {
        self.manager = manager
        self.sourceURL = sourceURL
        self.tempPath = tempPath
        self.destinationPath = localPath(for: sourceURL)
    }

    ///
    /// Copy download task in Temp into DocumentDirectory
    ///
    func copy() -> Bool {
        guard let dest = destinationPath else {
            return false
        }
        print("DestinationPath: \(dest)")
        return copy(to: dest)
    }

    func copy(to url: URL) -> Bool {
        return copy(at: tempPath, to: url)
    }

    private func copy(at source: URL, to destination: URL) -> Bool {
        guard clearPath(as: destination) || isAvailablePath(url: destination) else {
            return false
        }
        do {
            try manager.copyItem(at: source, to: destination)
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
            return false
        }
        return true
    }

    ///
    /// Download Task stores here
    ///
    func localPath(for url: URL) -> URL {
        let documentPath = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentPath.appendingPathComponent(url.lastPathComponent)
    }

    private func isAvailablePath(url: URL) -> Bool {
        return !manager.fileExists(atPath: url.absoluteString)
    }

    private func clearPath(as url: URL) -> Bool {
        do {
            try manager.removeItem(at: url)
        } catch let error {
            print("Could not remove file from disk: \(error.localizedDescription)")
            return false
        }
        return true
    }

}
