//
//  BsonArray+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/4/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension BSONArray: ExtendedJSONRepresentable {
    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let array = xjson as? [Any],
            let bsonArray = try? BSONArray(array: array) else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: BSONArray.self)
        }

        return bsonArray
    }

    public var toExtendedJSON: Any {
        return map { $0.toExtendedJSON }
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? BSONArray, other.count == self.count {
            for i in 0..<other.count {
                let myExtendedJSONRepresentable = self[i]
                let otherExtendedJSONRepresentable = other[i]

                if !myExtendedJSONRepresentable.isEqual(toOther: otherExtendedJSONRepresentable) {
                    return false
                }
            }
        } else {
            return false
        }
        return true
    }
}
