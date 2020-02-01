//
//  Contact+CoreDataProperties.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact") 
    }

    @NSManaged public var id: UUID
    @NSManaged public var gender: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var cell: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: Name?
    @NSManaged public var location: Location?
    @NSManaged public var picture: Picture?

}
