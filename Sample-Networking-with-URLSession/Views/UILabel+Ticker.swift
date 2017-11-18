//
//  UILabel+Ticker.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/11/09.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import UIKit

protocol Ticking {

}

extension UILabel {

    func ready() -> Void {
        let frame = CGRect(origin: self.frame.origin, size: self.frame.size)
        let label = UILabel(frame: frame)
        // 文字列を配置
        label.text = self.text
        // 見えなくする
        self.isHidden = true
        addSubview(label)
    }

    func animate() -> Void {
        // 準備
        ready()

        // UILabelを取り出す
        guard let label = self.subviews.filter({ $0.isKind(of: UILabel.self) }).first else { return }
        
        let width = label.bounds.size.width
        let time = TimeInterval(5)
        let delay = TimeInterval(0.5)
        UIView.animateKeyframes(withDuration: time,
                                delay: delay,
                                options: [.calculationModeLinear, .calculationModePaced],
                                animations: { [weak self] in
                                    label.center = CGPoint(x: (self?.center.x)! - width / 2, y: (self?.center.y)!)
        }, completion: { [weak self] in
            print($0)
            print("end!!")
            self?.removeFromSuperview()
            self?.isHidden = false
        })
    }

}

