//
//  Street+CoreDataClass.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Street)
public class Street: NSManagedObject {
    
    enum CodingKeys: String, CodingKey {
        case number
        case name
    }
    
    // MARK: - Decoding

    public required convenience init(from decoder: Decoder) throws {
        guard let codingMOC = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingMOC] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Self.entityName(), in: managedObjectContext) else {
                fatalError("Failed to decode \(Self.entityName())")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decodeIfPresent(Int32.self, forKey: .number) ?? -1
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}

// MARK: - Extension

extension Street: Decodable {}
