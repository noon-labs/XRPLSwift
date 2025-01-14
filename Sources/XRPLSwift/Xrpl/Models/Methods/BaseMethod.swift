//
//  BaseMethod.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/baseMethod.ts

import AnyCodable
import Foundation

public class TestData: Codable {
    var closeServer: Bool?
    var unrecognizedResponse: Bool?
    var disconnectIn: Int?
}

public class BaseRequest: Codable, Equatable {
    public static func == (lhs: BaseRequest, rhs: BaseRequest) -> Bool {
        return lhs.id == rhs.id
            && lhs.command == rhs.command
            && lhs.apiVersion == rhs.apiVersion
    }

    public var id: Int?
    public var command: String?
    public var apiVersion: Int?

    // TESTING
    public var data: TestData?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case command = "command"
        case apiVersion = "api_version"

        // TESTING
        case data = "data"
    }

    public init(id: Int? = nil, command: String? = nil, apiVersion: Int? = nil, data: TestData? = nil) {
        self.id = id
        self.command = command
        self.apiVersion = apiVersion

        // TESTING
        self.data = data
    }

    public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(BaseRequest.self, from: data)
        self.id = decoded.id
        self.command = decoded.command
        self.apiVersion = decoded.apiVersion

        // TESTING
        self.data = decoded.data
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public struct Warning: Codable {
    var id: Int!
    var message: String!
    var details: [String: [String: String]]?
}

open class RippleBaseResponse: Decodable {
    public static func == (lhs: RippleBaseResponse, rhs: RippleBaseResponse) -> Bool {
        return lhs.id == rhs.id
            && lhs.status == rhs.status
            && lhs.type == rhs.type
    }

    public var id: Int
    public var status: String?
    public var type: String
    //    public var warning: String = "load"
    //    public var warnings: [Warning]?
    //    public var forwarded: Bool?
    //    public var apiVersion: Int?

    init(data: Data, decoder: JSONDecoder = JSONDecoder()) throws {
        let decoded = try decoder.decode(RippleBaseResponse.self, from: data)
        self.id = decoded.id
        self.status = decoded.status
        self.type = decoded.type
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(id: Int, status: String?, type: String, result: AnyCodable?) {
        self.id = id
        self.status = status
        self.type = type
    }

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case type
        case warning
        case warnings
        case forwarded
        case apiVersion
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        status = try values.decode(String.self, forKey: .status)
        type = try values.decode(String.self, forKey: .type)
        //        warning = try values.decode(String.self, forKey: .warning)
        //        warnings = try values.decode(String.self, forKey: .warnings)
        //        forwarded = try values.decode(Bool.self, forKey: .forwarded)
        //        apiVersion = try values.decode(Int.self, forKey: .apiVersion)
    }
}

open class BaseResponse<T> {
    public var id: Int
    public var status: String?
    public var type: String
    public var result: T?

    public init(id: Int, status: String?, type: String, result: T?) {
        self.id = id
        self.status = status
        self.type = type
        self.result = result
    }

    public convenience init(response: RippleBaseResponse, result: T?) {
        self.init(
            id: response.id,
            status: response.status,
            type: response.type,
            result: result
        )
    }
}

open class ErrorResponse: Error, Codable {
    public var id: Int
    public var status: String = "error"
    public var type: String
    public var error: String
    public var errorCode: Int?
    public var errorMessage: String?
    public var errorException: String?
    public var request: AnyCodable?
    public var apiVersion: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case type = "type"
        case error = "error"
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case errorException = "error_exception"
        case request = "request"
        case apiVersion = "api_version"
    }

    var localizedDescription: String = {
        return "some"
    }()
}

public struct RippleRequestFactory<R> {
    public var requestType: Any?

    init(requestType: R?) {
        self.requestType = requestType
    }

    func getResponse(response: RippleBaseResponse, data: Data) -> Any? {
        if requestType.self is AccountChannelsRequest.Type {
            return BaseResponse(
                response: response,
                result: CodableHelper.decode(AccountChannelsResponse.self, from: data).decodableObj
            )
        }
        if requestType.self is AccountCurrenciesRequest.Type {
            return BaseResponse(
                response: response,
                result: CodableHelper.decode(AccountCurrenciesResponse.self, from: data).decodableObj
            )
        }
        if requestType.self is AccountInfoRequest.Type {
            return BaseResponse(
                response: response,
                result: CodableHelper.decode(AccountInfoResponse.self, from: data).decodableObj
            )
        }
        if requestType.self is AccountCurrenciesRequest.Type {
            return BaseResponse(
                response: response,
                result: CodableHelper.decode(AccountCurrenciesResponse.self, from: data).decodableObj
            )
        }
        return nil
    }
}

open class CodableHelper {
    open class func decode<T>(_ type: T.Type, from data: Data) -> (decodableObj: T?, error: Error?) where T: Decodable {
        var returnedDecodable: T?
        var returnedError: Error?

        let decoder = JSONDecoder()

        do {
            returnedDecodable = try decoder.decode(type, from: data)
        } catch {
            returnedError = error
        }

        return (returnedDecodable, returnedError)
    }
}
