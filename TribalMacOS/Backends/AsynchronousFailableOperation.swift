//
//  AsynchronousFailableOperation.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import Foundation

class AsynchronousFailableOperation<Value, Failure: Error>: AsynchronousOperation {
    private var _result: Result<Value, Error>?
    public private(set) var result: Result<Value, Error>? {
        get { sync { self._result } }
        set { sync { _result = newValue } }
    }
    
    override func finish() {
        fatalError("Please use finish(with:)")
    }
    
    public func finish(with result: Result<Value, Error>) {
        self.result = result
        super.finish()
    }
}
