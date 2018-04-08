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
    
    var tableHeaderView: UIView!
    @IBOutlet var tableHeaderLabel: UILabel!
    
    fileprivate var headerViewHeight:CGFloat = 44
    fileprivate var headerLabelFont:CGFloat = 10.0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableViewHeader()
        updateHeaderView()
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
    
//    func table
    
    func setupTableViewHeader() {
        tableHeaderView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        self.tableView.addSubview(tableHeaderView)
        tableView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerViewHeight)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var tableViewHeaderRect = CGRect(x: 0, y: -headerViewHeight, width: tableView.bounds.width, height: headerViewHeight)
//        var font = tableHeaderLabel.font = UIFont.systemFont(ofSize: <#T##CGFloat#>)
        var newFontSize = headerLabelFont
        if tableView.contentOffset.y < -headerViewHeight {
            tableViewHeaderRect.origin.y = tableView.contentOffset.y
            tableViewHeaderRect.size.height = -tableView.contentOffset.y
            newFontSize = -tableView.contentOffset.y/headerViewHeight*headerLabelFont
        }
        tableHeaderView.frame = tableViewHeaderRect
        tableHeaderLabel.font = UIFont.systemFont(ofSize: newFontSize)
//        print(tableView.contentOffset)
        
    }
    
    
}

extension LeftSideMenuViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}
