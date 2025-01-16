//
//  Amount.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/amount.py

import Foundation

// swiftlint:disable:next identifier_name
internal let MIN_IOU_EXPONENT: Int = -96
// swiftlint:disable:next identifier_name
internal let MAX_IOU_EXPONENT: Int = 80
// swiftlint:disable:next identifier_name
internal let MAX_IOU_PRECISION: Int = 16
// swiftlint:disable:next identifier_name
internal let MAX_DROPS = Decimal(string: "1e17")!
// swiftlint:disable:next identifier_name
internal let MIN_XRP = Decimal(string: "1e-6")!

internal let mask = Int(0x00000000ffffffff)
// swiftlint:disable:next identifier_name
internal let NOT_XRP_BIT_MASK: Int = 0x80
// swiftlint:disable:next identifier_name
internal let POS_SIGN_BIT_MASK: Int = 0x4000000000000000
// swiftlint:disable:next identifier_name
internal let ZERO_CURRENCY_AMOUNT_HEX: UInt64 = 0x8000000000000000
// swiftlint:disable:next identifier_name
internal let NATIVE_AMOUNT_BYTE_LENGTH: Int = 8
// swiftlint:disable:next identifier_name
internal let CURRENCY_AMOUNT_BYTE_LENGTH: Int = 48
// Constants for validating amounts.
// swiftlint:disable:next identifier_name
internal let MIN_IOU_MANTISSA = Int(10 ** 15)
// swiftlint:disable:next identifier_name
internal let MAX_IOU_MANTISSA = Int(10 ** 16 - 1)

func containsDecimal(string: String) -> Bool {
    // Returns True if the given string contains a decimal point character.
    return !string.contains(where: { $0 == "." })
}

func verifyXrpValue(_ xrpValue: String) throws {
    /*
     Validates the format of an XRP amount.
     Raises if value is invalid.
     Args:
     xrp_value: A string representing an amount of XRP.
     Returns:
     None, but raises if xrp_value is not a valid XRP amount.
     Raises:
     XRPLBinaryCodecException: If xrp_value is not a valid XRP amount.
     */
    // Contains no decimal point
    if !containsDecimal(string: xrpValue) {
        throw BinaryError.unknownError(error: "\(xrpValue) is an invalid XRP amount.")
    }

    // Within valid range
    guard let decimal = Decimal(string: xrpValue) else {
        throw BinaryError.unknownError(error: "\(xrpValue) is an invalid XRP amount.")
    }
    // Zero is less than both the min and max XRP amounts but is valid.
    if decimal.isZero {
        return
    }
    if (decimal.compare(MIN_XRP) == -1) || (decimal.compare(MAX_DROPS) == 1) {
        throw BinaryError.unknownError(error: "\(xrpValue) is an invalid XRP amount.")
    }
}

func verifyIouValue(_ issuedCurrencyValue: String) throws {
    /*
     Validates the format of an issued currency amount value.
     Raises if value is invalid.
     Args:
     issued_currency_value: A string representing the "value"
     field of an issued currency amount.
     Returns:
     None, but raises if issued_currency_value is not valid.
     Raises:
     XRPLBinaryCodecException: If issued_currency_value is invalid.
     */
    let decimalValue = Decimal(string: issuedCurrencyValue)!
    if decimalValue.isZero {
        return
    }
    let exponent = decimalValue.exponent
    if
        (calculatePrecision(issuedCurrencyValue) > MAX_IOU_PRECISION)
            || (exponent > MAX_IOU_EXPONENT)
            || (exponent < MIN_IOU_EXPONENT) {
        throw BinaryError.unknownError(error: "Decimal precision out of range for issued currency value.")
    }
    try verifyNoDecimal(decimalValue)
}

func calculatePrecision(_ value: String) -> Int {
    // Calculate the precision of given value as a string.
    let decimalValue = Decimal(string: value)!
    if decimalValue.exponent == decimalValue.asInt {
        return decimalValue.digits().count
    }
    return decimalValue.digits().count
}

