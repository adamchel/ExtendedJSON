//
//  BsonUndefined+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/4/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension Undefined: ExtendedJSONRepresentable {
    enum CodingKeys: String, CodingKey {
        case undefined = "$undefined"
    }
    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let json = xjson as? [String: Any],
            let undefined = json[ExtendedJSONKeys.undefined.rawValue] as? Bool,
            undefined else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: Undefined.self)
        }

        return Undefined()
    }

    public var toExtendedJSON: Any {
        return [ExtendedJSONKeys.undefined.rawValue: true]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let undefined = try? container.decode(Bool.self, forKey: CodingKeys.undefined),
            undefined else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.undefined,
                                                   in: container,
                                                   debugDescription: "BSONUndefined was not encoded correctly")
        }
        self.init()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(true, forKey: CodingKeys.undefined)
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? Undefined {
            return self == other
        }
        return false
    }
}
