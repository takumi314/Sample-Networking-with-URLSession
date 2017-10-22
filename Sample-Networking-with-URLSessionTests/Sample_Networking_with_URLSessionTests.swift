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

        loader.load(from: url) {
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
