//
//  PGActivityIndicator.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 24/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

class PGActivityIndicator: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    @IBInspectable open var trackBorderWidth: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        let innerRect = rect.insetBy(dx: trackBorderWidth, dy: trackBorderWidth)
    }
    
     

}
