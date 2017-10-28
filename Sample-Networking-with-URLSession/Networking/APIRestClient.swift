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

enum APIRequest {

    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    case get
    case put
    case post
    case delete

    func request(_ method: APIRequest, completion: APIRequest.CompletionHandler) {
        switch self {
        case .get:
            break
        case .post:
            break
        default:
            break
        }
    }
}

protocol RestClient {
    func request(with url: URL, _ completionHandler: @escaping APIRequest.CompletionHandler)
}

class SearchAPIConfiguration {
    typealias BaseURL = String
    typealias Method = String
    typealias Terms = [String]
    typealias Coutory = String
    typealias Entity = String
    typealias Attribute = String
    typealias Lang = String
    typealias RequestURL = (BaseURL, Method, Terms?, Coutory?, Entity?, Attribute?, Lang?)

    let path = Bundle.main.path(forResource: "iTunes", ofType: "plist")

    private let requestURL: RequestURL

    init(_ path: String) {
        self.requestURL = SearchAPIConfiguration.decode(contentsOf: path)
    }

    static func decode(contentsOf path: String) -> RequestURL {
        return decode(values: NSDictionary(contentsOfFile: path)!)
    }

    private static func decode(values dictionary: NSDictionary) -> RequestURL {
        let endpoint    = dictionary.value(forKey: "endpoint") as! String
        let method      = dictionary.value(forKey: "method") as! String
        let country     = dictionary.value(forKey: "country") as? String
        let entity      = dictionary.value(forKey: "entity") as? String
        let attribute   = dictionary.value(forKey: "attribute") as? String
        let lang        = dictionary.value(forKey: "lang") as? String

        return (endpoint, method, [], country, entity, attribute, lang)
    }

}







