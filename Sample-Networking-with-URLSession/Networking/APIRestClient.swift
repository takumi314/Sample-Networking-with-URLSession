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
    typealias Host = String
    typealias Method = String
    typealias Terms = [String]
    typealias Coutory = String
    typealias Entity = String
    typealias Attribute = String
    typealias Lang = String
    typealias RequestURL = (Host, Method, Terms?, Coutory?, Entity?, Attribute?, Lang?)

    struct API {
        let host: Host
        let method: Method
        var terms: Terms?
        var countory: Coutory?
        var entity: Entity?
        var attribute: Attribute?
        var lang: Lang?
    }

    static let api: () -> SearchAPIConfiguration.API
        = { let c = SearchAPIConfiguration().requestURL
            return API(host: c.0,
                       method: c.1,
                       terms: c.2,
                       countory: c.3,
                       entity: c.5,
                       attribute: c.5,
                       lang: c.6)
        }

    private static let path = Bundle.main.path(forResource: "iTunes", ofType: "plist")

    private let requestURL: RequestURL
    init() {
        self.requestURL = SearchAPIConfiguration.decode(contentsOf: SearchAPIConfiguration.path!)
    }

    private static func decode(contentsOf path: String) -> RequestURL {
        return decode(values: NSDictionary(contentsOfFile: path)!)
    }

    private static func decode(values dictionary: NSDictionary) -> RequestURL {
        let host        = dictionary.value(forKey: "host") as! String
        let method      = dictionary.value(forKey: "method") as! String
        let country     = dictionary.value(forKey: "country") as? String
        let entity      = dictionary.value(forKey: "entity") as? String
        let attribute   = dictionary.value(forKey: "attribute") as? String
        let lang        = dictionary.value(forKey: "lang") as? String

        return (host, method, [], country, entity, attribute, lang)
    }

}







