//
//  ActivityTypeTVC.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 22/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

class ActivityTypeTVC: UITableViewCell {

    @IBOutlet var backgroundImageView: UIImageView!
    
    
    @IBOutlet var activityIconImageView: UIImageView!
    @IBOutlet var activityNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
