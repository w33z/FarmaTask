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
    
    override func awakeFromNib() {
        self.splitViewController?.delegate = self
    }
    
    private func setup() {
        viewmodel = ContactViewModel()
        setupTableView()
        
        Spinner.show(on: self.view)
        
        if UserDefaults.standard.get(.lastSynchronizationTimestamp) == nil {
            syncContacts()
        } else {
            performFetch()
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(ContactTableViewCell.self)
        tableView.registerHeaderFooter(ContactTableViewHeader.self)
        tableView.refreshControl = tableRefreshControl
        
        viewmodel.fetchedResultsController.delegate = self
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
    
    func performFetch(predicate: NSPredicate? = nil) {
        self.viewmodel.fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try self.viewmodel.fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            Spinner.hide()
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extensions

extension ContactsTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = viewmodel.fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = viewmodel.fetchedResultsController.sections else { return 0 }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        guard let contact = viewmodel.fetchedResultsController.fetchedObjects?[index] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }

        cell.configureCell(contact: contact)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                
        if section == 0 {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContactTableViewHeader") as? ContactTableViewHeader else { return nil }

            view.segmentedControlHandler = { [weak self] type in
                guard let strongSelf = self else { return }
                
                var predicate: NSPredicate?
                
                switch type {
                case .favorites:
                    predicate = NSPredicate(format: "isFavorite == YES")
                default:
                    predicate = nil
                }
            
                strongSelf.performFetch(predicate: predicate)
            }
            
            return view
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        guard let contact = viewmodel.fetchedResultsController.fetchedObjects?[index] else { return }
                        
        if let isCollapsed = splitViewController?.isCollapsed {
             if isCollapsed {
                 let storyboard = UIStoryboard.storyboard(.main)
                 let detailsVC: ContactDetailsViewController = storyboard.instantiateViewController()
               self.splitViewController?.showDetailViewController(detailsVC, sender: self)
                detailsVC.contactDidSelect(contact)

             } else {
                delegate?.contactDidSelect(contact)
             }

         }
    }
}

extension ContactsTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        tableView.reloadData()
    }
}

extension ContactsTableViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
