//
//  xCurrency.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/currency.py

import Foundation

// swiftlint:disable:next identifier_name
let CURRENCY_CODE_LENGTH: Int = 20

func isIsoCode(value: String) -> Bool {
    // Tests if value is a valid 3-char iso code.
    let regex = try! NSRegularExpression(pattern: "^[A-Za-z0-9]{3}$")
    let nsrange = NSRange(value.startIndex..<value.endIndex, in: value)
    return regex.matches(in: value, range: nsrange).isEmpty ? false : true
}

func isoCodeFromHex(value: [UInt8]) throws -> String? {
    let candidateIso = String(data: Data(value), encoding: .ascii)!
    if candidateIso == "XRP" {
        throw BinaryError.unknownError(
            error: "Disallowed currency code: to indicate the currency XRP you must use 20 bytes of 0s"
        )
    }
    if isIsoCode(value: candidateIso) {
        return candidateIso
    }
    return nil
}

func isHex(value: String) -> Bool {
    // Tests if value is a valid 40-char hex string.
    let regex = try! NSRegularExpression(pattern: "^[A-F0-9]{40}$")
    let nsrange = NSRange(value.startIndex..<value.endIndex, in: value)
    return regex.matches(in: value, range: nsrange).isEmpty ? false : true
}

func isoToBytes(iso: String) throws -> [UInt8] {
    /*
     Convert an ISO code to a 160-bit (20 byte) encoded representation.
     See "Currency codes" subheading in
     `Amount Fields <https://xrpl.org/serialization.html#amount-fields>`_
     */
    if !isIsoCode(value: iso) {
        throw BinaryError.unknownError(error: "Invalid ISO code: \(iso)")
    }

    if iso == "XRP" {
        // This code (160 bit all zeroes) is used to indicate XRP in
        // rare cases where a field must specify a currency code for XRP.
        return [UInt8].init(repeating: 0x0, count: CURRENCY_CODE_LENGTH)
    }

    return [UInt8].init(repeating: 0x0, count: 12) + iso.bytes + [UInt8].init(repeating: 0x0, count: 5)
}

// swiftlint:disable:next type_name
class xCurrency: Hash160 {
    static var defaultCurrency = xCurrency([UInt8].init(repeating: 0x0, count: 20))

    public var iso: String?

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? xCurrency.defaultCurrency.bytes)

        let codeBytes: [UInt8] = [UInt8](self.bytes[12..<15])
        // Determine whether this currency code is in standard or nonstandard format:
        // https://xrpl.org/currency-formats.html#nonstandard-currency-codes
        if bytes?[0] != 0 {
            // non-standard currency
            self.iso = nil
        } else if bytes?.toHexString() == String(repeating: "0", count: 40) { // all 0s
            // the special case for literal XRP
            self.iso = "XRP"
        } else {
            self.iso = try? isoCodeFromHex(value: codeBytes)
        }
    }

    override static func from(_ value: String) throws -> xCurrency {
        if isIsoCode(value: value) {
            return xCurrency(try isoToBytes(iso: value))
        }
        if isHex(value: value) {
            return xCurrency(value.hexToBytes)
        }
        throw BinaryError.unknownError(error: "Unsupported Currency representation: \(value)")
    }

    override func fromParser(
        _ parser: BinaryParser,
        _ hint: Int? = nil
    ) -> xCurrency {
        return xCurrency(try! parser.read(hint ?? LENGTH20))
    }

    override func toJson() -> Any {
        if self.iso != nil {
            return self.iso!
        }
        return self.bytes.toHex
    }

    override func toJson() -> String {
        return (self.toJson() as Any) as! String
    }
}
