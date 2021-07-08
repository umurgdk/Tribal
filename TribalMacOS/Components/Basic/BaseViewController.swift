//
//  BaseViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

class BaseViewController: NSViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
