//
//  ContextPickerItemView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import AppKit

class ContextPickerItemView: BaseView {
    public var onClick: () -> Void = { }
    public var isSelected: Bool = false {
        didSet {
            clickGesture.isEnabled = !isSelected
            selectionIndicator.animator().isHidden = !isSelected
        }
    }
    
    public var context: EntityContext
    init(context: EntityContext) {
        self.context = context
        super.init()
    }

    // MARK: - Setup View Hierarchy
    let background = Background().configure {
        $0.shouldAllowVibrancy = false
        $0.backgroundColor = NSColor.black
        $0.backgroundImage = NSImage(named: "asana")
        $0.cornerRadius = 4
    }
    
    let selectionIndicator = Background().configure {
        $0.borderWidth = 3
        $0.borderColor = .white.withAlphaComponent(0.5)
        $0.cornerRadius = 8
        $0.backgroundColor = .clear
    }
    
    override func setupViewHierarchy() {
        addSubview(background)
        addSubview(selectionIndicator)
        selectionIndicator.isHidden = true
        addGestureRecognizer(clickGesture)
    }
    
    override func layout() {
        super.layout()
        selectionIndicator.frame = bounds.insetBy(dx: 10, dy: 10)
        selectionIndicator.frame.origin.y += 10
        background.frame = bounds.insetBy(dx: 16, dy: 16)
        background.frame.origin.y += 10
        background.frame.size.height = background.frame.size.width
    }
    
    // MARK: - Event handlers
    private lazy var clickGesture = NSClickGestureRecognizer(target: self, action: #selector(didClick))
    @objc private func didClick(_ sender: NSClickGestureRecognizer) {
        onClick()
    }
    
    override var acceptsFirstResponder: Bool { true }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        if !isSelected {
            selectionIndicator.alphaValue = 0.5
            selectionIndicator.animator().isHidden = false
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if !isSelected {
            selectionIndicator.isHidden = true
        }
        
        super.mouseUp(with: event)
    }
}
