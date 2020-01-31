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
        
        let whiteView = UIView()
        blackView.backgroundColor = .white
        
//        let origin = CGPoint(x: blackView.frame.width / 2, y: blackView.frame.height / 2)
        let size = CGSize(width: 100, height: 100)
        blackView.frame = CGRect(origin: blackView.center, size: size)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.frame.origin = whiteView.center
        
//        whiteView.addSubview(activityIndicator)
        blackView.addSubview(whiteView)
        
        view.addSubview(blackView)

//        UIApplication.shared.keyWindow?.addSubview(blackView)
        Spinner.activityIndicator = activityIndicator
        Spinner.container = blackView
        activityIndicator.startAnimating()
    }
    
    static func hide() {
        Spinner.activityIndicator.stopAnimating()
        Spinner.container.removeFromSuperview()
        Spinner.container = nil
        Spinner.activityIndicator = nil
    }
}
