//
//  NetworkEngine.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

protocol NetworkEngine {
    typealias Handler = (URL?, URLResponse?, Error?) -> Void
    func performRequest(for url: URL, completionHandler: @escaping Handler)
}

extension URLSession: NetworkEngine {
    typealias Handler = NetworkEngine.Handler

    func performRequest(for url: URL, completionHandler: @escaping NetworkEngine.Handler) {
        let task = self.downloadTask(with: url, completionHandler: completionHandler)
        task.resume()
    }

}
