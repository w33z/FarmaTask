//
//  DatabaseService.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import Foundation
import CoreData

class DatabaseService  {
    enum SaveStatus {
        case saved, rolledBack, hasNoChanges
    }
    
    enum ContextType {
        case main
        case workers
    }
    
    static let shared = DatabaseService()
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mergeWorkersContextChangesWithMainContext(notification:)),
                                               name: Notification.Name.NSManagedObjectContextDidSave, object: workersContext)
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        let container = NSPersistentContainer(name: "FarmaTest")
        let storeURL = try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("FarmaTest.sqlite")
        
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]


        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            //print("[CoreData]: Store Description = \(storeDescription)")
        })
        return container
    }()
    
    // MARK: - Save context
    
    @discardableResult func saveContext(_ context: NSManagedObjectContext) -> SaveStatus {

        if context.hasChanges {
            do {
                try context.save()
                print("[CoreData]: Saved context")
                return .saved
            } catch {
                context.rollback()
                print("[CoreData]: Context rolled back")
                return .rolledBack
            }
        } else {
            print("[CoreData]: Context has no changes to save")
            return .hasNoChanges
        }
    }
    
    func mergeWorkersChangesWithMainContext() {
        workersContext.performAndWait {
            saveContext(workersContext)
        }
    }
    
    // MARK: - Workers Managed Object Context
    
    lazy private var workersContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()

    // MARK: - Synchronize Workers
    /// Sync changes in Workers context
    /// with Main context
    ///
    /// - Parameter notification: workers context notification
    @objc func mergeWorkersContextChangesWithMainContext(notification: Notification) {
        print("Merging changes from Workers context")
        persistentContainer.viewContext.performAndWait {
            persistentContainer.viewContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    // MARK: - Helpers
    
    func getContext(_ contextType: ContextType) -> NSManagedObjectContext {
        switch contextType {
        case .main:
            return persistentContainer.viewContext
        case .workers:
            return workersContext
        }
    }
}

// MARK: - Managed Object Context in Decoders

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
