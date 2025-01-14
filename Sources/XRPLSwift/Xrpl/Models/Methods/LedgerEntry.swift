////
////  LedgerEntry.swift
////
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledgerEntry.ts
//
// import Foundation
//
//
/// **
// The `ledger_entry` method returns a single ledger object from the XRP Ledger
// in its raw format. Expects a response in the form of a {@link
// LedgerEntryResponse}.
// *
// @example
// ```ts
// const ledgerEntry: LedgerEntryRequest = {
//   command: "ledger_entry",
//   ledger_index: 60102302,
//   index: "7DB0788C020F02780A673DC74757F23823FA3014C1866E72CC4CD8B226CD6EF4"
// }
// ```
// *
// @category Requests
// */
// public class LedgerEntryRequest: BaseRequest {
//    public var command: String = "ledger_entry"
//    /**
//     If true, return the requested ledger object's contents as a hex string in
//     the XRP Ledger's binary format. Otherwise, return data in JSON format. The
//     default is false.
//     */
//    public var binary?: boolean
//    /*A 20-byte hex string for the ledger version to use. */
//    public var ledger_hash?: string
//    /*The ledger index of the ledger to use, or a shortcut string. */
//    public var ledger_index?: LedgerIndex
//
//    /*
//     Only one of the following properties should be defined in a single request
//     https://xrpl.org/ledger_entry.html.
//     *
//     Retrieve any type of ledger object by its unique ID.
//     */
//    public var index?: String
//
//    /**
//     Retrieve an AccountRoot object by its address. This is roughly equivalent
//     to the an {@link AccountInfoRequest}.
//     */
//    public var account_root?: String
//
//    /**
//     The DirectoryNode to retrieve. If a string, must be the object ID of the
//     directory, as hexadecimal. If an object, requires either `dir_root` o
//     Owner as a sub-field, plus optionally a `sub_index` sub-field.
//     */
//    public var directory?:
//    | {
//        /*If provided, jumps to a later "page" of the DirectoryNode. */
//        sub_index?: Int
//        /*Unique index identifying the directory to retrieve, as a hex string. */
//        dir_root?: String
//        /*Unique address of the account associated with this directory. */
//        owner?: String
//    }
//    | String
//
//    /**
//     The Offer object to retrieve. If a string, interpret as the unique object
//     ID to the Offer. If an object, requires the sub-fields `account` and `seq`
//     to uniquely identify the offer.
//     */
//    public var offer?:
//    | {
//        /*The account that placed the offer. */
//    account: String
//        /*Sequence Number of the transaction that created the Offer object. */
//    seq: Int
//    }
//    | String
//
//    /**
//     Object specifying the RippleState (trust line) object to retrieve. The
//     accounts and currency sub-fields are required to uniquely specify the
//     rippleState entry to retrieve.
//     */
//    public var ripple_state?: {
//        /**
//         2-length array of account Addresses, defining the two accounts linked by
//         this RippleState object.
//         */
//    accounts: [String]
//        /*Currency Code of the RippleState object to retrieve. */
//    currency: String
//    }
//
//    /*The object ID of a Check object to retrieve. */
//    public var check?: String
//
//    /**
//     The Escrow object to retrieve. If a string, must be the object ID of the
//     escrow, as hexadecimal. If an object, requires owner and seq sub-fields.
//     */
//    public var escrow?:
//    | {
//        /*The owner (sender) of the Escrow object. */
//    owner: String
//        /*Sequence Number of the transaction that created the Escrow object. */
//    seq: Int
//    }
//    | String
//
//    /*The object ID of a PayChannel object to retrieve. */
//    public var payment_channel?: String
//
//    /**
//     Specify a DepositPreauth object to retrieve. If a string, must be the
//     object ID of the DepositPreauth object, as hexadecimal. If an object,
//     requires owner and authorized sub-fields.
//     */
//    public var deposit_preauth?:
//    | {
//        /*The account that provided the preauthorization. */
//    owner: String
//        /*The account that received the preauthorization. */
//    authorized: String
//    }
//    | String
//
//    /**
//     The Ticket object to retrieve. If a string, must be the object ID of the
//     Ticket, as hexadecimal. If an object, the `owner` and `ticket_sequence`
//     sub-fields are required to uniquely specify the Ticket entry.
//     */
//    public var ticket?:
//    | {
//        /*The owner of the Ticket object. */
//    owner: String
//        /*The Ticket Sequence number of the Ticket entry to retrieve. */
//    ticket_sequence: Int
//    }
//    | String
// }
//
/// **
// Response expected from a {@link LedgerEntryRequest}.
// *
// @category Responses
// */
// public class LedgerEntryResponse: Codable {
//    /*The unique ID of this ledger object. */
//    public var index: String
//    /*The ledger index of the ledger that was used when retrieving this data. */
//    public var ledger_current_index: Int
//    /**
//     Object containing the data of this ledger object, according to the
//     ledger format.
//     */
//    public var node?: LedgerEntry
//    /*The binary representation of the ledger object, as hexadecimal. */
//    public var node_binary?: String
//    public var validated?: Bool
// }
