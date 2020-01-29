//
//  Street+CoreDataProperties.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Street {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Street> {
        return NSFetchRequest<Street>(entityName: "Street")
    }

    @NSManaged public var number: Int32
    @NSManaged public var name: String?
    @NSManaged public var location: Location?

}
