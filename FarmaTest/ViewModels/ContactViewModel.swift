//
//  ContactViewModel.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 27/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import CoreData

typealias ContactsHandler = (Result<(), Error>) -> ()

class ContactViewModel {
    var contacts: [Contact]?
    
    var fetchedResultsController: NSFetchedResultsController<Contact> = {
        let context = DatabaseService.shared.getContext(.main)
        let fetchRequest = Contact.fetchRequest() as NSFetchRequest<Contact>

        let firstnameSortDescriptor = NSSortDescriptor(key: "name.first", ascending: true)
        let lastnameSortDescriptor = NSSortDescriptor(key: "name.last", ascending: true)

        fetchRequest.sortDescriptors = [lastnameSortDescriptor, firstnameSortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController<Contact>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                        
        return fetchedResultsController
    }()
    
    func getContacts(completion: @escaping ContactsHandler) {
        let url = URL(string: AppDelegate.apiKey)!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else { return }

            let context = DatabaseService.shared.getContext(.workers)
            _ = Contact.mapArray(from: data, using: context)
            
            let saveResult = DatabaseService.shared.saveContext(context)
            
            if saveResult != .rolledBack {
                print("Download contacts save result success")
                DatabaseService.shared.mergeWorkersChangesWithMainContext()
                UserDefaults.standard.set(.lastSynchronizationTimestamp, to: String(describing: Date()))
                
                completion(.success(()))
            } else {
                let error = NSError(domain:"", code: 500, userInfo:[ NSLocalizedDescriptionKey: "Contacts save result failure"]) as Error
                completion(.failure(error))
            }

        }.resume()
    }
    
    func updateContactFavorite(contact: Contact) -> Result<(), Error> {
        contact.isFavorite = !contact.isFavorite
        return Contact.update(contact: contact)
    }
}
