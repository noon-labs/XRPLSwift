//
//  MPTokenIssuanceDestroy.swift
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/MPTokenIssuanceDestroy.ts

/**
 The MPTokenIssuanceDestroy transaction is used by the issuer to destroy an
 existing MPTokenIssuance. This is only allowed if the outstanding amount
 across all holders is zero.
 */
public class MPTokenIssuanceDestroy: BaseTransaction {
    public var mptokenIssuanceId: String

    enum CodingKeys: String, CodingKey {
        case mptokenIssuanceId = "MPTokenIssuanceID"
    }

    public init(
        account: String,
        mptokenIssuanceId: String
    ) {
        self.mptokenIssuanceId = mptokenIssuanceId
        super.init(account: account, transactionType: "MPTokenIssuanceDestroy")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(MPTokenIssuanceDestroy.self, from: data)
        self.mptokenIssuanceId = decoded.mptokenIssuanceId
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mptokenIssuanceId = try values.decode(String.self, forKey: .mptokenIssuanceId)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(mptokenIssuanceId, forKey: .mptokenIssuanceId)
    }
}

public func validateMPTokenIssuanceDestroy(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["MPTokenIssuanceID"] == nil {
        throw ValidationError("MPTokenIssuanceDestroy: missing field MPTokenIssuanceID")
    }

    if let id = tx["MPTokenIssuanceID"] as? String, id.count != 48 {
        throw ValidationError("MPTokenIssuanceDestroy: MPTokenIssuanceID must be 48 hex characters (24 bytes)")
    }
}
