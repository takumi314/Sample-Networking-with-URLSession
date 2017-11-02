//
//  AVPlayerTests.swift
//  Sample-Networking-with-URLSessionTests
//
//  Created by NishiokaKohei on 2017/11/03.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import XCTest
import AVKit
@testable import Sample_Networking_with_URLSession

class AVPlayerTests: XCTestCase {
    
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

    func testPlaye() {
        let path = "file:///Users/takumi/Library/Developer/CoreSimulator/Devices/B43DD9B3-D8C3-4E40-AA5F-ECC4F5491C75/data/Containers/Data/Application/37DB8880-F43A-4903-B230-F99F4807B449/tmp/CFNetworkDownload_YkC7NL.tmp"
        let url = URL(fileURLWithPath: path)
        let track = Track(name: "", artist: "", previewURL: url, index: 0)

        let parent = UIViewController()
        let service = AVPlayingService(track: track, parent: parent)


        // targe ?

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
