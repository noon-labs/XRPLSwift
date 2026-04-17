//
//  MPTokenIssuanceCreate.swift
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/MPTokenIssuanceCreate.ts

public enum MPTokenIssuanceCreateFlags: Int {
    case tfMPTCanLock = 0x00000002
    case tfMPTRequireAuth = 0x00000004
    case tfMPTCanEscrow = 0x00000008
    case tfMPTCanTrade = 0x00000010
    case tfMPTCanTransfer = 0x00000020
    case tfMPTCanClawback = 0x00000040
}

/**
 The MPTokenIssuanceCreate transaction creates a new `MPTokenIssuance` ledger
 entry, defining the properties of a new Multi-Purpose Token. The newly
 created issuance is owned by the issuer (`Account`).
 */
public class MPTokenIssuanceCreate: BaseTransaction {
    public var assetScale: Int?

    public var transferFee: Int?

    public var maximumAmount: String?

    public var mptokenMetadata: String?

    enum CodingKeys: String, CodingKey {
        case assetScale = "AssetScale"
        case transferFee = "TransferFee"
        case maximumAmount = "MaximumAmount"
        case mptokenMetadata = "MPTokenMetadata"
    }

    public init(
        account: String,
        assetScale: Int? = nil,
        transferFee: Int? = nil,
        maximumAmount: String? = nil,
        mptokenMetadata: String? = nil
    ) {
        self.assetScale = assetScale
        self.transferFee = transferFee
        self.maximumAmount = maximumAmount
        self.mptokenMetadata = mptokenMetadata
        super.init(account: account, transactionType: "MPTokenIssuanceCreate")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(MPTokenIssuanceCreate.self, from: data)
        self.assetScale = decoded.assetScale
        self.transferFee = decoded.transferFee
        self.maximumAmount = decoded.maximumAmount
        self.mptokenMetadata = decoded.mptokenMetadata
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        assetScale = try values.decodeIfPresent(Int.self, forKey: .assetScale)
        transferFee = try values.decodeIfPresent(Int.self, forKey: .transferFee)
        maximumAmount = try values.decodeIfPresent(String.self, forKey: .maximumAmount)
        mptokenMetadata = try values.decodeIfPresent(String.self, forKey: .mptokenMetadata)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        if let assetScale = assetScale { try values.encode(assetScale, forKey: .assetScale) }
        if let transferFee = transferFee { try values.encode(transferFee, forKey: .transferFee) }
        if let maximumAmount = maximumAmount { try values.encode(maximumAmount, forKey: .maximumAmount) }
        if let mptokenMetadata = mptokenMetadata { try values.encode(mptokenMetadata, forKey: .mptokenMetadata) }
    }
}

public func validateMPTokenIssuanceCreate(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["MPTokenMetadata"] is String, !isHex(str: tx["MPTokenMetadata"] as! String) {
        throw ValidationError("MPTokenIssuanceCreate: MPTokenMetadata must be in hex format")
    }
}