func verifyNoDecimal(_ decimal: Decimal) throws {
    /*
     Ensure that the value after being multiplied by the exponent
     does not contain a decimal.
     :param decimal: A Decimal object.
     */
    let actualExponent: Int = decimal.exponentXrp
    let exponent = Decimal(string: "1e" + String(-(Int(actualExponent) - 15)))
    var intNumberString: String = ""
    if actualExponent == 0 {
        intNumberString = decimal.digits().joined()
    } else {
        intNumberString = "\(decimal * exponent!)"
    }
    if !containsDecimal(string: intNumberString) {
        throw BinaryError.unknownError(error: "Decimal place found in intNumberString")
    }
}

func serializeIssuedCurrencyValue(_ value: String) throws -> [UInt8] {
    /*
     Serializes the value field of an issued currency amount to its bytes representation.
     :param value: The value to serialize, as a string.
     :return: A bytes object encoding the serialized value.
     */
    try verifyIouValue(value)
    let decimalValue = Decimal(string: value)!
    if decimalValue.isZero {
        return try ZERO_CURRENCY_AMOUNT_HEX.data.toArray(type: UInt8.self).reversed()
    }

    // Convert components to integers ---------------------------------------
    let sign: Int = decimalValue.isSignMinus ? 1 : 0
    let digits: [String] = decimalValue.digits()
    var exp: Int = decimalValue.exponent
    var mantissa = Int(digits.map({ String($0) }).joined())!

    // Canonicalize to expected range ---------------------------------------
    while mantissa < MIN_IOU_MANTISSA && exp > MIN_IOU_EXPONENT {
        mantissa *= 10
        exp -= 1
    }

    while mantissa > MAX_IOU_MANTISSA {
        if exp >= MAX_IOU_EXPONENT {
            throw BinaryError.unknownError(error: "Amount overflow in issued currency value \(String(value))")
        }
        mantissa /= 10
        exp += 1
    }

    if exp < MIN_IOU_EXPONENT || mantissa < MIN_IOU_MANTISSA {
        // Round to zero
        return try ZERO_CURRENCY_AMOUNT_HEX.data.toArray(type: UInt8.self).reversed()
    }

    if exp > MAX_IOU_EXPONENT || mantissa > MAX_IOU_MANTISSA {
        throw BinaryError.unknownError(error: "Amount overflow in issued currency value \(String(value))")
    }

    // Convert to bytes ----------------------------------------------------
    var serial = ZERO_CURRENCY_AMOUNT_HEX

    if sign == 0 {
        serial |= UInt64(POS_SIGN_BIT_MASK)  // "Is positive" bit set
    }
    serial |= UInt64((exp + 97) << 54)  // next 8 bits are exponents
    serial |= UInt64(mantissa)  // last 54 bits are mantissa

    return try serial.data.toArray(type: UInt8.self).reversed()
}

// func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
//    withUnsafeBytes(of: value.bigEndian, Array.init)
// }

func serializeXrpAmount(_ value: String) throws -> [UInt8] {
    /*
     Serializes an XRP amount.
     Args:
     value: A string representing a quantity of XRP.
     Returns:
     The bytes representing the serialized XRP amount.
     */
    try verifyXrpValue(value)
    // set the "is positive" bit (this is backwards from usual two's complement!)
    let valueWithPosBit = Int(value)! | POS_SIGN_BIT_MASK
    return try valueWithPosBit.data.toArray(type: UInt8.self).reversed()
}

func serializeIssuedCurrencyAmount(_ value: [String: String]) throws -> [UInt8] {
    /*
     Serializes an issued currency amount.
     Args:
     value: A dictionary representing an issued currency amount
     Returns:
     The bytes representing the serialized issued currency amount.
     */
    let amountString: String = value["value"]!
    let amountBytes: [UInt8] = try serializeIssuedCurrencyValue(amountString)
    let currencyBytes: [UInt8] = try xCurrency.from(value["currency"]!).toBytes()
    let issuerBytes: [UInt8] = try AccountID.from(value["issuer"]!).toBytes()
    return amountBytes + currencyBytes + issuerBytes
}

