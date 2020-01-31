//
//  ContactDetailsView.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 30/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Kingfisher

class ContactDetailsView: BaseNibView {
    
    // MARK: - Propreties
    
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var contact: Contact?
    
    // MARK: - Lifecycle
    
    override func setViewApperance() {
        
    }
    
    func configureView(contact: Contact) {
        self.contact = contact
        
        if let urlString = contact.picture?.large {
            let url = URL(string: urlString)!
            profileImageView.kf.setImage(with: url)
        }
        
        if let name = contact.name, let gender = contact.gender {
            let emoji = (gender == "female" ? "👩‍💼" : "🙎‍♂️")
            nameLabel.text = """
                             \(emoji)
                             \(name.first ?? "") \(name.last ?? "")
                             """
        }
        
        if let location = contact.location, let street = location.street {
            addressLabel.text = """
                                🏙
                                \(street.name ?? "") \(street.number)
                                \(location.state ?? ""), \(location.postcode)
                                \(location.country ?? "")
                                """
        }
        
        if let email = contact.email {
            emailLabel.text = """
                               📧
                               \(email)
                              """
        }
        
        if let phone = contact.phone, let cell = contact.cell {
            phoneLabel.text = """
                              ☎️
                              \(phone) \n
                              📱
                              \(cell)
                              """
        }
        
        setupFavoriteButtonImage(isFavorite: contact.isFavorite)
    }
    
    @IBAction func favoriteButtonDidTap(_ sender: UIButton) {
        guard let contact = self.contact else { return }

    }
    
    private func setupFavoriteButtonImage(isFavorite: Bool) {
        let image = isFavorite ? UIImage(named: "starFilled") : UIImage(named: "star")
        favoriteButton.setImage(image, for: .normal)
    }
}

