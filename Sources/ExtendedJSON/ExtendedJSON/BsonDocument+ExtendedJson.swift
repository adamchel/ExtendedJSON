//
//  Document+ExtendedJSONRepresentable.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/5/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension Document: ExtendedJSONRepresentable {
    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let json = xjson as? [String: Any],
            let doc = try? Document(extendedJson: json) else {
                if let empty = xjson as? [Any] {
                    if empty.count == 0 {
                        return Document()
                    }
                }
                throw BsonError.parseValueFailure(value: xjson, attemptedType: Document.self)
        }

        return doc
    }

    //Documen's `makeIterator()` has no concurency handling, therefor modifying the Document while itereting over it might cause unexpected behaviour
    public var toExtendedJSON: Any {
        return reduce(into: [:], { ( result: inout [String: Any], kv) in
            let (key, value) = kv
            result[key] = value.toExtendedJSON
        })
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? Document {
            return self == other
        }
        return false
    }
}
