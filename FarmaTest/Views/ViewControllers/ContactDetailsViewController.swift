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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        guard let masterVC = self.splitViewController?.primaryViewController as? ContactsTableViewController else { return }
        masterVC.delegate = self
        
        splitViewController?.preferredDisplayMode = .allVisible
    }
}

extension ContactDetailsViewController: ContactSelectionDelegate {
    func contactDidSelect(_ contact: Contact) {
        loadViewIfNeeded()
        detailsView.configureView(contact: contact)
    }
}
