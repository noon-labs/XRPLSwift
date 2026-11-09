//
//  AMMDelete.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/AMMDelete.ts

import Foundation

/**
 Delete an empty Automated Market Maker (AMM) instance that could not be fully deleted
 automatically. Normally, an AMMWithdraw that empties the pool deletes the AMM; this
 transaction is only needed when the AMM has too many trust lines to remove at once.
 */
public class AMMDelete: BaseTransaction {
    public var asset: Issue
    public var asset2: Issue

    enum CodingKeys: String, CodingKey {
        case asset = "Asset"
        case asset2 = "Asset2"
    }

    public init(
        account: String,
        asset: Issue,
        asset2: Issue
    ) {
        self.asset = asset
        self.asset2 = asset2
        super.init(account: account, transactionType: "AMMDelete")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AMMDelete.self, from: data)
        self.asset = decoded.asset
        self.asset2 = decoded.asset2
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        asset = try values.decode(Issue.self, forKey: .asset)
        asset2 = try values.decode(Issue.self, forKey: .asset2)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(asset, forKey: .asset)
        try values.encode(asset2, forKey: .asset2)
    }
}

public func validateAMMDelete(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)
    guard let asset = tx["Asset"], isIssue(asset) else {
        throw ValidationError("AMMDelete: invalid or missing Asset")
    }
    guard let asset2 = tx["Asset2"], isIssue(asset2) else {
        throw ValidationError("AMMDelete: invalid or missing Asset2")
    }

}
