//
//  AVPlayingService.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/11/03.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation
import AVKit

class AVPlayingService: NSObject {

    private let track: Track
    private let viewController: UIViewController

    init(track: Track, parent: UIViewController) {
        self.track = track
        self.viewController = parent
    }

    deinit {
        print("AVPlayingService: End")
    }

    func play() {
        let vc = AVPlayerViewController()
        if #available(iOS 11.0, *) {
            vc.entersFullScreenWhenPlaybackBegins = true
            vc.exitsFullScreenWhenPlaybackEnds = true
        } else {
            // Fallback on earlier versions
        }

        // Show
        viewController.present(vc, animated: true, completion: nil)

        let url = DownloadTaskStore.localPath(for: track.previewURL)
        vc.player = AVPlayer(url: url)

        // Automatically
        vc.player?.play()
    }

}
