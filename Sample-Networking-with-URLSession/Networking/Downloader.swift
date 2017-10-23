//
//  Downloader.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

class Downloader {

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

    func load(from url: URL, completionHadler: @escaping (Result) -> Void) {
        engine.performDownload(for: url) { (url, response, error) in
            if let error = error {
                return completionHadler(.error(error))
            }
            // コピー元のURL
            guard let url = url else {
                let error = CocoaError.error(.fileReadUnknown, userInfo: nil, url: nil)
                return completionHadler(.error(error))
            }
            // コピー元
//            guard FileManager.default.isReadableFile(atPath: url.absoluteString) else {
//                let error = CocoaError.error(.fileReadUnknown, userInfo: nil, url: nil)
//                return completionHadler(.error(error))
//            }
//
            // A path to save the download's data
//            let path = URL(fileURLWithPath: "")
//
//            var destValid: ObjCBool = false
//            FileManager.default.fileExists(atPath: path.absoluteString, isDirectory: &destValid)

            // 保存用のディレクトリ作成
//            if !destValid.boolValue {
//                do {
//                    try FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
//                } catch let error {
//                    return completionHadler(.error(error))
//                }
//            }

            // ダウンロードデータを永続化する
//            do {
//                try FileManager.default.copyItem(at: url, to: path)
//            } catch let error {
//                return completionHadler(.error(error))
//            }

            completionHadler(.data(url))
        }
    }

}
