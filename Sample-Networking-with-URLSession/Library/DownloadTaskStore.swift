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
    private let tempPath: URL

    init(_ manager: FileManager, at tempPath: URL) {
        self.manager = manager
        self.tempPath = tempPath
    }

    ///
    /// Copy download task in Temp into DocumentDirectory
    ///
    func copy(to url: URL) -> Bool {
        guard clearPath(as: url) || isAvailablePath(url: url) else {
            return false
        }
        do {
            try manager.copyItem(at: tempPath, to: url)
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
