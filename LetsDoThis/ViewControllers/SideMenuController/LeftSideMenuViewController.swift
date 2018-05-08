//
//  LeftSideMenuViewController.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 6/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import PGModelViewController

protocol LeftSideMenuViewControllerDelegate {
    func optionSelected(option:MenuOption)
}

enum MenuOption:String {
    case topHeadline = "Today's Headlines"
    case interest = "Interests"
//    case main = "Main"
}

class LeftSideMenuViewController: PGModelViewController{
    let cellIdentifier = "menuCell"
    @IBOutlet var tableView: UITableView!
    
    var leftSideMenuViewControllerDelegate:LeftSideMenuViewControllerDelegate!
    
    var tableHeaderView: UIView!
    var tableHeaderMask:CAShapeLayer?
    @IBOutlet var tableHeaderLabel: UILabel!
    
    fileprivate var headerViewHeight:CGFloat = 200
    fileprivate var headerMaskCuttingAwayHeight:CGFloat = 30.0
    fileprivate var headerLabelFont:CGFloat = 17.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        setupTableViewHeader()
        setupUI()
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

// MARK: - Setup UI
extension LeftSideMenuViewController {
    func setupUI() {
        let gradientColors = [UIColor(named: "gradient-start")!.cgColor,UIColor(named: "gradient-end")!.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.layer.insertSublayer(gradientLayer, at: 0)
        setupBlurEffect()
    }
    
    func setupBlurEffect() {

        // blur
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView.init(effect: blurEffect)
//        blurView.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        blurView.backgroundColor = UIColor.clear
        blurView.alpha = 0.3
        blurView.clipsToBounds = true
        blurView.frame = tableView.backgroundView!.bounds
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)

        
        // add the label to effect view
        self.tableView.backgroundView?.addSubview(blurView)
        self.tableView.separatorEffect = vibrancyEffect

    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let bgLayer = self.tableView.backgroundView?.layer.sublayers?[0]
        coordinator.animate(alongsideTransition: { (_) in
            if self.sizeClass().verticalSizeClass == .regular {
                bgLayer?.frame = CGRect(origin: .zero, size: size)
            }
        }, completion: {(_) in
            if self.sizeClass().verticalSizeClass == .compact {
                bgLayer?.frame = CGRect(origin: .zero, size: size)
            }
            
        })
        
//        bgLayer?.removeFromSuperlayer()
        
//        self.table
    }
}

// MARK: - Drag Behavior
extension LeftSideMenuViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! LeftMenuOptionTableViewCell
        switch indexPath.row {
//        case 0 :
//            cell.textLabel!.text = MenuOption.main.rawValue
        case 0:
            cell.optionNameLabel!.text = NSLocalizedString(MenuOption.topHeadline.rawValue, comment: "")
            
        case 1:
            cell.optionNameLabel!.text = NSLocalizedString(MenuOption.interest.rawValue, comment: "")
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            var selectedOption = MenuOption.topHeadline
            switch indexPath.row {
//            case 0:
//                selectedOption = .main
            case 0:
                selectedOption = MenuOption.topHeadline
            case 1:
                selectedOption = MenuOption.interest
            default:
                break
            }
            self.leftSideMenuViewControllerDelegate.optionSelected(option: selectedOption)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //    func table
    
    func setupTableViewHeader() {
        tableHeaderView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        self.tableView.addSubview(tableHeaderView)
        tableView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerViewHeight)
        
        tableHeaderMask = CAShapeLayer()
        tableHeaderMask!.fillColor = UIColor.black.cgColor
        tableHeaderView.layer.mask = tableHeaderMask
        
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
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: tableViewHeaderRect.size.width,y: 0))
        path.addLine(to: CGPoint(x: tableViewHeaderRect.size.width,y: tableViewHeaderRect.size.height))
        path.addLine(to: CGPoint(x: 0, y: tableViewHeaderRect.size.height - headerMaskCuttingAwayHeight))
        tableHeaderMask?.path = path.cgPath
        
        
    }
    
    func drawCuttingMask() {
        
        
    }
    
    
}

extension LeftSideMenuViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}
