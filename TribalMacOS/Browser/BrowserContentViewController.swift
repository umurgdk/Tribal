//
//  BrowserContentViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

class BrowserInitialContentViewController: BaseViewController {
    override func loadView() {
        view = NSView()
    }
}

class BrowserContentViewController: NSTabViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.wantsLayer = true
        
        tabStyle = .unspecified
        transitionOptions = .crossfade
    }
    
    public func presentViewController(_ viewController: NSViewController) {
        let tabViewItem = NSTabViewItem(viewController: viewController)
        addTabViewItem(tabViewItem)
        selectedTabViewItemIndex = tabViewItems.count - 1
    }
    
    override func transition(from fromViewController: NSViewController, to toViewController: NSViewController, options: NSViewController.TransitionOptions = [], completionHandler completion: (() -> Void)? = nil) {
        super.transition(from: fromViewController, to: toViewController, options: options) {
            completion?()
            let previousItem = self.tabViewItems.first { $0.viewController == fromViewController }
            if let item = previousItem {
                self.removeTabViewItem(item)
            }
        }
    }
}
