//
//  TickerScrollview.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/11/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import UIKit

protocol TickerScrollviewDelegate {
    func userTouch()
    func userDrag()
    func userEndTouch()
}

class TickerScrollview: UIScrollView {

    // MARK: - TickerScrollviewDelegate

    var tickerDelegate: TickerScrollviewDelegate?

    // MARK: - Override methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tickerDelegate?.userTouch()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        tickerDelegate?.userDrag()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragging {
            next?.touchesEnded(touches, with: event)
        }
        super.touchesEnded(touches, with: event)
        tickerDelegate?.userEndTouch()
    }

}
