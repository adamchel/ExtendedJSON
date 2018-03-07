//
//  DBRef.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/2/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

public struct DBRef {
    let ref: String
    let id: ObjectId
    let db: String?
    let otherFields: [String: ExtendedJSONRepresentable]

    public init (ref: String,
                 id: ObjectId,
                 db: String?,
                 otherFields: [String: ExtendedJSONRepresentable]) {
        self.ref = ref
        self.id = id
        self.db = db
        self.otherFields = otherFields
    }
}