// swiftlint:disable:next type_name
class xAmount: SerializedType {
    static var defaultAmount = xAmount("4000000000000000".hexToBytes)

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? xAmount.defaultAmount.bytes)
    }

    static func from(_ value: String) throws -> xAmount {
        return try xAmount(serializeXrpAmount(value))
    }

    static func from(_ value: [String: String]) throws -> xAmount {
        return try xAmount(serializeIssuedCurrencyAmount(value))
    }

    override func fromParser(
        _ parser: BinaryParser,
        _ hint: Int? = nil
    ) throws -> xAmount {
        let parserFirstByte = try parser.peek()
        let notXrp: Int = (parserFirstByte != 0 ? Int(parserFirstByte) : 0x00) & 0x80
        var numBytes: Int = 0
        if notXrp != 0 {
            numBytes = CURRENCY_AMOUNT_BYTE_LENGTH
        } else {
            numBytes = NATIVE_AMOUNT_BYTE_LENGTH
        }
        return xAmount(try parser.read(numBytes))
    }

    override func toJson() -> Any {
        /*
         Construct a JSON object representing this Amount.

         Returns:
         The JSON representation of this amount.
         */

        if self.isNative() {
            let sign: String = self.isPositive() ? "" : "-"
            let maskedBytes = Int(self.bytes.toHexString(), radix: 16)! & 0x3FFFFFFFFFFFFFFF
            return "\(sign)\(maskedBytes)"
        }

        let parser = BinaryParser(hex: self.toHex())
        let valueBytes: [UInt8] = try! parser.read(8)
        let currency = xCurrency().fromParser(parser)
        let issuer = AccountID().fromParser(parser)
        let byte1: UInt8 = valueBytes[0]
        let byte2: UInt8 = valueBytes[1]
        let isPositive: UInt8 = byte1 & 0x40
        let sign: String = (isPositive != 0) ? "" : "-"
        let exponent = Int(((byte1 & 0x3F) << 2) + ((byte2 & 0xFF) >> 6)) - 97
        let hexMantissa: String = ([UInt8](arrayLiteral: byte2 & 0x3F) + valueBytes[2...]).toHex
        let intMantissa = Int(hexMantissa, radix: 16)!
        let value = Decimal(string: "\(sign)\(intMantissa)")! * Decimal(string: "1e\(exponent)")!
        var valueStr: String = ""
        if value.isZero {
            valueStr = "0"
        } else {
            valueStr = value.description
        }
        try! verifyIouValue(valueStr)

        return [
            "value": valueStr,
            "currency": currency.toJson() as Any,
            "issuer": issuer.toJson() as Any
        ]
    }

    func isNative() -> Bool {
        /*
         Returns True if this amount is a native XRP amount.

         Returns:
         True if this amount is a native XRP amount, False otherwise.
         */
        // 1st bit in 1st byte is set to 0 for native XRP
        return (self.bytes[0] & 0x80) == 0
    }

    func isPositive() -> Bool {
        /*
         Returns True if 2nd bit in 1st byte is set to 1 (positive amount).

         Returns:
         True if 2nd bit in 1st byte is set to 1 (positive amount),
         False otherwise.
         */
        return (self.bytes[0] & 0x40) > 0
    }
}

extension Decimal {
    var asInt: Int {
        guard let int = Int("\(self)") else {
            return 0
        }
        return int
    }

    var exponentXrp: Int {
        return self.exponent
    }

    func digits() -> [String] {
        var string: String = "\(self.significand)"
        if let index = string.firstIndex(of: "-") { string.remove(at: index) }
        return string.compactMap { String($0.wholeNumberValue!) }
    }

    // TODO: This exists but couldn't find func name
    func compare(_ value: Decimal) -> Int {
        if self > value { return 1 }
        if self < value { return -1 }
        return 0
    }
}

func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
    withUnsafeBytes(of: value.bigEndian, Array.init)
}

extension Int {
    var asBigByteArray: [UInt8] {
        return XRPLSwift.byteArray(from: self)
    }
}
