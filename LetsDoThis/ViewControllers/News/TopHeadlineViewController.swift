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
    var presenter:TopHeadlineVCPresenter!
    var news:Variable<[Article]> = Variable<[Article]>([])
    let disposeBag = DisposeBag()
    
    // Header Components
    
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
        // Do any additional setup after loading the view.
    }
    
    func config(with presenter:TopHeadlineVCPresenter, cellMaker:@escaping DependencyRegistry.NewsTVCMaker) {
        self.presenter = presenter
        self.cellMaker = cellMaker
        
        setUpObservables()
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
            presenter.addCellPresenter(cellPresenter:cell.presenter)
        }
        else {
            cell = self.cellMaker(tableView,indexPath,article, presenter.cellPresenters[indexPath.row])
        }
        return cell
    }
}

extension TopHeadlineViewController {
    func setupFeatureNews() {
        
    }
}

extension TopHeadlineViewController:UITableViewDelegate {
    
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
