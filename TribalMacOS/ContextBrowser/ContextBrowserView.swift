//
//  ContextBrowserView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import AppKit

class ContextBrowserView: BaseView {
    let pickerView: NSView
    let contentView: NSView
    let divider = NSBox.divider()
    
    init(pickerView: NSView, contentView: NSView) {
        self.pickerView = pickerView
        self.contentView = contentView
        super.init()
    }
    
    override func setupViewHierarchy() {
        addSubview(pickerView)
        addSubview(contentView)
        addSubview(divider)
    }
    
    override func layout() {
        super.layout()
        
        pickerView.frame = bounds
        pickerView.frame.size.width = 90
        
        divider.frame = CGRect(
            x: pickerView.frame.maxX - 1,
            y: 0,
            width: 1,
            height: bounds.height
        )
        
        contentView.frame = bounds
        contentView.frame.origin.x = divider.frame.maxX
        contentView.frame.size.width -= divider.frame.maxX
    }
}
