//
//  SideMenuNavigationController.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 5/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import PGModelViewController

class SideMenuNavigationController: UINavigationController {
    
    enum Segues:String {
        case sideMenu = "sideMenuSegue"
    }
    
    
    var sideMenuButtonItem:UIBarButtonItem!
    var pgModelViewControllerDelegate:PGModelViewControllerDelegate!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pgModelViewControllerDelegate = PGModelViewControllerDelegate()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        guard let segueIdentifier = segue.identifier else{
            return
        }
        if segueIdentifier == Segues.sideMenu.rawValue {
//            let controller = segue.destination as! PGModelViewController
            setupLeftSideMenuViewController(forSegue:segue)
        }
        
    }
    
    fileprivate func setupLeftSideMenuViewController(forSegue segue:UIStoryboardSegue){
        let controller = segue.destination as! LeftSideMenuViewController
        controller.transitioningDelegate = pgModelViewControllerDelegate
        controller.presentationStyle = .sideMenu
        controller.direction = .left
        controller.navigationItem.leftBarButtonItems = self.navigationItem.leftBarButtonItems
        controller.leftSideMenuViewControllerDelegate = self
    }
 

}

extension SideMenuNavigationController {
    func setup() {
//        let menuImage = UIImage(named: )?.withRenderingMode(.alwaysOriginal)
        sideMenuButtonItem = UIBarButtonItem(with:"icon-side-menu-button",in:.automatic, style: .plain, target: self, action: #selector(tapSideMenuButton))
//        if self.navigationItem.leftBarButtonItems != nil {
//            self.navigationItem.leftBarButtonItems?.insert(sideMenuButtonItem, at: 0)
//        } else {
//            self.navigationItem.leftBarButtonItems = [sideMenuButtonItem]
//            print("")
//        }
        self.navigationItem.leftBarButtonItems = [sideMenuButtonItem!]
        self.topViewController?.navigationItem.leftBarButtonItems = self.navigationItem.leftBarButtonItems
        
//        make bg clear
//        self.navigationBar.isTranslucent = true
        
    }
    
    @objc
    func tapSideMenuButton() {
        self.performSegue(withIdentifier: Segues.sideMenu.rawValue, sender: self)
    }
}

extension SideMenuNavigationController:LeftSideMenuViewControllerDelegate {
    func optionSelected(option: MenuOption) {
        var switchedVC:UIViewController!
        switch option {
//        case .main:
//            switchedVC = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "ActivityTypeVC")
        case .topHeadline:
            switchedVC = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "topHeadlineVC")
        case .interest:
            switchedVC = UIStoryboard(name: "Category", bundle: nil).instantiateViewController(withIdentifier: "categoryVC")
        }
        self.viewControllers = [switchedVC]
        setup()
    }
}
