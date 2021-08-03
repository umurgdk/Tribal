//
//  AsanaEntityContext.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import Foundation

public class AsanaEntityContext: EntityContext {
    private let api: AsanaAuthenticatedAPI
    private let notificationCenter: NotificationCenter
    private let queue: DispatchQueue
    private let operationQueue: OperationQueue
    
    public private(set) var state: EntityContextState = .idle {
        didSet {
            notificationCenter.post(name: .entityContextStateDidChange, object: self)
        }
    }
    
    var user: AsanaUser?
    public internal(set) lazy var workspaces: [Workspace] = [
        Workspace(context: self, id: "test", projects: [
            Project(title: "Tribal macOS", tasks: Demo.tasks.shuffled())
        ])
    ]
    
    init(api: AsanaAuthenticatedAPI, queue: OperationQueue? = nil, notificationCenter: NotificationCenter = .default) {
        self.api = api
        self.notificationCenter = notificationCenter
        self.queue = DispatchQueue.main
        self.operationQueue = OperationQueue().configure {
            $0.maxConcurrentOperationCount = 1
            $0.qualityOfService = .userInitiated
            $0.name = "AsanaEntityContextOperationQueue"
        }        
    }
    
    public func prepare() {
        if case .loading = state {
            return
        }
        
        if case .ready = state {
            return
        }
        
        DispatchQueue.main.async {
            self.state = .ready
        }
        
        // operationQueue.addOperation(AsanaContextPrepareOperation(context: self, api: api) { [weak self] result in
        //     guard let self = self else { return }
        //     switch result {
        //     case .success(let user):
        //         self.user = user
        //         self.workspaces = user.workspaces.map { workspace in
        //             Workspace(context: self, id: workspace.gid)
        //         }
        //         self.state = .ready
        //     case .failure(let error):
        //         self.state = .failedToPrepare(error)
        //     }
        // })
    }
    
    func sync<T>(flags: DispatchWorkItemFlags, work: () throws -> T) rethrows -> T {
        try queue.sync(flags: flags, execute: work)
    }
}
