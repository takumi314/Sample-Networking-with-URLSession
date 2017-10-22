//
//  DataLoader.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/19.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

class DataLoader {

    enum Result: Equatable {
        case data(Data)
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
        engine.performRequest(for: url) { (data, response, error) in
            if let error = error {
                return completionHadler(.error(error))
            }
            completionHadler(.data(data ?? Data()))
        }
    }


}
