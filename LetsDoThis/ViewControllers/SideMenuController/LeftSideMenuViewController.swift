//
//  LeftSideMenuViewController.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 6/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import PGModelViewController


enum MenuOption:String {
    case test = "testSegue"
}

class LeftSideMenuViewController: PGModelViewController{
    let cellIdentifier = "menuCell"
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var tableHeaderLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
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

extension LeftSideMenuViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        switch indexPath.row {
        case 0 :
            cell.textLabel!.text = "test"
        default:
            break
        }
        return cell
    }
}
