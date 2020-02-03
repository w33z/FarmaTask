//
//  ContactDetailsViewController.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 27/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private var detailsView: ContactDetailsView!
    
    private var viewmodel: ContactViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setupCallbacks() {
        detailsView.favoriteButtonTapHandler = { [weak self] contact in
            guard let strongSelf = self else { return }
            let updateResult = strongSelf.viewmodel.updateContactFavorite(contact: contact)
            
            switch updateResult {
            case .success():
                debugPrint("Update isFavorite flag success")
            case .failure(let error):
                strongSelf.showAlert(error.localizedDescription)
            }
        }
    }
    
    private func setup() {
        viewmodel = ContactViewModel()
        guard let masterVC = self.splitViewController?.primaryViewController as? ContactsTableViewController else { return }
        masterVC.delegate = self
        
        splitViewController?.preferredDisplayMode = .allVisible
        
        setupCallbacks()
    }
}

extension ContactDetailsViewController: ContactSelectionDelegate {
    func contactDidSelect(_ contact: Contact) {
        loadViewIfNeeded()
        detailsView.configureView(contact: contact)
    }
}
