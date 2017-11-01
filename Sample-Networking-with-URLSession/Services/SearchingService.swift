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
    private var api: SearchAPIConfiguration.APIComponents = SearchAPIConfiguration.api

    ///
    /// インスタンス生成時に URLSessionConfiguration と URLSession の依存性を与える.
    ///
    init(_ session: NetworkEngine) {
        self.session = session
    }

    func getResult(searchTerm: String, completion: @escaping QueryResult) {
        guard let url = SearchAPIConfiguration.url(searchingFor: searchTerm) else {
            self.errorMessage += "URLComponents error: invalid URL.Query parameter" + "\n"
            return
        }
        // 3. API request
        request(with: url, delegate: self) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                completion(nil, self.errorMessage)
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

    private func mapping(_ data: Data) {
        tracks.removeAll()
        do {
            let tracks = try JSONDecoder().decode(SearchResults.self, from: data).results
            self.tracks = numbering(for: tracks)
        } catch let parseError {
            self.errorMessage += "json convert failed in JSONDecoder: \(parseError.localizedDescription)\n"
        }
    }

    private func numbering(for tracks: [Track]) -> [Track] {
        return tracks
                .enumerated()
                .map {
                    return Track(name: $0.element.name,
                                 artist: $0.element.artist,
                                 previewURL: $0.element.previewURL,
                                 index: $0.offset)
                }
    }

    private func getParameterKeyValue(from value: String, index: Int) -> String {
        return "&value\(index)="
    }
    
}

extension SearchingService: RestClient {}
extension SearchingService: URLSessionDelegate {}
