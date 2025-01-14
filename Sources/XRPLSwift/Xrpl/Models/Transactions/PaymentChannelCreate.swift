//
//  PaymentChannelCreate.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/paymentChannelCreate.ts

public class PaymentChannelCreate: BaseTransaction {
    /*
     Represents a `PaymentChannelCreate
     <https://xrpl.org/paymentchannelcreate.html>`_ transaction, which creates a
     `payment channel <https://xrpl.org/payment-channels.html>`_ and funds it with
     XRP. The sender of this transaction is the "source address" of the payment
     channel.
     */

    public var amount: Amount
    /*
     The amount of XRP, in drops, to set aside in this channel. This field is
     required.
     :meta hide-value:
     */

    public var destination: String
    /*
     The account that can receive XRP from this channel, also known as the
     "destination address" of the channel. Cannot be the same as the sender.
     This field is required.
     :meta hide-value:
     */

    public var settleDelay: Int
    /*
     The amount of time, in seconds, the source address must wait between
     requesting to close the channel and fully closing it. This field is
     required.
     :meta hide-value:
     */

    public var publicKey: String
    /*
     The public key of the key pair that the source will use to authorize
     claims against this  channel, as hexadecimal. This can be any valid
     secp256k1 or Ed25519 public key. This field is required.
     :meta hide-value:
     */

    public var cancelAfter: Int?
    /*
     An immutable expiration time for the channel, in seconds since the Ripple
     Epoch. The channel can be closed sooner than this but cannot remain open
     later than this time.
     */

    public var destinationTag: Int?
    /*
     An arbitrary `destination tag
     <https://xrpl.org/source-and-destination-tags.html>`_ that
     identifies the reason for the Payment Channel, or a hosted recipient to pay.
     */

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case destination = "Destination"
        case settleDelay = "SettleDelay"
        case publicKey = "PublicKey"
        case cancelAfter = "CancelAfter"
        case destinationTag = "DestinationTag"
    }

    public init(
        amount: Amount,
        destination: String,
        settleDelay: Int,
        publicKey: String,
        cancelAfter: Int? = nil,
        destinationTag: Int? = nil
    ) {
        self.amount = amount
        self.destination = destination
        self.settleDelay = settleDelay
        self.publicKey = publicKey
        self.cancelAfter = cancelAfter
        self.destinationTag = destinationTag
        super.init(account: "", transactionType: "PaymentChannelCreate")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(PaymentChannelCreate.self, from: data)
        self.amount = decoded.amount
        self.destination = decoded.destination
        self.settleDelay = decoded.settleDelay
        self.publicKey = decoded.publicKey
        self.cancelAfter = decoded.cancelAfter
        self.destinationTag = decoded.destinationTag
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decode(Amount.self, forKey: .amount)
        destination = try values.decode(String.self, forKey: .destination)
        settleDelay = try values.decode(Int.self, forKey: .settleDelay)
        publicKey = try values.decode(String.self, forKey: .publicKey)
        cancelAfter = try values.decodeIfPresent(Int.self, forKey: .cancelAfter)
        destinationTag = try values.decodeIfPresent(Int.self, forKey: .destinationTag)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(amount, forKey: .amount)
        try values.encode(destination, forKey: .destination)
        try values.encode(settleDelay, forKey: .settleDelay)
        try values.encode(publicKey, forKey: .publicKey)
        if let cancelAfter = cancelAfter { try values.encode(cancelAfter, forKey: .cancelAfter) }
        if let destinationTag = destinationTag { try values.encode(destinationTag, forKey: .destinationTag) }
    }
}

/**
 Verify the form and type of an PaymentChannelCreate at runtime.
 - parameters:
 - tx: An PaymentChannelCreate Transaction.
 - throws:
 When the PaymentChannelCreate is Malformed.
 */
public func validatePaymentChannelCreate(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Amount"] == nil {
        throw ValidationError("PaymentChannelCreate: missing Amount")
    }

    if !(tx["Amount"] is String) {
        throw ValidationError("PaymentChannelCreate: Amount must be a string")
    }

    if tx["Destination"] == nil {
        throw ValidationError("PaymentChannelCreate: missing Destination")
    }

    if !(tx["Destination"] is String) {
        throw ValidationError("PaymentChannelCreate: Destination must be a string")
    }

    if tx["SettleDelay"] == nil {
        throw ValidationError("PaymentChannelCreate: missing SettleDelay")
    }

    if !(tx["SettleDelay"] is Int) {
        throw ValidationError("PaymentChannelCreate: SettleDelay must be a number")
    }

    if tx["PublicKey"] == nil {
        throw ValidationError("PaymentChannelCreate: missing PublicKey")
    }

    if !(tx["PublicKey"] is String) {
        throw ValidationError("PaymentChannelCreate: PublicKey must be a string")
    }

    if tx["CancelAfter"] !== nil && !(tx["CancelAfter"] is Int) {
        throw ValidationError("PaymentChannelCreate: CancelAfter must be a number")
    }

    if tx["DestinationTag"] !== nil && !(tx["DestinationTag"] is Int) {
        throw ValidationError("PaymentChannelCreate: DestinationTag must be a number")
    }
}
