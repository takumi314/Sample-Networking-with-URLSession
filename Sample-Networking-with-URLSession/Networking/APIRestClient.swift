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
    typealias ErrorMessage = String

    struct APIComponents {
        var host: String        = ""
        var method: String      = ""
        var terms: [String]     = []
        var country: String?    = nil
        var entity: String?     = nil
        var attribute: String?  = nil
        var lang: String?       = nil
        var media: String?      = nil

        init(values dictionary: NSDictionary) {
            self.host       =   dictionary.value(forKey: "host",        to: String.self)
            self.method     =   dictionary.value(forKey: "method",      to: String.self)
            self.terms      =   dictionary.value(forKey: "terms",       to: [String].self)
            self.country    =   dictionary.value(forKey: "country",     to: String.self)
            self.entity     =   dictionary.value(forKey: "entity",      to: String.self)
            self.attribute  =   dictionary.value(forKey: "attribute",   to: String.self)
            self.lang       =   dictionary.value(forKey: "lang",        to: String.self)
            self.media      =   dictionary.value(forKey: "media",       to: String.self)
        }
    }

    static var api: APIComponents {
        return decode(from: plistPath!)
    }

    static func url(searchingFor searchTerm: String) -> URL? {
        let api = SearchAPIConfiguration.api
        guard var urlComponents = URLComponents(string: "\(api.host)/\(api.method)") else {
            print("URLComponents error:  invalid Host's URL " + "\n")
            return nil
        }
        // 1. searchTerm -> Query
        let term = SearchAPIConfiguration.convert(from: searchTerm)
        urlComponents.queryItems = [URLQueryItem(name: "media"    , value: api.media),
                                    URLQueryItem(name: "entity"   , value: api.entity),
                                    URLQueryItem(name: "term"     , value: term)]
        // 2. Query ->  URL
        guard let url = urlComponents.url else {
            print("URLComponents error: invalid URL.Query parameter" + "\n")
            return nil
        }
        return url
    }

    // MARK: - Private
    
    private static let plistPath = Bundle(for: SearchAPIConfiguration.self).url(forResource: "iTunes", withExtension: "plist")

    private static func convert(from term: String) -> String {
        return term.components(separatedBy: CharacterSet.whitespaces).joined(separator: "+")
    }

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






