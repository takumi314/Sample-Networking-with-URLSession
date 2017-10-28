//
//  SearchingService.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/25.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

class SearchingService: NSObject {
    typealias QueryResult = ([Track]?, String) -> ()

    private let session: NetworkEngine

    private var dataTask: URLSessionDataTask?
    private var tracks = [Track]()
    private var errorMessage = ""
    private var api: SearchAPIConfiguration.API = SearchAPIConfiguration.api()

    ///
    /// インスタンス生成時に URLSessionConfiguration と URLSession の依存性を与える.
    ///
    init( _ session: NetworkEngine) {
        self.session = session
    }

    func getResult(searchTerm: String, completion: @escaping QueryResult) {
        guard var urlComponents = URLComponents(string: api.host + "/\(api.method)" ) else {
            self.errorMessage += "URLComponents error:  invalid URL string" + "\n"
            completion(nil, errorMessage)
            return
        }
        // 1. searchTerm -> Query
        let term = convert(from: searchTerm)
        urlComponents.queryItems = [URLQueryItem(name: "media"    , value: "music"),
                                    URLQueryItem(name: "entity"   , value: "song"),
                                    URLQueryItem(name: "term"     , value: term)]
        // 2. Query ->  URL
        guard let url = urlComponents.url else {
            self.errorMessage += "URLComponents error: invalid URL.Query parameter" + "\n"
            completion(nil, errorMessage)
            return
        }
        // 3. API request
        request(with: url, delegate: self) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                completion(nil, error as! String)
            }
            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.mapping(data)
                debugPrint(data)
                DispatchQueue.main.async { [unowned self] in
                    completion(self.tracks, self.errorMessage)
                }
            }
        }
    }

    func fetchAllTracks() -> [Track] {
        return tracks
    }

    func convert(from term: String) -> String {
        return term.components(separatedBy: CharacterSet.whitespaces).joined(separator: "+")
    }

    func mapping(_ data: Data) {
        tracks.removeAll()
        do {
            self.tracks  = try JSONDecoder().decode(SearchResults.self, from: data).results
        } catch let parseError {
            self.errorMessage += "json convert failed in JSONDecoder: \(parseError.localizedDescription)\n"
        }
    }

    private func getParameterKeyValue(from value: String, index: Int) -> String {
        return "&value\(index)="
    }
    
}

extension SearchingService: RestClient {}
extension SearchingService: URLSessionDelegate {}
