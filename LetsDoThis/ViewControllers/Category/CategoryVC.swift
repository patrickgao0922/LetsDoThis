//
//  CategoryVC.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 1/5/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    @IBOutlet var categoryCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        if let layout = categoryCollectionView.collectionViewLayout as? NewsCollectionViewLayout {
            layout.delegate = self
        }
        

        // Do any additional setup after loading the view.
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
        switch indexPath.row % 4 {
        case 0:
            return 100
        case 1:
            return 150
        case 2:
            return 50
        case 3:
            return 200
        default:
            return 100
        }
    }
    
    
}
