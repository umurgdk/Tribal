//
//  ContextPickerView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 15.07.2021.
//

import AppKit

class ContextPickerView: BaseView {
    private let documentView = BaseView()
    private let scrollView = NSScrollView().configure {
        $0.contentView = FlippedClipView()
        $0.drawsBackground = false
    }
    
    private let vfxView = NSVisualEffectView().configure {
        $0.blendingMode = .behindWindow
        $0.material = .sidebar
    }
    
    override func setupViewHierarchy() {
        addSubview(vfxView)
        scrollView.documentView = documentView
        vfxView.addSubview(scrollView)
    }
    
    override func layout() {
        super.layout()
        
        documentView.frame.size.width = bounds.width
        for itemView in documentView.subviews {
            itemView.frame.origin.x = bounds.midX - itemView.bounds.midX
        }

        vfxView.frame = bounds
        scrollView.frame = vfxView.bounds
    }
    
    public func removeAllItemViews() {
        documentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    public func addContextItemView(_ itemView: ContextPickerItemView) {
        documentView.addSubview(itemView)
        
        let itemTop = CGFloat(documentView.subviews.count - 1) * 68
        let origin = CGPoint(x: 0, y: itemTop)
        let size = CGSize(width: 68, height: 68)
        itemView.frame = CGRect(origin: origin, size: size)
        documentView.frame.size.height = itemView.frame.maxY
    }
    
    public func selectContext(_ context: EntityContext) {
        documentView.subviews
            .map { $0 as! ContextPickerItemView }
            .forEach { $0.isSelected = $0.context === context }
    }
}
