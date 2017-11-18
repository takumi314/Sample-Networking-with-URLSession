//
//  TickerView.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/11/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class TickerView: UIView {

    // MARK: - Define

    static let SCROLLING_TIME_INTERVAL  = 0.1
    static let SCROLLING_PIXEL_DISTANCE = CGFloat(1)

    // MARK: - Public properties

    var scrollView: TickerScrollview!
    var marquee: String = ""
    var font: UIFont!

    // MARk: - Public methods

    func labelSize(for text: String, _ font: UIFont) -> CGSize {
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font,
                                                        NSAttributedStringKey.paragraphStyle: NSLineBreakMode.byWordWrapping]
        let size = CGSize(width: 10000, height: frame.size.height)
        let rect = (text as NSString).boundingRect(with: size,
                                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                   attributes: attributes,
                                                   context: nil)
        return rect.size
    }

    // MARK: - Initilizer

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func draw(_ rect: CGRect) {
        guard let _ = scrollView else {
            return
        }
        scrollView.delegate = self
        scrollView.tickerDelegate = self

        scrollView.addSubview(incetanceLabel())
        addSubview(scrollView)

        contentWidth = 2 * frame.size.width + labelSize(for: marquee, font).width
        scrollView.contentSize = CGSize(width: contentWidth, height: frame.size.height)

        isScrolling = false
        beginScrolling()
    }

    deinit {
        font = nil
        marquee = ""
        stopScrolling()
    }

    // MARK: - Private properties

    private var scrollingTimer: Timer?
    private var contentWidth: CGFloat = 0.0
    private var labelWidth: CGFloat = 0.0
    private var isScrolling: Bool = false

    // MAKR: - Private methods

    private func incetanceLabel() -> UILabel {
        let rect = CGRect(x: frame.size.width, y: 0, width: labelWidth, height: frame.size.height)
        let label = UILabel(frame: rect)
        label.font = font
        label.backgroundColor = .clear
        label.textColor = .white
        label.text = marquee
        return label
    }

    private func beginScrolling() {
        guard isScrolling else {
            return
        }
        isScrolling = true
        scrollingTimer = Timer.scheduledTimer(timeInterval: TickerView.SCROLLING_TIME_INTERVAL,
                                              target: self,
                                              selector: #selector(scroll),
                                              userInfo: nil,
                                              repeats: true)
    }

    private func stopScrolling() {
        if isScrolling {
            scrollingTimer?.invalidate()
            scrollingTimer = nil
            isScrolling = false
        }
    }

    @objc private func scroll(_ timer: Timer) {
        if scrollView.contentOffset.x >= contentWidth - frame.size.width {
            scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
        var point = scrollView.contentOffset
        point.x += TickerView.SCROLLING_PIXEL_DISTANCE
        scrollView.contentOffset = point
    }

}

extension TickerView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // any offset changes
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // any zoom scale changes
    }

    // called on start of dragging (may require some time and or distance to move)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //
    }

    // called on finger up if the user dragged. velocity is in points/millisecond.
    // targetContentOffset may be changed to adjust where the scroll view comes to rest
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //
    }

    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        beginScrolling()
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // called on finger up as we are moving
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // called when scroll view grinds to a halt
        beginScrolling()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
        beginScrolling()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // return a view that will be scaled. if delegate returns nil, nothing happens
        return nil
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        // called before the scroll view begins zooming its content
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // scale between minimum and maximum. called after any 'bounce' animations
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        // return a yes if you want to scroll to the top. if not defined, assumes YES
        return false
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        // called when scrolling animation finished. may be called immediately if already at top
    }

    ///
    /// @available(iOS 11.0, *)
    ///
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        //
    }

}

extension TickerView: TickerScrollviewDelegate {

    func userTouch() {
        //stop scrolling when user touch it
        stopScrolling()
    }

    func userDrag() {
        //
    }

    func userEndTouch() {
        //start scrolling again when user end touching
        beginScrolling()
    }

}



