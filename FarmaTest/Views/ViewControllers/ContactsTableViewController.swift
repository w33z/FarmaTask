//
//  ContactsTableViewController.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 27/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import CoreData

protocol ContactSelectionDelegate {
    func contactDidSelect(_ contact: Contact)
}

class ContactsTableViewController: UITableViewController {
    
    // MARK: - Properties

    var delegate: ContactSelectionDelegate?
    var viewmodel: ContactViewModel!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Contact> = {
        let context = DatabaseService.shared.getContext(.main)
        let fetchRequest = Contact.fetchRequest() as NSFetchRequest<Contact>

        let firstnameSortDescriptor = NSSortDescriptor(key: "name.first", ascending: true)
        let lastnameSortDescriptor = NSSortDescriptor(key: "name.last", ascending: true)

        fetchRequest.sortDescriptors = [lastnameSortDescriptor, firstnameSortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController<Contact>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
                
        return fetchedResultsController
    }()
    
    lazy var tableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(syncContacts), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Contacts ...", attributes: nil)
        return refreshControl
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        viewmodel = ContactViewModel()
        setupTableView()
        
        if UserDefaults.standard.get(.lastSynchronizationTimestamp) == nil {
            syncContacts()
        } else {
            performFetch()
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(ContactTableViewCell.self)
        tableView.refreshControl = tableRefreshControl
    }
    
    @objc private func syncContacts() {
        viewmodel.getContacts { result in
            switch result {
                case .success:
                    self.performFetch()
                
                    DispatchQueue.main.async {
                        if self.tableRefreshControl.isRefreshing {
                            self.tableRefreshControl.endRefreshing()
                        }
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    private func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Extensions

extension ContactsTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        guard let contact = fetchedResultsController.fetchedObjects?[index] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }

        cell.configureCell(contact: contact)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        guard let contact = fetchedResultsController.fetchedObjects?[index] else { return }
                        
        if let detailsVC = splitViewController?.secondaryViewController as? ContactDetailsViewController {
          splitViewController?.showDetailViewController(detailsVC, sender: nil)
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let storyboard = UIStoryboard.storyboard(.main)
            let detailsVC: ContactDetailsViewController = storyboard.instantiateViewController()
            navigationController?.pushViewController(detailsVC, animated: true)
            detailsVC.contactDidSelect(contact)
        } else {
            delegate?.contactDidSelect(contact)
        }
    }
}

extension ContactsTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        tableView.reloadData()
    }
}
