//
//  Background.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

public class Background: BaseView {
    // MARK: - Properties
    public var backgroundColor: NSColor = .controlBackgroundColor {
        didSet { needsDisplay = true }
    }
    
    public var backgroundImage: NSImage? {
        didSet { needsDisplay = true }
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet { needsDisplay = true }
    }
    
    public var borderWidth: CGFloat = 0 {
        didSet { needsDisplay = true }
    }
    
    public var borderColor: NSColor? = nil {
        didSet { needsDisplay = true }
    }
    
    public var shouldAllowVibrancy: Bool = true {
        didSet { needsDisplay = true }
    }
    
    // MARK: - Setup
    public override var wantsUpdateLayer: Bool { true }
    public override var allowsVibrancy: Bool { shouldAllowVibrancy }
    
    public override func setupViewHierarchy() {
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        needsDisplay = true
    }
    
    // MARK: - Appearance
    public override func updateLayer() {
        super.updateLayer()
        if let backgroundImage = backgroundImage {
            layer?.contents = backgroundImage
            layer?.contentsGravity = .resizeAspectFill
        }
        
        layer?.backgroundColor = backgroundColor.cgColor
        layer?.cornerRadius = cornerRadius
        layer?.borderWidth = borderWidth
        layer?.borderColor = borderColor?.cgColor
    }
}
