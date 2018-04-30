//
//  TopHeadlineViewController.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 16/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import RxSwift


class TopHeadlineViewController: UIViewController {
    
    enum Segue:String {
        case showWebView = "showWebView"
    }
    var presenter:TopHeadlineVCPresenter!
    var news:Variable<[Article]> = Variable<[Article]>([])
    let disposeBag = DisposeBag()
    let tableViewHeaderHeight:CGFloat = 200
    @IBOutlet var blurView: UIVisualEffectView!
    let blurViewStartAlpha:CGFloat = 0.3
    let blurViewFinalAlpha:CGFloat = 1.0
    var headerLabelFont:CGFloat = 31
    
    var backgroundView:NewsTableBackgroundView!
    
    @IBOutlet var activityIndicatorView: UIView!
    // Header Components
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var featuredNewsTitleLable: UILabel!
    @IBOutlet var featuredNewsDateLabel: UILabel!
    @IBOutlet var featuredNewsMediaName: UILabel!
    @IBOutlet var featuredNewsFeaturedImageView: UIImageView!
    
    
    @IBOutlet var tableView: UITableView!
    var cellMaker:DependencyRegistry.NewsTVCMaker!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Today's Headlines"
        setupTableViewHeader()
    }
    
    
    
    func config(with presenter:TopHeadlineVCPresenter, cellMaker:@escaping DependencyRegistry.NewsTVCMaker) {
        self.presenter = presenter
        self.cellMaker = cellMaker
        
        setUpObservables()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueIdentifierString = segue.identifier {
            guard let segueIdentifier = Segue(rawValue: segueIdentifierString) else {
                return
            }
            switch segueIdentifier {
            case .showWebView:
                let cellPresenter = presenter.cellPresenters[tableView.indexPathForSelectedRow!.row]
                let vm = AppDelegate.dependencyRegistry!.container.resolve(NewsWebViewModel.self, argument: cellPresenter.article)!
                let destnation = segue.destination as! NewsWebViewController
                destnation.config(with: vm)
            }
        }
        
        
    }
 
    
}

extension TopHeadlineViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.value.count - 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleIndex = indexPath.row + 1
        let article = self.news.value[articleIndex]
        var cell:NewsTVC
        if presenter.cellPresenters.count < indexPath.row + 1 {
            cell = self.cellMaker(tableView,indexPath,article,nil)
            presenter.addCellPresenter(cellPresenter:cell.presenter!)
        }
        else {
            cell = self.cellMaker(tableView,indexPath,article, presenter.cellPresenters[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: Segue.showWebView.rawValue, sender: self)
    }
}

extension TopHeadlineViewController {
    func setupFeatureNews() {
        
    }
}

extension TopHeadlineViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

// MARK: - Setup UI
extension TopHeadlineViewController{
    func setupUI() {
        drawBackgroundShap()
        setupActivityIndicatorView()
    }
    func setupActivityIndicatorView() {
        let gradientColors = [UIColor(named: "gradient-start")!.cgColor,UIColor(named: "gradient-end")!.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
//        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi/8, 0, 0, 1)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
        self.activityIndicatorView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func drawBackgroundShap() {
        backgroundView = NewsTableBackgroundView(frame: self.view.bounds)
        view.insertSubview(backgroundView, at: 0)
        NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        
    }
    
}

// MARK: - Setup Observables
extension TopHeadlineViewController {
    func setUpObservables() {
        _ = presenter.news.asObservable().subscribe(onNext: { (articles) in
            self.news.value = articles
        })
        
        _ = presenter.loadLatestTopHeadline()
            .subscribe({ (single) in
                switch single {
                case .success(_):
                    self.tableView.reloadData()
                default:break
                }
                self.activityIndicatorView.isHidden = true
            })
        
        _ = presenter.featuredNewsPresenter.asObservable().subscribe(onNext: { (featuredNewsPresenter) in
            if let featuredNewsPresenter = featuredNewsPresenter {
                self.featuredNewsTitleLable.text = featuredNewsPresenter.title
                self.featuredNewsMediaName.text = featuredNewsPresenter.mediaName
                _ = featuredNewsPresenter.featuredImage.asObservable().subscribe(onNext: { (image) in
                    self.featuredNewsFeaturedImageView.image = image
                })
            }
        })
    }
}


// MARK: - Strechy header
extension TopHeadlineViewController:UIScrollViewDelegate {
    func setupTableViewHeader() {
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: tableViewHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableViewHeaderHeight)
        
        updateHeaderRect()
    }
    func updateHeaderRect() {
        var tableViewHeaderRect = CGRect(x: 0, y: -tableViewHeaderHeight, width: tableView.bounds.width, height: tableViewHeaderHeight)
        
        var newFontSize = headerLabelFont
        
//        Drag down
        if tableView.contentOffset.y < -tableViewHeaderHeight {
            let moveDifference = (tableView.contentOffset.y + tableViewHeaderHeight)
            tableViewHeaderRect.origin.y = tableView.contentOffset.y
            tableViewHeaderRect.origin.x = moveDifference
            tableViewHeaderRect.size.width = tableView.bounds.width - 2 * moveDifference
            tableViewHeaderRect.size.height = -tableView.contentOffset.y
            newFontSize = -tableView.contentOffset.y/tableViewHeaderHeight*headerLabelFont
        }
        
        if tableView.contentOffset.y > -tableViewHeaderHeight && tableView.contentOffset.y < 0 {
            let blurAlphaRange = blurViewFinalAlpha - blurViewStartAlpha
            blurView.alpha = blurViewStartAlpha + blurAlphaRange*(1 + tableView.contentOffset.y/tableViewHeaderHeight)
        }
        headerView.frame = tableViewHeaderRect
//        tableHeaderLabel.font = UIFont.systemFont(ofSize: newFontSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderRect()
    }
}
