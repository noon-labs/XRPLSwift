//
//  IssueModel.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/common/index.ts (Currency / IssuedCurrency)

import Foundation

/**
 An asset without an amount: XRP (`{"currency": "XRP"}`) or an issued currency
 (`{"currency": "USD", "issuer": "r..."}`). Used by the AMM `Asset`/`Asset2` fields.
 */
public struct Issue: Codable, Equatable {
    public var currency: String
    public var issuer: String?

    enum CodingKeys: String, CodingKey {
        case currency
        case issuer
    }

    public init(currency: String, issuer: String? = nil) {
        self.currency = currency
        self.issuer = issuer
    }

    public static let xrp = Issue(currency: "XRP")

    public var isXrp: Bool { issuer == nil && currency == "XRP" }
}

/**
 Verify the form and type of an Issue at runtime.
 - parameters:
    - input: The object to check the form and type of.
 - returns:
 Whether the input is a well-formed Issue.
 */
public func isIssue(_ input: Any) -> Bool {
    guard let input = input as? [String: AnyObject],
          let currency = input["currency"] as? String else {
        return false
    }
    if currency == "XRP" {
        return input.count == 1
    }
    return input.count == 2 && input["issuer"] is String
}
