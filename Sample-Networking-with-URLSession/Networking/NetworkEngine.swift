//
//  NetworkEngine.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

protocol NetworkEngine {
    typealias DataHandler = (Data?, URLResponse?, Error?) -> Void
    typealias URLHandler = (URL?, URLResponse?, Error?) -> Void
    func performRequest(for url: URL, completionHandler: @escaping DataHandler)
    func performDownload(for url: URL, completionHadler: @escaping NetworkEngine.URLHandler)
}

extension URLSession: NetworkEngine {
    typealias DataHandler = NetworkEngine.DataHandler
    typealias URLHandler = NetworkEngine.URLHandler

    func performRequest(for url: URL, completionHandler: @escaping DataHandler) {
        let task = dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }

    func performDownload(for url: URL, completionHadler: @escaping URLHandler) {
        let task = downloadTask(with: url, completionHandler: completionHadler)
        task.resume()
    }
}

class NetworkEngineMock: NetworkEngine {
    typealias DataHandler = NetworkEngine.DataHandler
    typealias URLHandler = NetworkEngine.URLHandler

    var requestedURL: URL?

    func performRequest(for url: URL, completionHandler: @escaping DataHandler) {
        requestedURL = url

        let data = "Hello world".data(using: .utf8)
        completionHandler(data, nil, nil)
    }
    func performDownload(for url: URL, completionHadler: @escaping URLHandler) {
        requestedURL = url

        let pathURL = URL(fileURLWithPath: "file:///Document/hoge")
        completionHadler(pathURL, nil, nil)
    }
}

