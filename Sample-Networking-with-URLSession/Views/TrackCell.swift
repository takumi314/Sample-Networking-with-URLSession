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
    }

}
