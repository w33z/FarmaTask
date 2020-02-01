//
//  Location+CoreDataClass.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {
    
    enum CodingKeys: String, CodingKey {
        case city
        case state
        case country
        case postcode
        case street
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
        city = try container.decodeIfPresent(String.self, forKey: .city)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        postcode = try container.decodeIfPresent(Int32.self, forKey: .postcode) ?? -1
        street = try container.decodeIfPresent(Street.self, forKey: .street)
        
        id = UUID()
    }
}

// MARK: - Extension

extension Location: Decodable {}
