//
//  TaskCardSelectionView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

class TaskCardSelectionView: BaseView {
    override var wantsUpdateLayer: Bool { true }
    override func setupViewHierarchy() {
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        needsDisplay = true
    }
    
    override func updateLayer() {
        super.updateLayer()
        guard let layer = layer else { return }
        
        layer.cornerRadius = 4
        layer.borderWidth = 2
        layer.borderColor = NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor
    }
}
