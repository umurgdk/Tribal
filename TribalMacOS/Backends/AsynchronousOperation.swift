//
//  AsynchronousOperation.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import Foundation

/// Subclass of `Operation` that adds support of asynchronous operations.
/// 1. Call `super.main()` when override `main` method.
/// 2. When operation is finished or cancelled set `state = .finished` or `finish()`
open class AsynchronousOperation: Operation {
    public override var isAsynchronous: Bool {
        return true
    }
    
    public override var isExecuting: Bool {
        return state == .executing
    }
    
    public override var isFinished: Bool {
        return state == .finished
    }
    
    public override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    open override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
        }
    }
    
    open func finish() {
        state = .finished
    }
    
    // MARK: - State management
    
    public enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    /// Thread-safe computed state value
    public var state: State {
        get {
            sync {
                return stateStore
            }
        }
        set {
            let oldValue = state
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
            sync(flags: .barrier) {
                stateStore = newValue
            }
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    public func sync<T>(work: () throws -> T) rethrows -> T {
        try stateQueue.sync(execute: work)
    }

    
    public func sync<T>(flags: DispatchWorkItemFlags, work: () throws -> T) rethrows -> T {
        try stateQueue.sync(flags: flags, execute: work)
    }
    
    private let stateQueue = DispatchQueue(label: "AsynchronousOperation State Queue", attributes: .concurrent)
    
    /// Non thread-safe state storage, use only with locks
    private var stateStore: State = .ready
}
