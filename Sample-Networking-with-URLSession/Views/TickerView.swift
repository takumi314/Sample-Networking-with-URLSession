//
//  TickerView.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/11/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class TickerView: UIView {

    // MARK: - Public properties

    var scrollView: TickerScrollview!
    var marquee: String = ""
    var font: UIFont!

    // MARk: - Public methods

    func labelSize(for text: String, _ font: UIFont) -> CGSize {
        //

        return scrollView.bounds.size
    }


    // MARK: - Private properties

    private var scrollingTime: Timer?
    private var contentWidth: CGFloat = 0.0
    private var labelWidth: CGFloat = 0.0
    private var startScrolling: Bool = false


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
        //
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // called on finger up as we are moving
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // called when scroll view grinds to a halt
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
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
        //
    }

    func userDrag() {
        //
    }

    func userEndTouch() {
        //
    }

}



