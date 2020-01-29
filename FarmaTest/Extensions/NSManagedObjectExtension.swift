//
//  NSManageObjectExtension.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import CoreData

protocol EntityNameProviding {
    static func entityName() -> String
}

extension NSManagedObject: EntityNameProviding {
    static func entityName() -> String {
        return String(describing: self)
    }
}
