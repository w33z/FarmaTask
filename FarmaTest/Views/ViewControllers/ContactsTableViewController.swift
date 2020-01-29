//
//  ContactsTableViewController.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 27/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    var contacts: [Contact]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var viewmodel: ContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewmodel = ContactViewModel()
        
        viewmodel.getContacts { result in
            switch result {
                case .success(let contacts):
                    self.contacts = contacts
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

extension ContactsTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = contacts?.count else { return 0 }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        guard let contact = contacts?[index] else { return UITableViewCell() }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        cell.textLabel?.text = "\(contact.name?.title) \(contact.name?.first) \(contact.name?.last)"

        return cell
    }
    
    
}
