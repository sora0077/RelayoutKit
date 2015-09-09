//
//  TableController+UIScrollViewDelegate.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/10.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

extension TableController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.altDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        self.altDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.altDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        self.altDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.altDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        self.altDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.altDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        self.altDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.altDelegate?.viewForZoomingInScrollView?(scrollView)
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        
        self.altDelegate?.scrollViewWillBeginZooming?(scrollView, withView: view)
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        self.altDelegate?.scrollViewDidEndZooming?(scrollView, withView: view, atScale: scale)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        
        return self.altDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        
        self.altDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
