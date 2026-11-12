//
//  Issue.swift
//
//
//  Created for AMM (XLS-30) support.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/ripple-binary-codec/src/types/issue.ts

import Foundation

/**
 Codec for serializing and deserializing an Issue (an asset without an amount).
 Used by the AMM `Asset`/`Asset2` fields.
 - XRP: 20 bytes of zero (the XRP currency code) and nothing else.
 - Issued currency: 20-byte currency code followed by the 20-byte issuer AccountID.
 JSON form is `{"currency": "XRP"}` or `{"currency": "USD", "issuer": "r..."}`.
 */
// swiftlint:disable:next type_name
class xIssue: SerializedType {
    static var defaultIssue = xIssue(xCurrency.defaultCurrency.bytes)

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? xIssue.defaultIssue.bytes)
    }

    static func from(_ value: xIssue) throws -> xIssue {
        return value
    }

    static func from(_ value: [String: Any]) throws -> xIssue {
        guard let currencyValue = value["currency"] as? String else {
            throw BinaryError.unknownError(error: "Issue: missing or invalid currency")
        }
        let currency = try xCurrency.from(currencyValue)
        let isXrp = currency.bytes.allSatisfy { $0 == 0 }
        if isXrp {
            if value["issuer"] != nil {
                throw BinaryError.unknownError(error: "Issue: XRP must not have an issuer")
            }
            return xIssue(currency.bytes)
        }
        guard let issuerValue = value["issuer"] as? String else {
            throw BinaryError.unknownError(error: "Issue: missing issuer for \(currencyValue)")
        }
        let issuer = try AccountID.from(issuerValue)
        return xIssue(currency.bytes + issuer.bytes)
    }

    override func fromParser(
        _ parser: BinaryParser,
        _ hint: Int? = nil
    ) throws -> xIssue {
        let currency: [UInt8] = try parser.read(CURRENCY_CODE_LENGTH)
        if currency.allSatisfy({ $0 == 0 }) {
            return xIssue(currency)
        }
        let issuer: [UInt8] = try parser.read(AccountID.LENGTH)
        return xIssue(currency + issuer)
    }

    override func toJson() throws -> Any {
        return (try self.toJson() as [String: AnyObject])
    }

    override func toJson() throws -> [String: AnyObject] {
        let currency = xCurrency([UInt8](self.bytes[0..<CURRENCY_CODE_LENGTH]))
        var json: [String: AnyObject] = ["currency": (try currency.toJson() as String) as AnyObject]
        if self.bytes.count > CURRENCY_CODE_LENGTH {
            let issuer = AccountID([UInt8](self.bytes[CURRENCY_CODE_LENGTH..<(CURRENCY_CODE_LENGTH + AccountID.LENGTH)]))
            json["issuer"] = (try issuer.toJson() as Any) as AnyObject
        }
        return json
    }
}
