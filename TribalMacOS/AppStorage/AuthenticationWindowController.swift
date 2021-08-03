//
//  AuthenticationWindowController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 9.07.2021.
//

import AppKit

class AuthenticationWindowController: NSWindowController {
    static func create() -> AuthenticationWindowController {
        let viewController = AuthenticationViewController()
        let window = NSWindow(contentViewController: viewController)
        return AuthenticationWindowController(window: window)
    }
}
