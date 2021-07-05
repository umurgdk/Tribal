//
//  ImageView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit
import Nuke

class ImageView: NSView, Nuke_ImageDisplaying {
    public var image: NSImage? {
        didSet {
            needsDisplay = true
        }
    }
    
    public var scaling: CALayerContentsGravity = .resizeAspectFill {
        didSet {
            needsDisplay = true
        }
    }
    
    override var intrinsicContentSize: NSSize {
        if let image = image {
            return image.size
        }
        
        return CGSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
    }

    // MARK: - Lifecycle
    override var wantsUpdateLayer: Bool { true }
    
    init(image: NSImage? = nil) {
        super.init(frame: .zero)
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
    }
    
    override func updateLayer() {
        super.updateLayer()
        layer?.contentsGravity = .resizeAspectFill
        layer?.contents = image
    }
    
    func nuke_display(image: PlatformImage?, data: Data?) {
        self.image = image
    }
}
