//
//  APIRestClient.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/25.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

enum Result {
    case data(Data)
    case error(Error)
}

protocol RestClient {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    func request(with url: URL, delegate: URLSessionDelegate, _ completionHandler: @escaping RestClient.CompletionHandler)
}

extension RestClient {
    func request(with url: URL, delegate: URLSessionDelegate, _ completionHandler: @escaping RestClient.CompletionHandler) {
        let config = URLSessionConfiguration.background(withIdentifier: "SeachingSessionConfiguration")
        URLSession(configuration: config, delegate: delegate, delegateQueue: nil)
            .dataTask(with: url) { (data, response, error) in
                completionHandler(data, response, error)
            }
            .resume()
    }
}

protocol APIRequest {
    
}

class SearchAPIConfiguration {
    struct APIComponents {
        let host: String
        let method: String
        var terms: [String]
        var country: String?
        var entity: String?
        var attribute: String?
        var lang: String?
    }

    static let api: () -> SearchAPIConfiguration.APIComponents = {
        return decode(from: path!)
    }

    private static let path = Bundle.main.path(forResource: "iTunes", ofType: "plist")
    private static func decode(from path: String) -> APIComponents {
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            return APIComponents(host: "", method: "", terms: [], country: nil, entity: nil, attribute: nil, lang: nil)
        }
        return decode(values: dictionary)
    }
    private static func decode(values dictionary: NSDictionary) -> APIComponents {
        return APIComponents(host:      dictionary.value(forKey: "host",    to: String.self),
                             method:    dictionary.value(forKey: "mathod",  to: String.self),
                             terms:     dictionary.value(forKey: "terms",   to: [String].self),
                             country:   dictionary.value(forKey: "country", to: String.self),
                             entity:    dictionary.value(forKey: "entity",  to: String.self),
                             attribute: dictionary.value(forKey: "attribute", to: String.self),
                             lang:      dictionary.value(forKey: "lang",     to: String.self))
    }
}


extension NSDictionary {
    func value<T>(forKey key: String, to type: T.Type) -> T? {
        guard let value = value(forKey: key) as? T else {
            return nil
        }
        return value
    }
    func value<T>(forKey key: String, to type: T.Type) -> T {
        return value(forKey: key) as! T
    }
}






