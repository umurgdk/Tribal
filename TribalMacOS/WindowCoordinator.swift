//
//  WindowCoordinator.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

class WindowCoordinator {
    public static let shared = WindowCoordinator()
    public private(set) var windowControllers: [NSWindowController] = []
    
    public func add(_ windowController: NSWindowController) {
        windowControllers.append(windowController)
        
        if let window = windowController.window {
            NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose), name: NSWindow.willCloseNotification, object: window)
        }
    }
    
    @objc private func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        windowControllers = windowControllers.filter { $0.window != window }
    }
}
