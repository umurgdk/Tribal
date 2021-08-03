//
//  EntityContext.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import Foundation

public extension NSNotification.Name {
    static let entityContextStateDidChange: Self = .init("EntityContextStateDidChange")
    static let entityContextPreparationFailed: Self = .init("EntityContextPreparationFailed")
}

public protocol EntityContext: AnyObject {
    var state: EntityContextState { get }
    var workspaces: [Workspace] { get }
    
    func prepare()
}

public enum EntityContextState {
    case idle
    case loading
    case ready
    case failedToPrepare(Error)
}
