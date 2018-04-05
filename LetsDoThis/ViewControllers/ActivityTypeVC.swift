//
//  ActivityTypeVC.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 24/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard
import RxSwift
fileprivate let cellIdentifier = "ActivityTypeCVCell"

class ActivityTypeVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var presenter:ActivityTypeVCPresenter!
    var disposeBag:DisposeBag = DisposeBag()
    var cellMaker:DependencyRegistry.ActivityTypeCVCellMaker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let layout = ActivityTypeCVFlowLayout()
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        setupCVUI()
        setUpObservable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func config(withActivityTypeVCPresenter presenter:ActivityTypeVCPresenter, cellMaker:@escaping DependencyRegistry.ActivityTypeCVCellMaker) {
        self.presenter = presenter
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

    @IBAction func reloadButtonTouched(_ sender: Any) {
        self.presenter.loadActivityTypes().subscribe().disposed(by: self.disposeBag)
    }
}

extension ActivityTypeVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.activityTypes.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dto = self.presenter.activityTypes.value[indexPath.row]
        let cell = self.cellMaker(collectionView,indexPath,dto)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)        }
//    }
    
    
    
}

// MARK: - UI config
extension ActivityTypeVC {
    func setupCVUI() {
        let gradientColors = [UIColor(named: "gradient-start")!.cgColor,UIColor(named: "gradient-end")!.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

// MARK: - Setup Observable
extension ActivityTypeVC {
    func setUpObservable() {
        _ = self.presenter.activityTypes.asObservable().subscribe(onNext: { (activityTypeDTOs) in
//            self.collectionView.reloadData()
            
            
            
            
//            Delete all elements
            self.collectionView.performBatchUpdates({
                var oldIndexPaths = [IndexPath]()
                for indexRow in 0..<self.collectionView.numberOfItems(inSection: 0) {
                    let indexPath = IndexPath(row: indexRow, section: 0)
                    oldIndexPaths.append(indexPath)
                }
                if self.collectionView.numberOfItems(inSection: 0) != 0 {
                    self.collectionView.deleteItems(at: oldIndexPaths)
                }
                
                var newIndexPaths = [IndexPath]()
                for indexRow in 0..<activityTypeDTOs.count {
                    let indexPath = IndexPath(row: indexRow, section: 0)
                    newIndexPaths.append(indexPath)
                }
                self.collectionView.insertItems(at: newIndexPaths)
            }, completion: nil)
            
//            Insert all elements again
//            self.collectionView.performBatchUpdates({
//
//            }, completion: nil)
        })
    }
}
