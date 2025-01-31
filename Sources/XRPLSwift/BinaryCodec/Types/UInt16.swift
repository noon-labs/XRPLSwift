//
//  xUInt16.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint16.py

import Foundation

let WIDTH16: Int = 2  // 16 / 8
internal let HEXREGEX16: String = "^[a-fA-F0-9]{1,4}$"

// swiftlint:disable:next type_name
class xUInt16: xUInt {
    /*
     Class for serializing and deserializing an 8-bit UInt.
     See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */

    public static var ZERO16 = xUInt16([UInt8].init(repeating: 0x0, count: WIDTH16))

    override init(_ bytes: [UInt8]? = nil) {
        // Construct a new xUInt16 type from a ``bytes`` value.
        super.init(bytes ?? xUInt16.ZERO16.bytes)
    }

    /*
     Construct a new xUInt16 type from a BinaryParser.
     Args:
     parser: The parser to construct a UInt8 from.
     Returns:
     A new xUInt16.
     */
    override func fromParser(
        _ parser: BinaryParser,
        _ hint: Int? = nil
    ) -> xUInt16 {
        return try! xUInt16(parser.read(WIDTH16))
    }

    /*
     Construct a new xUInt16 type from a number.
     Args:
     value: The value to construct a xUInt16 from.
     Returns:
     A new xUInt16.
     Raises:
     XRPLBinaryCodecException: If a xUInt16 cannot be constructed.
     */
    class func from(_ value: Int) throws -> xUInt16 {
        if value < 0 {
            throw BinaryError.unknownError(error: "\(value) must be an unsigned integer")
        }
        let valueBytes = Data(bytes: value.data.bytes, count: WIDTH16)
        return xUInt16(valueBytes.bytes.reversed())
    }
    
    class func from(_ value: String) throws -> xUInt16 {
        if let intValue = Int(value) {
            return try! xUInt16.from(intValue)
        }
        let regex = try! NSRegularExpression(pattern: HEXREGEX16)
        let nsrange = NSRange(value.startIndex..<value.endIndex, in: value)
        if regex.matches(in: value, range: nsrange).isEmpty {
            throw BinaryError.unknownError(error: "\(value) is not a valid hex string")
        }
        let strBuf = value.padding(toLength: 4, withPad: "0", startingAt: 0)
        return xUInt16(strBuf.hexToBytes)
    }
}
