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
    @objc private let browserController: BrowserController
    
    static func create(workspace: Workspace) -> BrowserWindowController {
        NSStoryboard(name: "Browser", bundle: nil).instantiateInitialController { coder in
            BrowserWindowController(coder: coder, workspace: workspace)
        }!
    }
    
    init?(coder: NSCoder, workspace: Workspace) {
        browserController = BrowserController(workspace: workspace)
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let observations = ObservationBag()
    private lazy var toolbarDelegate = BrowserWindowToolbarDelegate()
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let window = window else { return }
        configureToolbar(window: window)
        window.subtitle = "You have 8 tasks"
        window.titlebarSeparatorStyle = .none
        window.contentViewController = BrowserViewController(browserController: browserController)
        
        windowFrameAutosaveName = NSWindow.FrameAutosaveName("BrowserWindow")
     
        observations.observeNew(\.browserController.selectedProject, in: self, withInitialValue: true) {
            _self, selectedProject in
            _self.window?.title = selectedProject?.title ?? "Tribal"
        }
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
}
