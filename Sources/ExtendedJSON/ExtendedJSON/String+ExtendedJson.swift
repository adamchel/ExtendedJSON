//
//  String+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/3/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension String: ExtendedJSONRepresentable {
    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let string = xjson as? String else {
            throw BsonError.parseValueFailure(value: xjson, attemptedType: String.self)
        }

        return string
    }

    public var toExtendedJSON: Any {
        return self
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? String {
            return self == other
        }
        return false
    }
}
