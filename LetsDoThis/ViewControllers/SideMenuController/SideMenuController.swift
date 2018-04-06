//
//  SideMenuController.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 5/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController {
    
   
    var mainViewController:ActivityTypeVC!
    var testViewController:UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupAllChildVCs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SideMenuController {
    func initializeViewControllerFromStoryboard(from storyboard:String, with identifier:String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    func setupAllChildVCs() {
        self.mainViewController = initializeViewControllerFromStoryboard(from: "Activity", with: "ActivityTypeVC") as! ActivityTypeVC
        
        displayChildViewController(viewController: self.mainViewController)
    }
    
    func displayChildViewController(viewController:UIViewController) {
//        self.addChildViewController(viewController)
//        viewController.view.frame = self.view.bounds
//        self.view.addSubview(viewController.view)
//        self.navigationController?.addChildViewController(viewController)
//        viewController.didMove(toParentViewController: self)
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func hideChildViewController(viewController:UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}
