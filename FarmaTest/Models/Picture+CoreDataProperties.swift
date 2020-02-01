//
//  Picture+CoreDataProperties.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var id: UUID
    @NSManaged public var thumbnail: String?
    @NSManaged public var medium: String?
    @NSManaged public var large: String?
    @NSManaged public var contact: Contact?

}
