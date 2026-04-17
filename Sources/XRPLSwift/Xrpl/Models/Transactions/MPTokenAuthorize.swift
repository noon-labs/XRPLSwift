//
//  MPTokenAuthorize.swift
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/MPTokenAuthorize.ts

public enum MPTokenAuthorizeFlags: Int {
    case tfMPTUnauthorize = 0x00000001
}

/**
 The MPTokenAuthorize transaction is used to either:
 - As a holder: opt in to (or out of) holding a particular MPTokenIssuance.
 - As an issuer (with `Holder` set): authorize (or revoke) a specific holder
   for an MPTokenIssuance whose `lsfMPTRequireAuth` flag is set.
 */
public class MPTokenAuthorize: BaseTransaction {
    public var mptokenIssuanceId: String

    public var holder: String?

    enum CodingKeys: String, CodingKey {
        case mptokenIssuanceId = "MPTokenIssuanceID"
        case holder = "Holder"
    }

    public init(
        account: String,
        mptokenIssuanceId: String,
        holder: String? = nil
    ) {
        self.mptokenIssuanceId = mptokenIssuanceId
        self.holder = holder
        super.init(account: account, transactionType: "MPTokenAuthorize")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(MPTokenAuthorize.self, from: data)
        self.mptokenIssuanceId = decoded.mptokenIssuanceId
        self.holder = decoded.holder
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mptokenIssuanceId = try values.decode(String.self, forKey: .mptokenIssuanceId)
        holder = try values.decodeIfPresent(String.self, forKey: .holder)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(mptokenIssuanceId, forKey: .mptokenIssuanceId)
        if let holder = holder { try values.encode(holder, forKey: .holder) }
    }
}

/**
 Verify the form and type of an MPTokenAuthorize at runtime.
 - parameters:
 - tx: An MPTokenAuthorize Transaction.
 - throws:
 When the MPTokenAuthorize is Malformed.
 */
public func validateMPTokenAuthorize(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["MPTokenIssuanceID"] == nil {
        throw ValidationError("MPTokenAuthorize: missing field MPTokenIssuanceID")
    }

    if let id = tx["MPTokenIssuanceID"] as? String, id.count != 48 {
        throw ValidationError("MPTokenAuthorize: MPTokenIssuanceID must be 48 hex characters (24 bytes)")
    }
}
