//
//  BaseNibView.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 31/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class BaseNibView: UIView {
    
    // MARK: - Properties
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // MARK: - Public methods
    
    func setViewApperance() {}
    
    // MARK: - Private methods
    
    private func loadViewFromNib() {
        view = loadNib()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let views = ["view": view]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: views as [String : Any])
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views as [String : Any])
        addConstraints(verticalConstraints + horizontalConstraints)
        
        setViewApperance()
    }
    
    private func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
}
