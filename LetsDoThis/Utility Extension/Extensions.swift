//
//  Extensions.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 3/5/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

extension Date {
    func getTimeIntervalToNow() -> String {
        var string = ""
        let components = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfYear,.month], from: self, to: Date())
        if components.month != nil && components.month! != 0{
            string = "\(components.month!) months ago"
            
        } else if components.weekOfYear != nil && components.weekOfYear! != 0 {
            string = "\(components.weekOfYear!) weeks ago"
            
        } else if components.day != nil && components.day! != 0 {
            string = "\(components.day!) days ago"
            
        } else if components.hour != nil && components.hour! != 0 {
            string = "\(components.hour!) hours ago"
            
        } else if components.minute != nil && components.minute! != 0 {
            string = "\(components.minute!) minutes ago"
            
        } else if components.second != nil && components.second! != 0 {
            string = "\(components.second!) seconds ago"
        }
        return string
    }
}
extension UIViewController {
    func sizeClass() -> (horizontalSizeClass:UIUserInterfaceSizeClass, verticalSizeClass:UIUserInterfaceSizeClass) {
        return (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass)
    }
}
