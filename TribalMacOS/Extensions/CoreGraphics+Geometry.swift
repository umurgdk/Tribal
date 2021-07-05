//
//  CoreGraphics+Geometry.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import CoreGraphics
import AppKit

extension CGRect {
    func inset(by insets: NSEdgeInsets, isFlipped: Bool = false) -> CGRect {
        var newRect = self
        newRect.origin.x += insets.left
        newRect.origin.y += isFlipped ? insets.top : insets.bottom
        newRect.size.width -= insets.left + insets.right
        newRect.size.height -= insets.bottom + insets.top
        return newRect
    }
    
    func consumeHeight(_ amount: CGFloat, isFlipped: Bool = false) -> CGRect {
        var newRect = self
        newRect.size.height -= amount
        newRect.origin.y += isFlipped ? amount : 0
        return newRect
    }
}
