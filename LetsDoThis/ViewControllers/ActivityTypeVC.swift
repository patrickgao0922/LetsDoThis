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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if AppDelegate.dependencyRegistry == nil {
            AppDelegate.dependencyRegistry = DependencyRegistry(container: SwinjectStoryboard.defaultContainer)
        }
        self.config(withActivityTypeVCPresenter: AppDelegate.dependencyRegistry!.container.resolve(ActivityTypeVCPresenter.self)!)
        
        setUpObservable()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func config(withActivityTypeVCPresenter presenter:ActivityTypeVCPresenter) {
        self.presenter = presenter
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ActivityTypeCVCell
        let dto = self.presenter.activityTypes.value[indexPath.row]
        cell.activityNameLabel.text = dto.name
        cell.activityIconImageView.image = UIImage(named: dto.icon)
        return cell
    }
    
    
}

extension ActivityTypeVC {
    
}

// MARK: - Setup Observable
extension ActivityTypeVC {
    func setUpObservable() {
        self.presenter.activityTypes.asObservable().subscribe(onNext: { (activityTypeDTOs) in
            self.collectionView.reloadData()
        })
    }
}
