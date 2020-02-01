//
//  Picture+CoreDataClass.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Picture)
public class Picture: NSManagedObject {
    
    enum CodingKeys: String, CodingKey {
        case thumbnail
        case medium
        case large
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
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        medium = try container.decodeIfPresent(String.self, forKey: .medium)
        large = try container.decodeIfPresent(String.self, forKey: .large)
        id = UUID()
    }
}

// MARK: - Extension

extension Picture: Decodable {}
