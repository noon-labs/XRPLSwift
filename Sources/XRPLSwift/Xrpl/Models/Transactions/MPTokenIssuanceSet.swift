//
//  MPTokenIssuanceSet.swift
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/MPTokenIssuanceSet.ts

public enum MPTokenIssuanceSetFlags: Int {
    case tfMPTLock = 0x00000001
    case tfMPTUnlock = 0x00000002
}

/**
 The MPTokenIssuanceSet transaction modifies an existing MPTokenIssuance.
 Used by the issuer to lock/unlock the issuance globally, or — when `Holder`
 is set — to lock/unlock for a specific holder. The issuance must have been
 created with `tfMPTCanLock` for lock/unlock to be valid.
 */
public class MPTokenIssuanceSet: BaseTransaction {
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
        super.init(account: account, transactionType: "MPTokenIssuanceSet")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(MPTokenIssuanceSet.self, from: data)
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

public func validateMPTokenIssuanceSet(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["MPTokenIssuanceID"] == nil {
        throw ValidationError("MPTokenIssuanceSet: missing field MPTokenIssuanceID")
    }

    if let id = tx["MPTokenIssuanceID"] as? String, id.count != 48 {
        throw ValidationError("MPTokenIssuanceSet: MPTokenIssuanceID must be 48 hex characters (24 bytes)")
    }
}
