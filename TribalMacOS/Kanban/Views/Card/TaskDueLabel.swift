//
//  TaskDueLabel.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

class TaskDueLabel: BaseView {
    public var dueDate: Date = Date() {
        didSet {
            dueLabel.stringValue = dateFormatter.localizedString(for: dueDate, relativeTo: Date())
            cachedFittingSize = nil
        }
    }
    
    private let dateFormatter = RelativeDateTimeFormatter().configure {
        $0.unitsStyle = .full
    }
    
    // MARK: - View Hierarchy
    private let calendarIcon: NSImage = {
        let configuration = NSImage.SymbolConfiguration(pointSize: 11, weight: .regular)
        let image = NSImage.symbol("calendar").withSymbolConfiguration(configuration)!
        image.isTemplate = true
        return image
    }()
    
    private let iconView = NSImageView().configure {
        $0.contentTintColor = .tertiaryLabelColor
    }
    
    private let dueLabel = NSTextField(labelWithString: "").configure {
        $0.textColor = .tertiaryLabelColor
        $0.font = .preferredFont(forTextStyle: .subheadline, options: [:])
    }
    
    override func setupViewHierarchy() {
        iconView.image = calendarIcon
        iconView.sizeToFit()
        
        addSubview(iconView)
        addSubview(dueLabel)
    }
    
    // MARK: - Layout
    override func layout() {
        super.layout()
        
        iconView.setFrameOrigin(NSPoint(x: 0, y: bounds.midY - iconView.bounds.midY))
        dueLabel.sizeToFit()
        dueLabel.setFrameOrigin(NSPoint(x: iconView.frame.maxX + 4, y: bounds.midY - dueLabel.bounds.midY))
        dueLabel.frame.size.width = bounds.width - dueLabel.frame.minX
    }
    
    public func sizeToFit() {
        frame.size = fittingSize
    }
    
    var cachedFittingSize: NSSize?
    override var fittingSize: NSSize {
        if let size = cachedFittingSize { return size }
        
        let iconSize = iconView.fittingSize
        let labelSize = dueLabel.fittingSize
        let width = iconSize.width + 4 + labelSize.width
        let height = max(iconSize.height, labelSize.height)
        cachedFittingSize = CGSize(width: width, height: height)
        return cachedFittingSize!
    }
}
