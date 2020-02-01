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
    
    // MARK: - Decoding
    
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
        
        id = UUID()
        isFavorite = false
    }
}

// MARK: - Extension

extension Contact: Decodable {}

extension Contact {
    // MARK: - Updating
    
    static func update(contact: Contact) -> Result<(),Error> {
        let workerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        workerContext.parent = DatabaseService.shared.getContext(.workers)
        
        let fetchRequest = Contact.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "id == %@", contact.id as CVarArg)
        
        fetchRequest.predicate = predicate
        
        do {
            guard let result = try workerContext.fetch(fetchRequest).first else {
                let error = NSError(domain:"", code: 404, userInfo:[ NSLocalizedDescriptionKey: "Object contact-ID: \(contact.id.uuidString) not found"]) as Error
                return .failure(error)
            }

            result.isFavorite = contact.isFavorite
            
            workerContext.performAndWait {
                DatabaseService.shared.saveContext(workerContext)
            }
            
            DatabaseService.shared.mergeWorkersChangesWithMainContext()
            
            return .success(())
        } catch let error as NSError {
            print("[CoreData] Error \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
    
    // MARK: - Mapping

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
