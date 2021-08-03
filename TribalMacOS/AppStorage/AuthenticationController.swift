//
//  AuthenticationController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 9.07.2021.
//

import Foundation
import AuthenticationServices
import KeychainSwift

class AuthenticationController {
    static let shared = AuthenticationController()
    public func storeSecureToken(service: String, account: String, token: Data) {
        fatalError()
    }
    
    public func getSecureToken(service: String, account: String) -> Data? {
        fatalError()
    }
}

public enum AuthenticationError: LocalizedError {
    case networkError(Error)
    case invalidPayload(Error?)
    case unsuccessful(Int, Data?)
    
    public var failureReason: String? {
        switch self {
        case .networkError(let error as LocalizedError): return error.failureReason
        case .invalidPayload(let error as LocalizedError): return error.failureReason
        default:
            return nil
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .invalidPayload(let error?):
            return error.localizedDescription
        case .invalidPayload(_):
            return "Invalid payload"
        case let .unsuccessful(statusCode, data):
            let response = data.flatMap { String(data: $0, encoding: .utf8) } ?? "N/A"
            return "Unsuccessful, status code: \(statusCode), response: \(response)"
        }
    }
}
