//
//  ContextBrowserViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import AppKit

class ContextBrowserViewController: BaseViewController {
    private lazy var pickerController = ContextPickerViewController()
    private lazy var contentViewController = HeadlessTabViewController()
    
    public var makeOnboardingViewController: (() -> NSViewController)?
    public var selectedContext: EntityContext? {
        didSet {
            if let context = selectedContext {
                context.prepare()
                presentContext(context)
            }
        }
    }
    
    public override func loadView() {
        addChild(pickerController)
        addChild(contentViewController)
        
        view = ContextBrowserView(
            pickerView: pickerController.view,
            contentView: contentViewController.view
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(contextStateDidChange(_:)), name: .entityContextStateDidChange, object: nil)
    }
    
    public func setContexts(_ contexts: [EntityContext]) {
        pickerController.setContexts(contexts)
        
        if let selectedContext = selectedContext, let context = contexts.first, selectedContext === context {
            return
        } else if let context = contexts.first {
            pickerController.selectContext(context)
            selectedContext = context
        } else if contexts.isEmpty {
            renderOnboarding()
        }
        
        view.needsLayout = true
    }
    
    private func presentContext(_ context: EntityContext) {
        if case .ready = context.state {
            presentBrowser(context)
        } else if case let .failedToPrepare(error) = context.state {
            print("ERROR:", error.localizedDescription)
            contentViewController.presentError(error)
        } else {
            contentViewController.presentViewController(LoadingViewController())
        }
    }
    
    private func presentBrowser(_ context: EntityContext) {
        let browserController = BrowserController(context: context)
        let browserVC = BrowserViewController(browserController: browserController)
        contentViewController.presentViewController(browserVC)
    }
    
    @objc private func contextStateDidChange(_ notification: Notification) {
        guard let selectedContext = selectedContext,
              let notificationContext = notification.object as? EntityContext,
              notificationContext === selectedContext
        else {
            return
        }
        
        presentContext(selectedContext)
    }
    
    private func renderOnboarding() {
        if let onboardingMaker = makeOnboardingViewController {
            contentViewController.presentViewController(onboardingMaker())
        }
    }
}

extension ContextBrowserViewController: ContextPickerDelegate {
    func contextPickerDidPickContext(_ context: EntityContext) {
        selectedContext = context
    }
}
