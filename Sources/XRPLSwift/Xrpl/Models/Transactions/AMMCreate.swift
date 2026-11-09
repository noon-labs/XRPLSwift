//
//  AMMCreate.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/AMMCreate.ts

import Foundation

/// TradingFee is in units of 1/100,000; 1000 = 1%.
// swiftlint:disable:next identifier_name
public let AMM_MAX_TRADING_FEE: Int = 1000

/**
 Create a new Automated Market Maker (AMM) instance for trading a pair of assets.
 Creates both an AMM entry and a special AccountRoot entry to represent the AMM.
 Also transfers ownership of the starting balance of both assets from the sender to
 the created AMM account and issues an initial balance of liquidity provider tokens
 (LP Tokens) to the sender.
 */
public class AMMCreate: BaseTransaction {
    public var amount: Amount
    public var amount2: Amount
    public var tradingFee: Int

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case amount2 = "Amount2"
        case tradingFee = "TradingFee"
    }

    public init(
        account: String,
        amount: Amount,
        amount2: Amount,
        tradingFee: Int
    ) {
        self.amount = amount
        self.amount2 = amount2
        self.tradingFee = tradingFee
        super.init(account: account, transactionType: "AMMCreate")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AMMCreate.self, from: data)
        self.amount = decoded.amount
        self.amount2 = decoded.amount2
        self.tradingFee = decoded.tradingFee
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decode(Amount.self, forKey: .amount)
        amount2 = try values.decode(Amount.self, forKey: .amount2)
        tradingFee = try values.decode(Int.self, forKey: .tradingFee)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(amount, forKey: .amount)
        try values.encode(amount2, forKey: .amount2)
        try values.encode(tradingFee, forKey: .tradingFee)
    }
}

public func validateAMMCreate(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)
    guard let amount = tx["Amount"], isAmount(amount: amount) else {
        throw ValidationError("AMMCreate: invalid or missing Amount")
    }
    guard let amount2 = tx["Amount2"], isAmount(amount: amount2) else {
        throw ValidationError("AMMCreate: invalid or missing Amount2")
    }
    guard let tradingFee = tx["TradingFee"] as? Int else {
        throw ValidationError("AMMCreate: invalid or missing TradingFee")
    }
    if tradingFee < 0 || tradingFee > AMM_MAX_TRADING_FEE {
        throw ValidationError("AMMCreate: TradingFee must be between 0 and \(AMM_MAX_TRADING_FEE)")
    }

}
