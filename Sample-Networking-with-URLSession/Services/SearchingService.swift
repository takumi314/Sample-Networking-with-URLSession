//
//  SearchingService.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/25.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation

protocol SearcingRestClient: RestClient { }

class SearchingService: NSObject {
    typealias QueryResult = ([Track]?, String) -> ()

    private var dataTask: URLSessionDataTask?
    private var tracks = [Track]()
    private var errorMessage = ""

    private let session: NetworkEngine

    ///
    /// インスタンス生成時に URLSessionConfiguration と URLSession の依存性を与える.
    ///
    init( _ session: NetworkEngine) {
        self.session = session
    }

    func getResult(searchTerm: String, completion: @escaping QueryResult) {
        guard var urlComponents = URLComponents(string: "https//hoge/api/") else {
            completion(nil, "")
            return
        }
        // 1. searchTerm -> Query
        let term = replace(with: searchTerm)
        // 2. Query ->  URL
        urlComponents.query = "media=music&entity=song&term=\(term)"
        guard let url = urlComponents.url else {
            completion(nil, "")
            return
        }
        // 3. API request
        request(with: url) { [weak self] (data, response, error) in
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

    func replace(with term: String) -> String {
        return term.components(separatedBy: CharacterSet.whitespaces).joined(separator: "+")
    }

    private func getParameterKeyValue(from value: String, index: Int) -> String {
        return "&value\(index)="
    }

    func mapping(_ data: Data) {
        tracks.removeAll()
        do {
            self.tracks  = try JSONDecoder().decode(SearchResults.self, from: data).results
            self.count = try JSONDecoder().decode(SearchResults.self, from: data).number
        } catch let parseError {
            errorMessage += "json convert failed in JSONDecoder: \(parseError.localizedDescription)\n"
        }
    }

}

extension SearchingService: RestClient {
    func request(with url: URL, _ completionHandler: @escaping APIRequest.CompletionHandler) {
        let config = URLSessionConfiguration.background(withIdentifier: "SeachingSessionConfiguration")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        session.dataTask(with: url) { (data, response, error) in
                completionHandler(data, response, error)
            }
            .resume()
    }
}

extension SearchingService: URLSessionDelegate {}
