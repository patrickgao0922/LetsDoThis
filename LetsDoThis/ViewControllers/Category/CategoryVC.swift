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
    var cellMaker:DependencyRegistry.NewsCollectionViewCellMaker!
    var articles:Variable<[Article]>!
    var disposeBag:DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        articles = Variable<[Article]>([])
        if let layout = categoryCollectionView.collectionViewLayout as? NewsCollectionViewLayout {
            layout.delegate = self
        }
        
        setupObservables()
        

        // Do any additional setup after loading the view.
    }
    
    func config(withViewModel vm: CategoryListViewModel, cellMaker:@escaping DependencyRegistry.NewsCollectionViewCellMaker) {
        self.vm = vm
        self.cellMaker = cellMaker
        
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
//        _ = vm.articles.asObservable().subscribe(onNext: { (articles) in
//            self.categoryCollectionView.reloadData()
//        }).disposed(by: disposeBag)
        vm.articles.drive(self.articles).disposed(by: disposeBag)
        
        articles.asObservable().subscribe(onNext: { (_) in
            self.categoryCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        
    }
    
}

extension CategoryVC:UICollectionViewDelegate {
    
}

extension CategoryVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
//        cell.featuredImage.image = UIImage(named: "side-menu-header-background")
//        return cell
        var cell:NewsCollectionViewCell! = nil
        if vm.cellViewModels.count < indexPath.row + 1 {
            cell = cellMaker(collectionView,indexPath,articles.value[indexPath.row],nil)
            vm.addViewModel(viewModel: cell.vm)
        } else{
            let cellVM = vm.cellViewModels[indexPath.row]
            cell = cellMaker(collectionView,indexPath,articles.value[indexPath.row],cellVM)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.value.count
    }
}

extension CategoryVC:NewsCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let number = arc4random_uniform(4) + 1
        var cellHeight:CGFloat = 0
        switch number {
        
        case 1:
            cellHeight = 200
        case 2:
            cellHeight = 250
        case 3:
            cellHeight = 300
        case 4:
            cellHeight = 350
        default:
            cellHeight = 300
        }
        cellHeight += 150
        return cellHeight
    }
    
    
}
