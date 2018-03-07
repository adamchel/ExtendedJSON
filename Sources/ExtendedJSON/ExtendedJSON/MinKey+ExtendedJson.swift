//
//  MinKey+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/3/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension MinKey: ExtendedJSONRepresentable {
    enum CodingKeys: String, CodingKey {
        case minKey = "$minKey"
    }

    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let json = xjson as? [String: Any],
            let min = json[ExtendedJSONKeys.minKey.rawValue] as? Int,
            min == 1,
            json.count == 1 else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: MinKey.self)
        }

        return MinKey()
    }

    public var toExtendedJSON: Any {
        return [ExtendedJSONKeys.minKey.rawValue: 1]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let min = try? container.decode(Int.self, forKey: CodingKeys.minKey),
            min == 1 else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.minKey,
                                                   in: container,
                                                   debugDescription: "MinKey was not encoded correctly")
        }

        self.init()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(1, forKey: CodingKeys.minKey)
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? MinKey {
            return self == other
        }
        return false
    }
}
