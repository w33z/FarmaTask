//
//  ContactTableViewCell.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Kingfisher

class ContactTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ContactTableViewCell"

    @IBOutlet private var contactImageView: UIImageView!
    @IBOutlet private var favoriteImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
    }
    
    func configureCell(contact: Contact) {
        if let first = contact.name?.first, let last = contact.name?.last {
            titleLabel.text = "\(last) \(first)"
        }
    
        if let urlString = contact.picture?.large {
            let url = URL(string: urlString)!
            contactImageView.kf.setImage(with: url)
        }
        
        let image = contact.isFavorite ? UIImage(named: "starFilled") : UIImage(named: "star")
        favoriteImageView.image = image
    }

}
