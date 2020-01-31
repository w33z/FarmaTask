//
//  Name+CoreDataClass.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Name)
public class Name: NSManagedObject {

    enum CodingKeys: String, CodingKey {
        case first
        case last
        case title
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
        first = try container.decodeIfPresent(String.self, forKey: .first)
        last = try container.decodeIfPresent(String.self, forKey: .last)
        title = try container.decodeIfPresent(String.self, forKey: .title)
    }
}

// MARK: - Extension

extension Name: Decodable {}
