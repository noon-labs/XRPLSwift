//
//  Extensions.swift
//  XRPLSwift
//
//  Created by Mitch Lang on 5/10/19.
//

import BigInt
import CryptoSwift
import Foundation

// swiftlint:disable all
func sha512HalfHash(data: [UInt8]) -> [UInt8] {
    return [UInt8](Data(data).sha512().prefix(through: 31))
}

extension Array where Element == UInt8 {
    func sha512Half() -> [UInt8] {
        return [UInt8](self.sha512().prefix(through: 31))
    }
}

extension Data {
    func sha512Half() -> Data {
        Data(self.sha512().prefix(through: 31))
    }
}

extension Data {

    init(hex: String) {
        var data = Data(capacity: hex.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: hex, options: [], range: NSRange(location: 0, length: hex.count)) { match, _, _ in
            let byteString = (hex as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        self = data
    }
}

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

typealias Byte = UInt8
enum Bit: Int {
    case zero, one
}

extension Byte {
    var bits: [Bit] {
        let bitsOfAbyte = 8
        var bitsArray = [Bit](repeating: Bit.zero, count: bitsOfAbyte)
        for (index, _) in bitsArray.enumerated() {
            // Bitwise shift to clear unrelevant bits
            let bitVal: UInt8 = 1 << UInt8(bitsOfAbyte - 1 - index)
            let check = self & bitVal

            if check != 0 {
                bitsArray[index] = Bit.one
            }
        }
        return bitsArray
    }
}

extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    var hexadecimal: Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return nil }

        return data
    }

    func stripHexPrefix() -> String {
        if self.hasPrefix("0x") {
            let indexStart = self.index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }

}

extension Data {

    /// Hexadecimal string representation of `Data` object.

    var hexadecimal: String {
        return map { String(format: "%02x", $0) }
            .joined()
    }
}

extension Numeric {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<Self>.size)
    }
}

public extension URL {
    static let xrpl_rpc_MainNetS1 = URL(string: "https://s1.ripple.com:51234/")!
    static let xrpl_rpc_MainNetS2 = URL(string: "https://s2.ripple.com:51234/")!
    static let xrpl_rpc_Testnet = URL(string: "https://s.altnet.rippletest.net:51234/")!
    static let xrpl_rpc_Xls20 = URL(string: "https://xls20-sandbox.rippletest.net:51234")!
    static let xrpl_rpc_Hooknet = URL(string: "https://hooks-testnet-v2.xrpl-labs.com")!
    static let xrpl_rpc_Devnet = URL(string: "https://s.devnet.rippletest.net:51234/")!
    static let xrpl_rpc_Xumm = URL(string: "https://xumm.app/")!
    static let xrpl_ws_MainnetS1 = URL(string: "wss://s1.ripple.com/")!
    static let xrpl_ws_MainnetS2 = URL(string: "wss://s2.ripple.com/")!
    static let xrpl_ws_Testnet = URL(string: "wss://s.altnet.rippletest.net/")!
    static let xrpl_ws_Devnet = URL(string: "wss://s.devnet.rippletest.net/")!
    static let xrpl_ws_Xls20 = URL(string: "wss://xls20-sandbox.rippletest.net:51233")!
    static let xrpl_ws_Hooknet = URL(string: "wss://hooks-testnet.xrpl-labs.com/")!
    static let xrpl_ws_Xumm = URL(string: "wss://xumm.app/")!
}

public enum LHost: String {
    case xrpl_rpc_MainNetS1 = "s1.ripple.com:51234"
    case xrpl_rpc_MainNetS2 = "s2.ripple.com:51234"
    case xrpl_rpc_Testnet = "s.altnet.rippletest.net:51234"
    case xrpl_rpc_Devnet = "s.devnet.rippletest.net:51234"
    case xrpl_rpc_Xls20 = "xls20-sandbox.rippletest.net:51234"
    case xrpl_rpc_Hooknet = "hooks-testnet.xrpl-labs.com:51234"
    case xrpl_ws_MainnetS1 = "s1.ripple.com"
    case xrpl_ws_MainnetS2 = "s2.ripple.com"
    case xrpl_ws_Testnet = "s.altnet.rippletest.net"
    case xrpl_ws_Devnet = "s.devnet.rippletest.net"
    case xrpl_ws_Xls20 = "xls20-sandbox.rippletest.net"
    case xrpl_ws_Hooknet = "hooks-testnet.xrpl-labs.com"
    case xrpl_ws_Xumm = "xumm.app"
}

extension Date {
    var timeIntervalSinceRippleEpoch: UInt64 {
        return UInt64(self.timeIntervalSince1970) - UInt64(946684800)
    }
}
