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
    
    
}

extension ActivityTypeVC {
    
}

// MARK: - Setup Observable
extension ActivityTypeVC {
    func setUpObservable() {
        _ = self.presenter.activityTypes.asObservable().subscribe(onNext: { (activityTypeDTOs) in
            self.collectionView.reloadData()
        })
    }
}
