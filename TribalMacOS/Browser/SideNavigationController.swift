//
//  SideNavigationController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

class SideNavigationController: BaseViewController {
    @objc public let browserController: BrowserController
    private let observations = ObservationBag()
    init(browserController: BrowserController) {
        self.browserController = browserController
        super.init()
    }
    
    private lazy var navigationDataSource = SideNavigationDataSource(outlineView: navigationView.sourceList)
    private lazy var navigationView = SideNavigationView()
    
    override func loadView() {
        view = navigationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.sourceList.dataSource = navigationDataSource
        navigationView.sourceList.delegate = navigationDataSource
        
        setupObservations()
    }
    
    // MARK: - Observations
    private func setupObservations() {
        observations.observeNew(\.browserController.selectedWorkspace, in: self, withInitialValue: true) {
            _self, workspace in
            guard let workspace = workspace else { return }
            _self.navigationDataSource.setItems(workspace.projects, inSection: .projects)
        }

        observations.observeNew(\.browserController.selectedProject, in: self, withInitialValue: true) {
            _self, selectedProject in
            _self.navigationDataSource.selectItem(selectedProject, inSection: .projects)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(outlineViewSelectionDidChange), name: NSOutlineView.selectionDidChangeNotification, object: navigationView.sourceList)
    }
    
    @objc private func outlineViewSelectionDidChange(_ notification: Notification) {
        if let project: Project = navigationDataSource.selectedItem() {
            browserController.selectedProject = project
        }
    }
}
