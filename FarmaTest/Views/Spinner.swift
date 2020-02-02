//
//  Spinner.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class Spinner {
    private static var container: UIView!
    private static var activityIndicator: UIActivityIndicatorView!
    
    static func show(on view: UIView) {
        let blackView = UIView()
        blackView.frame = view.bounds
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView.frame = view.bounds
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.frame.origin = blackView.center
        
        blackView.addSubview(activityIndicator)
        
        view.addSubview(blackView)
        
//        UIApplication.shared.keyWindow?.addSubview(blackView)
        Spinner.activityIndicator = activityIndicator
        Spinner.container = blackView
        activityIndicator.startAnimating()
    }
    
    static private func stop() {
        guard let spinner = Spinner.activityIndicator, let container = Spinner.container else { return }
        spinner.stopAnimating()
        container.removeFromSuperview()
    }
    
    static func hide() {
        Spinner.stop()
        Spinner.container = nil
        Spinner.activityIndicator = nil
    }
}
