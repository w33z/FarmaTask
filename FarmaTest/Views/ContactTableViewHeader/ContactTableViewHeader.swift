//
//  ContactTableViewHeader.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 01/02/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

enum ContactsType: String {
    case all
    case favorites
}

class ContactTableViewHeader: UITableViewHeaderFooterView {

    // MARK: - Properties
    
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    var segmentedControlHandler: ((_ type: ContactsType) -> ())?
    
    // MARK: - Lifecycle
        
    @IBAction func segmentedControlValueChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let type: ContactsType = (index == 0 ? .all : .favorites)
        segmentedControlHandler?(type)
    }

}
