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
    
    public var cornerRadius: CGFloat = 0 {
        didSet { needsDisplay = true }
    }
    
    public var borderWidth: CGFloat = 0 {
        didSet { needsDisplay = true }
    }
    
    public var borderColor: NSColor? = nil {
        didSet { needsDisplay = true }
    }
    
    // MARK: - Setup
    public override var wantsUpdateLayer: Bool { true }
    public override var allowsVibrancy: Bool { true }
    
    public override func setupViewHierarchy() {
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        needsDisplay = true
    }
    
    // MARK: - Appearance
    public override func updateLayer() {
        super.updateLayer()
        layer?.backgroundColor = backgroundColor.cgColor
        layer?.cornerRadius = cornerRadius
        layer?.borderWidth = borderWidth
        layer?.borderColor = borderColor?.cgColor
    }
}
