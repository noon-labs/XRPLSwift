//
//  BookOffers.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/bookOffers.ts

import AnyCodable
import Foundation

public struct TakerAmount: Codable {
    public var currency: String
    public var issuer: String?
}

/**
 The book_offers method retrieves a list of offers, also known as the order.
 Book, between two currencies. Returns an {@link BookOffersResponse}.
 */
public class BookOffersRequest: BaseRequest {
    /**
     Specification of which currency the account taking the offer would
     receive, as an object with currency and issuer fields (omit issuer for
     XRP), like currency amounts.
     */
    public var takerGets: TakerAmount
    /**
     Specification of which currency the account taking the offer would pay, as
     an object with currency and issuer fields (omit issuer for XRP), like
     currency amounts.
     */
    public var takerPays: TakerAmount

    /// A 20-byte hex string for the ledger version to use.
    public var ledgerHash: String?
    /**
     The ledger index of the ledger to use, or a shortcut string to choose a
     ledger automatically.
     */
    public var ledgerIndex: LedgerIndex?
    /**
     If provided, the server does not provide more than this many offers in the
     results. The total number of results returned may be fewer than the limit,
     because the server omits unfunded offers.
     */
    public var limit: Int?
    /**
     The Address of an account to use as a perspective. Unfunded offers placed
     by this account are always included in the response.
     */
    public var taker: String?

    enum CodingKeys: String, CodingKey {
        case takerGets = "taker_gets"
        case takerPays = "taker_pays"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case limit = "limit"
        case taker = "taker"
    }

    public init(
        // Required
        takerGets: TakerAmount,
        takerPays: TakerAmount,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        ledgerHash: String? = nil,
        ledgerIndex: LedgerIndex? = nil,
        limit: Int? = nil,
        taker: String? = nil
    ) {
        // Required
        self.takerGets = takerGets
        self.takerPays = takerPays
        // Optional
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.limit = limit
        self.taker = taker
        super.init(id: id, command: "book_offers", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(BookOffersRequest.self, from: data)
        // Required
        self.takerGets = decoded.takerGets
        self.takerPays = decoded.takerPays
        // Optional
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        self.limit = decoded.limit
        self.taker = decoded.taker
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        takerGets = try values.decode(TakerAmount.self, forKey: .takerGets)
        takerPays = try values.decode(TakerAmount.self, forKey: .takerPays)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        limit = try? values.decodeIfPresent(Int.self, forKey: .limit)
        taker = try? values.decodeIfPresent(String.self, forKey: .taker)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(takerGets, forKey: .takerGets)
        try values.encode(takerPays, forKey: .takerPays)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let limit = limit { try values.encode(limit, forKey: .limit) }
        if let taker = taker { try values.encode(taker, forKey: .taker) }
    }
}

public class BookOffer: LEOffer {
    /**
     Amount of the TakerGets currency the side placing the offer has available
     to be traded. (XRP is represented as drops; any other currency is
     represented as a decimal value.) If a trader has multiple offers in the
     same book, only the highest-ranked offer includes this field.
     */
    public var ownerFunds: String?
    /**
     The maximum amount of currency that the taker can get, given the funding
     status of the offer.
     */
    public var takerGetsFunded: Amount?
    /**
     The maximum amount of currency that the taker would pay, given the funding
     status of the offer.
     */
    public var takerPaysFunded: Amount?
    /**
     The exchange rate, as the ratio taker_pays divided by taker_gets. For
     fairness, offers that have the same quality are automatically taken
     first-in, first-out.
     */
    public var quality: String?

    enum CodingKeys: String, CodingKey {
        case ownerFunds = "owner_funds"
        case takerGetsFunded = "taker_gets_funded"
        case takerPaysFunded = "taker_pays_funded"
        case quality = "quality"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ownerFunds = try values.decode(String.self, forKey: .ownerFunds)
        takerGetsFunded = try values.decode(Amount.self, forKey: .takerGetsFunded)
        takerPaysFunded = try values.decode(Amount.self, forKey: .takerPaysFunded)
        quality = try values.decode(String.self, forKey: .quality)
        try super.init(from: decoder)
    }
}

/**
 Expected response from a {@link BookOffersRequest}.
 */
public class BookOffersResponse: Codable {
    /// Array of offer objects, each of which has the fields of an Offer object.
    public var offers: [BookOffer]
    /**
     The ledger index of the current in-progress ledger version, which was
     used to retrieve this information.
     */
    public var ledgerCurrentIndex: Int?
    /**
     The identifying hash of the ledger version that was used when retrieving
     this data, as requested.
     */
    public var ledgerHash: String?
    /**
     The ledger index of the ledger version that was used when retrieving
     this data, as requested.
     */
    public var ledgerIndex: Int?
    public var validated: Bool?

    enum CodingKeys: String, CodingKey {
        case offers = "offers"
        case ledgerCurrentIndex = "ledger_current_index"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case validated = "validated"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        offers = try values.decode([BookOffer].self, forKey: .offers)
        ledgerCurrentIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerCurrentIndex)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerIndex)
        validated = try values.decodeIfPresent(Bool.self, forKey: .validated)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as? [String: AnyObject] ?? [:]
    }
}
