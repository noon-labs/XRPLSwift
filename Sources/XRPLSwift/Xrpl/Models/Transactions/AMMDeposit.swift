//
//  AMMDeposit.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/AMMDeposit.ts

import Foundation

public enum AMMDepositFlags: Int {
    case tfLPToken = 0x00010000
    case tfSingleAsset = 0x00080000
    case tfTwoAsset = 0x00100000
    case tfOneAssetLPToken = 0x00200000
    case tfLimitLPToken = 0x00400000
    case tfTwoAssetIfEmpty = 0x00800000
}

/**
 Deposit funds into an Automated Market Maker (AMM) instance and receive the AMM's
 liquidity provider tokens (LP Tokens) in exchange. You can deposit one or both of
 the assets in the AMM's pool. The deposit mode is chosen with `Flags`.
 */
public class AMMDeposit: BaseTransaction {
    public var asset: Issue
    public var asset2: Issue
    public var amount: Amount?
    public var amount2: Amount?
    public var ePrice: Amount?
    public var lpTokenOut: IssuedCurrencyAmount?
    public var tradingFee: Int?

    enum CodingKeys: String, CodingKey {
        case asset = "Asset"
        case asset2 = "Asset2"
        case amount = "Amount"
        case amount2 = "Amount2"
        case ePrice = "EPrice"
        case lpTokenOut = "LPTokenOut"
        case tradingFee = "TradingFee"
    }

    public init(
        account: String,
        asset: Issue,
        asset2: Issue,
        amount: Amount? = nil,
        amount2: Amount? = nil,
        ePrice: Amount? = nil,
        lpTokenOut: IssuedCurrencyAmount? = nil,
        tradingFee: Int? = nil
    ) {
        self.asset = asset
        self.asset2 = asset2
        self.amount = amount
        self.amount2 = amount2
        self.ePrice = ePrice
        self.lpTokenOut = lpTokenOut
        self.tradingFee = tradingFee
        super.init(account: account, transactionType: "AMMDeposit")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AMMDeposit.self, from: data)
        self.asset = decoded.asset
        self.asset2 = decoded.asset2
        self.amount = decoded.amount
        self.amount2 = decoded.amount2
        self.ePrice = decoded.ePrice
        self.lpTokenOut = decoded.lpTokenOut
        self.tradingFee = decoded.tradingFee
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        asset = try values.decode(Issue.self, forKey: .asset)
        asset2 = try values.decode(Issue.self, forKey: .asset2)
        amount = try values.decodeIfPresent(Amount.self, forKey: .amount)
        amount2 = try values.decodeIfPresent(Amount.self, forKey: .amount2)
        ePrice = try values.decodeIfPresent(Amount.self, forKey: .ePrice)
        lpTokenOut = try values.decodeIfPresent(IssuedCurrencyAmount.self, forKey: .lpTokenOut)
        tradingFee = try values.decodeIfPresent(Int.self, forKey: .tradingFee)
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
        if let lpTokenOut = lpTokenOut { try values.encode(lpTokenOut, forKey: .lpTokenOut) }
        if let tradingFee = tradingFee { try values.encode(tradingFee, forKey: .tradingFee) }
    }
}

public func validateAMMDeposit(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)
    guard let asset = tx["Asset"], isIssue(asset) else {
        throw ValidationError("AMMDeposit: invalid or missing Asset")
    }
    guard let asset2 = tx["Asset2"], isIssue(asset2) else {
        throw ValidationError("AMMDeposit: invalid or missing Asset2")
    }
    if tx["Amount2"] != nil && tx["Amount"] == nil {
        throw ValidationError("AMMDeposit: must set Amount with Amount2")
    } else if tx["EPrice"] != nil && tx["Amount"] == nil {
        throw ValidationError("AMMDeposit: must set Amount with EPrice")
    } else if tx["LPTokenOut"] == nil && tx["Amount"] == nil {
        throw ValidationError("AMMDeposit: must set at least LPTokenOut or Amount")
    }
    if let value = tx["LPTokenOut"], !isIssuedCurrency(input: value) {
        throw ValidationError("AMMDeposit: invalid LPTokenOut")
    }
    if let value = tx["Amount"], !isAmount(amount: value) {
        throw ValidationError("AMMDeposit: invalid Amount")
    }
    if let value = tx["Amount2"], !isAmount(amount: value) {
        throw ValidationError("AMMDeposit: invalid Amount2")
    }
    if let value = tx["EPrice"], !isAmount(amount: value) {
        throw ValidationError("AMMDeposit: invalid EPrice")
    }

}
