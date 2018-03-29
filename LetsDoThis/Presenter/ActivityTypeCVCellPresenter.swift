//
//  ActivityTypeCVCellPresenter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 29/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

protocol ActivityTypeCVCellPresenter {
    static func dequeue(forCollectionView collectionView:UICollectionView, at indexPath:IndexPath)
}
