//
//  ActivityTypeCVCell.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 24/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit


class ActivityTypeCVCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var activityIconImageView: UIImageView!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    
    @IBInspectable var cornerRadius:CGFloat {
        set(value){
            self.layer.cornerRadius = value
        }
        get {
            return self.layer.cornerRadius
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
//        setup()
    }
    
}

extension ActivityTypeCVCell {
    func setup() {
        self.cornerRadius = 10
    }
}
