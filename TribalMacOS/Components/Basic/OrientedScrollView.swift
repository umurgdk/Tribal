//
//  OrientedScrollView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

class OrientedScrollView: NSScrollView {
    var axis: NSEvent.GestureAxis = .vertical
    var isLiveResizing = false
    
    override class var isCompatibleWithResponsiveScrolling: Bool { true }
    
    var originalScroller: NSScroller?
    override func viewWillStartLiveResize() {
        isLiveResizing = true
        originalScroller = verticalScroller
        super.viewWillStartLiveResize()
    }
    
    override func viewDidEndLiveResize() {
        isLiveResizing = false
        verticalScroller = originalScroller
        originalScroller = nil
        flashScrollers()
        super.viewDidEndLiveResize()
    }
    
    override func flashScrollers() {
        guard !isLiveResizing else { return }
        super.flashScrollers()
    }
    
    override func scrollWheel(with event: NSEvent) {
        if event.phase == NSEvent.Phase.mayBegin {
            super.scrollWheel(with: event)
            nextResponder?.scrollWheel(with: event)
            return
        }
        
        var scrollingAxis = NSEvent.GestureAxis.vertical
        if event.phase == .began || (event.phase == .init(rawValue: 0) && event.momentumPhase == .init(rawValue: 0)) {
            scrollingAxis = abs(event.scrollingDeltaX) > abs(event.scrollingDeltaY) ? .horizontal : .vertical
        }
        
        if scrollingAxis != axis {
            nextResponder?.scrollWheel(with: event)
        } else {
            super.scrollWheel(with: event)
        }
    }
}
