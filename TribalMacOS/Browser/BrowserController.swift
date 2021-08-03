//
//  BrowserController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

class BrowserController: NSObject {
    @objc dynamic public var workspaces: [Workspace] = []
    @objc dynamic public var selectedWorkspace: Workspace?
    @objc dynamic public var selectedProject: Project?
    @objc dynamic public var selectedTask: Task?
    
    public init(context: EntityContext) {
        self.workspaces = context.workspaces
        super.init()
        
        selectedWorkspace = workspaces.first
    }
}
