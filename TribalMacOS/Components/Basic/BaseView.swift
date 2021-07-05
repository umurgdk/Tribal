//
//  BaseView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

open class BaseView: NSView {
    public init() {
        super.init(frame: .zero)
        setupViewHierarchy()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupViewHierarchy() { }
}
