//
//  AMMVote.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/AMMVote.ts

import Foundation

/**
 Vote on the trading fee for an Automated Market Maker (AMM) instance. Up to 8 accounts
 can vote in proportion to the amount of the AMM's LP Tokens they hold.
 */
public class AMMVote: BaseTransaction {
    public var asset: Issue
    public var asset2: Issue
    public var tradingFee: Int

    enum CodingKeys: String, CodingKey {
        case asset = "Asset"
        case asset2 = "Asset2"
        case tradingFee = "TradingFee"
    }

    public init(
        account: String,
        asset: Issue,
        asset2: Issue,
        tradingFee: Int
    ) {
        self.asset = asset
        self.asset2 = asset2
        self.tradingFee = tradingFee
        super.init(account: account, transactionType: "AMMVote")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AMMVote.self, from: data)
        self.asset = decoded.asset
        self.asset2 = decoded.asset2
        self.tradingFee = decoded.tradingFee
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        asset = try values.decode(Issue.self, forKey: .asset)
        asset2 = try values.decode(Issue.self, forKey: .asset2)
        tradingFee = try values.decode(Int.self, forKey: .tradingFee)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(asset, forKey: .asset)
        try values.encode(asset2, forKey: .asset2)
        try values.encode(tradingFee, forKey: .tradingFee)
    }
}

public func validateAMMVote(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)
    guard let asset = tx["Asset"], isIssue(asset) else {
        throw ValidationError("AMMVote: invalid or missing Asset")
    }
    guard let asset2 = tx["Asset2"], isIssue(asset2) else {
        throw ValidationError("AMMVote: invalid or missing Asset2")
    }
    guard let tradingFee = tx["TradingFee"] as? Int else {
        throw ValidationError("AMMVote: invalid or missing TradingFee")
    }
    if tradingFee < 0 || tradingFee > AMM_MAX_TRADING_FEE {
        throw ValidationError("AMMVote: TradingFee must be between 0 and \(AMM_MAX_TRADING_FEE)")
    }

}
