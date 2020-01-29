//
//  ContactViewModel.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 27/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import Foundation

typealias ContactsHandler = (Result<[Contact]?, Error>) -> ()

class ContactViewModel {
    var contacts: [Contact]?
    
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
            let contacts = Contact.mapArray(from: data, using: context)
            
            let saveResult = DatabaseService.shared.saveContext(context)
            
            if saveResult != .rolledBack {
                print("Download contacts save result success")
                DatabaseService.shared.mergeWorkersChangesWithMainContext()
                completion(.success(contacts))
            } else {
                let error = NSError(domain:"", code: 500, userInfo:[ NSLocalizedDescriptionKey: "Contacts save result failure"]) as Error
                completion(.failure(error))
            }

        }.resume()
    }
}
