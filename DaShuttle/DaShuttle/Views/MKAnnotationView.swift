//
//  MKAnnotationView.swift
//  DaShuttle
//
//  Created by John M Cruz on 11/20/18.
//  Copyright © 2018 John M Cruz. All rights reserved.
//

import MapKit
import UIKit

extension MKAnnotationView {
    func animate() {
        let scaleTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)  // Scale
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = scaleTransform
            self.layoutIfNeeded()
        }) { (isCompleted) in
            
            // Nested block of animation
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.layoutIfNeeded()
            })
        }
    }
}
