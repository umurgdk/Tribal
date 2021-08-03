//
//  Account.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import Foundation

public struct Account: Equatable, Codable {
    public let id: String
    public let provider: String
    public let credentials: Data
}
