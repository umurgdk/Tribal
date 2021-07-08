//
//  OrientedScrollView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

fileprivate class FlippedClipView: NSClipView {
    override var isFlipped: Bool { true }
}

public class OrientedScrollView: NSScrollView {
    public var axis: NSEvent.GestureAxis = .vertical
    
    public override class var isCompatibleWithResponsiveScrolling: Bool { true }
    
    public init() {
        super.init(frame: .zero)
        contentView = FlippedClipView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView = FlippedClipView()
    }
    
    public override func scrollWheel(with event: NSEvent) {
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
