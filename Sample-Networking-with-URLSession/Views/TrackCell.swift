//
//  TrackCell.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/29.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import UIKit
import Closures

class TrackCell: UITableViewCell {
    typealias ActionHandler = (TrackCell) -> ()

    var pauseTappedHandler: ActionHandler?
    var resumeTappedHandler: ActionHandler?
    var cancelTappedHandler: ActionHandler?
    var downloadTappedHandler:ActionHandler?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!


    func configure(track: Track) {
        titleLabel.text = track.name
        artistLabel.text = track.artist
    }

    func asctions() -> () {
        // Button actions
        pauseButton.onTap { [unowned self] in
            guard let text = self.pauseButton.titleLabel?.text else {
                return
            }
            if text == "Pause" {
                if let handler = self.pauseTappedHandler {
                    handler(self)
                }
            } else {
                if let handler = self.resumeTappedHandler {
                    handler(self)
                }
            }
        }
        cancelButton.onTap { [unowned self] in
            if let handler = self.cancelTappedHandler {
                handler(self)
            }
        }
        downloadButton.onTap { [unowned self] in
            if let handler = self.downloadTappedHandler {
                handler(self)
            }
        }
    }

}
