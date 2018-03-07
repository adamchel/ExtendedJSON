//
//  Bool+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/4/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension Bool: ExtendedJSONRepresentable {
    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let bool = xjson as? Bool else {
            throw BsonError.parseValueFailure(value: xjson, attemptedType: Bool.self)
        }

        return bool
    }

    public var toExtendedJSON: Any {
        return self
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? Bool {
            return self == other
        }
        return false
    }
}
