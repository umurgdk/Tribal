//
//  BrowserWindowController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

extension NSToolbar.Identifier {
    static var browserMain: NSToolbar.Identifier { "BrowserMainToolbar" }
}

class BrowserWindowController: NSWindowController, NSWindowDelegate {
    lazy var toolbarDelegate = BrowserWindowToolbarDelegate()
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let window = window else { return }
        configureToolbar(window: window)
        window.subtitle = "You have 8 tasks"
        window.titlebarSeparatorStyle = .none
        window.setFrameUsingName(window.frameAutosaveName, force: true)
        window.delegate = self
        // window.setContentSize(NSSize(width: 1000, height: 600))
        // window.center()
    }
    
    private func configureToolbar(window: NSWindow) {
        let toolbar = NSToolbar(identifier: "BrowserMainToolbar")
        toolbar.delegate = toolbarDelegate
        toolbar.allowsUserCustomization = true
        toolbar.autosavesConfiguration = true
        toolbar.displayMode = .iconOnly
        toolbar.showsBaselineSeparator = false
        window.toolbarStyle = .unified
        window.toolbar = toolbar
    }
    
    func windowWillClose(_ notification: Notification) {
        guard let window = window else { return }
        window.saveFrame(usingName: window.frameAutosaveName)
    }
}
