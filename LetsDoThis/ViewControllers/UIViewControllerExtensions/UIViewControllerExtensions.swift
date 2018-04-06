//
//  UIViewControllerExtensions.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 6/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Present UIViewController at the top view controller
    ///
    /// - Parameters:
    ///   - viewController: UIViewController that are going to be presented
    ///   - animated: if is it animated
    ///   - completion: completion after presentation
    static func presentViewControllerAtTopViewController(viewController:UIViewController, animated: Bool, completion:(() -> Void)? = nil) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
            topController.present(viewController, animated: true, completion: completion)
        }
    }
}

extension UIBarButtonItem {
    /// Convienience Initializer with image
    ///
    /// - Parameters:
    ///   - imageAsset: image namne
    ///   - renderingMode: image redering mode
    ///   - style: UIBarButtonItem style
    ///   - target: target
    ///   - action: action
    convenience init(with imageAsset:String, in renderingMode:UIImageRenderingMode, style:UIBarButtonItemStyle, target:Any?, action: Selector?) {
        let image = UIImage(named: imageAsset)?.withRenderingMode(renderingMode)
        self.init(image: image, style: style, target: target, action: action)
        
    }
}
