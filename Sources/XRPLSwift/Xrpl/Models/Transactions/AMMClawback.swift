//
//  AMMClawback.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/AMMClawback.ts

import Foundation

public enum AMMClawbackFlags: Int {
    case tfClawTwoAssets = 0x00000001
}

/**
 Claw back tokens from a holder who has deposited your issued tokens into an AMM pool.
 Only the issuer of `Asset` can send this (Clawback amendment).
 */
public class AMMClawback: BaseTransaction {
    public var holder: String
    public var asset: Issue
    public var asset2: Issue
    public var amount: IssuedCurrencyAmount?

    enum CodingKeys: String, CodingKey {
        case holder = "Holder"
        case asset = "Asset"
        case asset2 = "Asset2"
        case amount = "Amount"
    }

    public init(
        account: String,
        holder: String,
        asset: Issue,
        asset2: Issue,
        amount: IssuedCurrencyAmount? = nil
    ) {
        self.holder = holder
        self.asset = asset
        self.asset2 = asset2
        self.amount = amount
        super.init(account: account, transactionType: "AMMClawback")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AMMClawback.self, from: data)
        self.holder = decoded.holder
        self.asset = decoded.asset
        self.asset2 = decoded.asset2
        self.amount = decoded.amount
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        holder = try values.decode(String.self, forKey: .holder)
        asset = try values.decode(Issue.self, forKey: .asset)
        asset2 = try values.decode(Issue.self, forKey: .asset2)
        amount = try values.decodeIfPresent(IssuedCurrencyAmount.self, forKey: .amount)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(holder, forKey: .holder)
        try values.encode(asset, forKey: .asset)
        try values.encode(asset2, forKey: .asset2)
        if let amount = amount { try values.encode(amount, forKey: .amount) }
    }
}

public func validateAMMClawback(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)
    guard let holder = tx["Holder"] as? String, !holder.isEmpty else {
        throw ValidationError("AMMClawback: invalid or missing Holder")
    }
    guard let asset = tx["Asset"], isIssue(asset) else {
        throw ValidationError("AMMClawback: invalid or missing Asset")
    }
    guard let asset2 = tx["Asset2"], isIssue(asset2) else {
        throw ValidationError("AMMClawback: invalid or missing Asset2")
    }
    let assetDict = asset as! [String: AnyObject]
    guard let assetIssuer = assetDict["issuer"] as? String else {
        throw ValidationError("AMMClawback: Asset must be an issued currency")
    }
    if holder == assetIssuer {
        throw ValidationError("AMMClawback: Holder and Asset.issuer must be distinct")
    }
    if tx["Account"] as? String != assetIssuer {
        throw ValidationError("AMMClawback: Account must be the same as Asset.issuer")
    }
    if let amount = tx["Amount"] {
        guard let amount = amount as? [String: AnyObject], isIssuedCurrency(input: amount) else {
            throw ValidationError("AMMClawback: invalid Amount")
        }
        if amount["currency"] as? String != assetDict["currency"] as? String {
            throw ValidationError("AMMClawback: Amount.currency must match Asset.currency")
        }
        if amount["issuer"] as? String != assetIssuer {
            throw ValidationError("AMMClawback: Amount.issuer must match Asset.issuer")
        }
    }

}
