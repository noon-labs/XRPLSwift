//
//  AMMBid.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/AMMBid.ts

import Foundation

// swiftlint:disable:next identifier_name
public let AMM_MAX_AUTH_ACCOUNTS: Int = 4

/// `{"AuthAccount": {"Account": "r..."}}` entry of `AuthAccounts`.
/// Named AMMAuthAccount (not AuthAccount) so it does not collide with app-side models of the same name.
public struct AMMAuthAccountWrapper: Codable, Equatable {
    public var authAccount: AMMAuthAccount

    enum CodingKeys: String, CodingKey {
        case authAccount = "AuthAccount"
    }

    public init(account: String) {
        self.authAccount = AMMAuthAccount(account: account)
    }
}

public struct AMMAuthAccount: Codable, Equatable {
    public var account: String

    enum CodingKeys: String, CodingKey {
        case account = "Account"
    }

    public init(account: String) {
        self.account = account
    }
}

/**
 Bid on an Automated Market Maker's (AMM's) auction slot. If you win, you can trade
 against the AMM at a discounted fee until you are outbid or 24 hours have passed.
 The bid is paid in the AMM's LP Tokens.
 */
public class AMMBid: BaseTransaction {
    public var asset: Issue
    public var asset2: Issue
    public var bidMin: Amount?
    public var bidMax: Amount?
    public var authAccounts: [AMMAuthAccountWrapper]?

    enum CodingKeys: String, CodingKey {
        case asset = "Asset"
        case asset2 = "Asset2"
        case bidMin = "BidMin"
        case bidMax = "BidMax"
        case authAccounts = "AuthAccounts"
    }

    public init(
        account: String,
        asset: Issue,
        asset2: Issue,
        bidMin: Amount? = nil,
        bidMax: Amount? = nil,
        authAccounts: [AMMAuthAccountWrapper]? = nil
    ) {
        self.asset = asset
        self.asset2 = asset2
        self.bidMin = bidMin
        self.bidMax = bidMax
        self.authAccounts = authAccounts
        super.init(account: account, transactionType: "AMMBid")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AMMBid.self, from: data)
        self.asset = decoded.asset
        self.asset2 = decoded.asset2
        self.bidMin = decoded.bidMin
        self.bidMax = decoded.bidMax
        self.authAccounts = decoded.authAccounts
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        asset = try values.decode(Issue.self, forKey: .asset)
        asset2 = try values.decode(Issue.self, forKey: .asset2)
        bidMin = try values.decodeIfPresent(Amount.self, forKey: .bidMin)
        bidMax = try values.decodeIfPresent(Amount.self, forKey: .bidMax)
        authAccounts = try values.decodeIfPresent([AMMAuthAccountWrapper].self, forKey: .authAccounts)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(asset, forKey: .asset)
        try values.encode(asset2, forKey: .asset2)
        if let bidMin = bidMin { try values.encode(bidMin, forKey: .bidMin) }
        if let bidMax = bidMax { try values.encode(bidMax, forKey: .bidMax) }
        if let authAccounts = authAccounts { try values.encode(authAccounts, forKey: .authAccounts) }
    }
}

public func validateAMMBid(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)
    guard let asset = tx["Asset"], isIssue(asset) else {
        throw ValidationError("AMMBid: invalid or missing Asset")
    }
    guard let asset2 = tx["Asset2"], isIssue(asset2) else {
        throw ValidationError("AMMBid: invalid or missing Asset2")
    }
    if let value = tx["BidMin"], !isAmount(amount: value) {
        throw ValidationError("AMMBid: invalid BidMin")
    }
    if let value = tx["BidMax"], !isAmount(amount: value) {
        throw ValidationError("AMMBid: invalid BidMax")
    }
    if let authAccounts = tx["AuthAccounts"] {
        guard let authAccounts = authAccounts as? [[String: AnyObject]] else {
            throw ValidationError("AMMBid: invalid AuthAccounts")
        }
        if authAccounts.count > AMM_MAX_AUTH_ACCOUNTS {
            throw ValidationError("AMMBid: AuthAccounts length must not be greater than \(AMM_MAX_AUTH_ACCOUNTS)")
        }
        for wrapper in authAccounts {
            guard let authAccount = wrapper["AuthAccount"] as? [String: AnyObject],
                  let account = authAccount["Account"] as? String else {
                throw ValidationError("AMMBid: invalid AuthAccounts")
            }
            if account == tx["Account"] as? String {
                throw ValidationError("AMMBid: AuthAccounts must not include sender's address")
            }
        }
    }

}
