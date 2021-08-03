//
//  AsanaContextPrepareOperation.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import Foundation

class AsanaContextPrepareOperation: AsynchronousOperation  {
    weak var context: AsanaEntityContext?
    let api: AsanaAuthenticatedAPI
    let completionHandler: (Result<AsanaUser, AsanaAPIError>) -> Void
    
    init(context: AsanaEntityContext, api: AsanaAuthenticatedAPI, _ completion: @escaping (Result<AsanaUser, AsanaAPIError>) -> Void) {
        self.context = context
        self.api = api
        self.completionHandler = completion
        super.init()
    }
    
    override func main() {
        super.main()
        self.finish()
        // api.fetchAuthenticatedUser { result in
        //     guard let context = self.context else { return }
        //     context.sync(flags: .barrier) {
        //         self.completionHandler(result)
        //     }
        //
        //     self.finish()
        // }
    }
}
