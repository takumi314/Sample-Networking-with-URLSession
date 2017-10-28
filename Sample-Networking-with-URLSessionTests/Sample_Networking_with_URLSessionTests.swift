//
//  Sample_Networking_with_URLSessionTests.swift
//  Sample-Networking-with-URLSessionTests
//
//  Created by NishiokaKohei on 2017/10/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import XCTest
@testable import Sample_Networking_with_URLSession

class Sample_Networking_with_URLSessionTests: XCTestCase {

    class JsonProvider {
        static func getData() -> Data? {
            let testPath = Bundle(for: Sample_Networking_with_URLSessionTests.self)
            guard let path = testPath.url(forResource: "test", withExtension: "json") else { return nil }
            return try? Data(contentsOf: path, options: .mappedIfSafe)
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testMapping() {
        let engine = NetworkEngineMock()
        let service = SearchingService(engine)
        let jsonData = JsonProvider.getData()

        service.mapping(jsonData!)
        print(service.fetchAllTracks())

        let track = service.fetchAllTracks().first!
        XCTAssertEqual(service.fetchAllTracks().count, 25)
        XCTAssertEqual(track.name, "Better Together")
        XCTAssertEqual(track.artist, "Jack Johnson")
    }

    func testTrack() {
        let url = URL(string: "https://itunes.apple.com/search")!
        let track = Track(name: "Don't talk any more", artist: "Cherlie", previewURL: url , index: 10)
        let jsonData = try? JSONEncoder().encode(track)
        XCTAssertNotNil(jsonData)
        print(jsonData!)

        let d = try? JSONDecoder().decode(Track.self, from: jsonData!)
        XCTAssertNotNil(d)
        XCTAssertEqual(d?.name, track.name)
        XCTAssertEqual(d?.artist, track.artist)
        XCTAssertEqual(d?.previewURL, track.previewURL)
        XCTAssertNotEqual(d?.index, track.index)
    }

    func testConvert() {
        let engine = NetworkEngineMock()
        let service = SearchingService(engine)
        let searchTerm = "one two three"

        let term = service.convert(from: searchTerm)
        XCTAssertEqual(term, "one+two+three")
    }

    func testLoad() {
        // 1.Mock
        let engine = NetworkEngineMock()

        // 2.Target
        let loader = DataLoader(engine)
        var result: DataLoader.Result?
        let url = URL(fileURLWithPath: "my/API")

        loader.load(from: url) {
            result = $0
        }

        XCTAssertEqual(engine.requestedURL, url)
        XCTAssertEqual(result!, DataLoader.Result.data("Hello world".data(using: .utf8)!))
    }

    func testDownLoad() {
        let engine = NetworkEngineMock()

        let loader = Downloader(engine)
        var result: Downloader.Result?
        let url = URL(fileURLWithPath: "my/API")

        let _ = loader.load(from: url) {
            result = $0
        }
        

        XCTAssertEqual(engine.requestedURL, url)
        XCTAssertEqual(result!, .data(URL(fileURLWithPath: "file:///Document/hoge")) )
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
