//
//  Contact+CoreDataClass.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    enum CodingKeys: String, CodingKey {
        case gender
        case email
        case phone
        case cell
        case name
        case location
        case picture
    }
    
    // MARK: Decoding
    
    public required convenience init(from decoder: Decoder) throws {
        guard let codingMOC = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingMOC] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Self.entityName(), in: managedObjectContext) else {
                fatalError("Failed to decode \(Self.entityName())")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        cell = try container.decodeIfPresent(String.self, forKey: .cell)
        name = try container.decodeIfPresent(Name.self, forKey: .name)
        location = try container.decodeIfPresent(Location.self, forKey: .location)
        picture = try container.decodeIfPresent(Picture.self, forKey: .picture)
    }
}

// MARK: Extension

extension Contact: Decodable {}

extension Contact {
    // MARK: Mapping

    static func mapArray(from data: Data, using context: NSManagedObjectContext) -> [Contact]? {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve context")
        }
        
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = context

        do {
            let modelsArrayMap = try decoder.decode(ModelsArrayMap<Contact>.self, from: data)
            return modelsArrayMap.results
        } catch let error{
            print(error)
            return nil
        }
    }
}

class ModelsArrayMap<T: Decodable>: Decodable {
    let results: [T]?
}
