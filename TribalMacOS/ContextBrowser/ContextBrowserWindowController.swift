//
//  ContextBrowserWindowController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 15.07.2021.
//

import AppKit

extension NSToolbar.Identifier {
    static var browserMain: NSToolbar.Identifier { "BrowserMainToolbar" }
}

class ContextBrowserWindowController: NSWindowController, NSWindowDelegate {
    static func create(onboardingViewControllerBuilder: @escaping () -> NSViewController) -> ContextBrowserWindowController {
        NSStoryboard(name: "ContextBrowser", bundle: nil).instantiateInitialController { coder in
            ContextBrowserWindowController(coder: coder, onboardingMaker: onboardingViewControllerBuilder)
        }!
    }
    
    private let observations = ObservationBag()
    private lazy var toolbarDelegate = ContextBrowserWindowToolbarDelegate()
    
    private let onboardingMaker: () -> NSViewController
    init?(coder: NSCoder, onboardingMaker: @escaping () -> NSViewController) {
        self.onboardingMaker = onboardingMaker
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let window = window else { return }
        configureToolbar(window: window)
        window.subtitle = "You have 8 tasks"
        window.titlebarSeparatorStyle = .none
        
        let contextBrowser = ContextBrowserViewController()
        contextBrowser.makeOnboardingViewController = onboardingMaker
        contextBrowser.setContexts(contexts)
        window.contentViewController = contextBrowser
        
        windowFrameAutosaveName = NSWindow.FrameAutosaveName("ContextBrowserWindow")
     
        // observations.observeNew(\.browserController.selectedProject, in: self, withInitialValue: true) {
        //     _self, selectedProject in
        //     _self.window?.title = selectedProject?.title ?? "Tribal"
        // }
    }
    
    public var contexts: [EntityContext] = [] {
        didSet {
            if isWindowLoaded {
                (contentViewController as! ContextBrowserViewController).setContexts(contexts)
            }
        }
    }
    
    private func configureToolbar(window: NSWindow) {
        let toolbar = NSToolbar(identifier: .browserMain)
        toolbar.delegate = toolbarDelegate
        toolbar.allowsUserCustomization = true
        toolbar.autosavesConfiguration = true
        toolbar.displayMode = .iconOnly
        toolbar.showsBaselineSeparator = false
        window.toolbarStyle = .unified
        window.toolbar = toolbar
    }
}
