//
//  AMMWithdraw.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/AMMWithdraw.ts

import Foundation

public enum AMMWithdrawFlags: Int {
    case tfLPToken = 0x00010000
    case tfWithdrawAll = 0x00020000
    case tfOneAssetWithdrawAll = 0x00040000
    case tfSingleAsset = 0x00080000
    case tfTwoAsset = 0x00100000
    case tfOneAssetLPToken = 0x00200000
    case tfLimitLPToken = 0x00400000
}

/**
 Withdraw assets from an Automated Market Maker (AMM) instance by returning the AMM's
 liquidity provider tokens (LP Tokens). The withdraw mode is chosen with `Flags`.
 */
public class AMMWithdraw: BaseTransaction {
    public var asset: Issue
    public var asset2: Issue
    public var amount: Amount?
    public var amount2: Amount?
    public var ePrice: Amount?
    public var lpTokenIn: IssuedCurrencyAmount?

    enum CodingKeys: String, CodingKey {
        case asset = "Asset"
        case asset2 = "Asset2"
        case amount = "Amount"
        case amount2 = "Amount2"
        case ePrice = "EPrice"
        case lpTokenIn = "LPTokenIn"
    }

    public init(
        account: String,
        asset: Issue,
        asset2: Issue,
        amount: Amount? = nil,
        amount2: Amount? = nil,
        ePrice: Amount? = nil,
        lpTokenIn: IssuedCurrencyAmount? = nil
    ) {
        self.asset = asset
        self.asset2 = asset2
        self.amount = amount
        self.amount2 = amount2
        self.ePrice = ePrice
        self.lpTokenIn = lpTokenIn
        super.init(account: account, transactionType: "AMMWithdraw")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AMMWithdraw.self, from: data)
        self.asset = decoded.asset
        self.asset2 = decoded.asset2
        self.amount = decoded.amount
        self.amount2 = decoded.amount2
        self.ePrice = decoded.ePrice
        self.lpTokenIn = decoded.lpTokenIn
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        asset = try values.decode(Issue.self, forKey: .asset)
        asset2 = try values.decode(Issue.self, forKey: .asset2)
        amount = try values.decodeIfPresent(Amount.self, forKey: .amount)
        amount2 = try values.decodeIfPresent(Amount.self, forKey: .amount2)
        ePrice = try values.decodeIfPresent(Amount.self, forKey: .ePrice)
        lpTokenIn = try values.decodeIfPresent(IssuedCurrencyAmount.self, forKey: .lpTokenIn)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(asset, forKey: .asset)
        try values.encode(asset2, forKey: .asset2)
        if let amount = amount { try values.encode(amount, forKey: .amount) }
        if let amount2 = amount2 { try values.encode(amount2, forKey: .amount2) }
        if let ePrice = ePrice { try values.encode(ePrice, forKey: .ePrice) }
        if let lpTokenIn = lpTokenIn { try values.encode(lpTokenIn, forKey: .lpTokenIn) }
    }
}

public func validateAMMWithdraw(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)
    guard let asset = tx["Asset"], isIssue(asset) else {
        throw ValidationError("AMMWithdraw: invalid or missing Asset")
    }
    guard let asset2 = tx["Asset2"], isIssue(asset2) else {
        throw ValidationError("AMMWithdraw: invalid or missing Asset2")
    }
    if tx["Amount2"] != nil && tx["Amount"] == nil {
        throw ValidationError("AMMWithdraw: must set Amount with Amount2")
    } else if tx["EPrice"] != nil && tx["Amount"] == nil {
        throw ValidationError("AMMWithdraw: must set Amount with EPrice")
    }
    if let value = tx["LPTokenIn"], !isIssuedCurrency(input: value) {
        throw ValidationError("AMMWithdraw: invalid LPTokenIn")
    }
    if let value = tx["Amount"], !isAmount(amount: value) {
        throw ValidationError("AMMWithdraw: invalid Amount")
    }
    if let value = tx["Amount2"], !isAmount(amount: value) {
        throw ValidationError("AMMWithdraw: invalid Amount2")
    }
    if let value = tx["EPrice"], !isAmount(amount: value) {
        throw ValidationError("AMMWithdraw: invalid EPrice")
    }

}
