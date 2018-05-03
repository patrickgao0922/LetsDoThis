//
//  CategoryVC.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 1/5/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import RxSwift

class CategoryVC: UIViewController {

    @IBOutlet var categoryCollectionView: UICollectionView!
    var vm:CategoryListViewModel!
    
    var disposeBag:DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        if let layout = categoryCollectionView.collectionViewLayout as? NewsCollectionViewLayout {
            layout.delegate = self
        }
        

        // Do any additional setup after loading the view.
    }
    
    func config(withViewModel vm: CategoryListViewModel) {
        self.vm = vm
        setupObservables()
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

// MARK: - Setup Observables
extension CategoryVC {
    func setupObservables() {
        _ = vm.articles.asObservable().subscribe(onNext: { (articles) in
            self.categoryCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension CategoryVC:UICollectionViewDelegate {
    
}

extension CategoryVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.featuredImage.image = UIImage(named: "side-menu-header-background")
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
}

extension CategoryVC:NewsCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        var cellHeight:CGFloat = 0
        switch indexPath.row % 4 {
        case 0:
            cellHeight = 100
        case 1:
            cellHeight = 150
        case 2:
            cellHeight = 50
        case 3:
            cellHeight = 200
        default:
            cellHeight = 100
        }
        cellHeight += 135
        return cellHeight
    }
    
    
}
