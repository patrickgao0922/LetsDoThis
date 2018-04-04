//
//  ActivityTypeCVFlowLayout.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 3/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

class ActivityTypeCVFlowLayout: UICollectionViewFlowLayout {
    
//    fileprivate var attrCache:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
//    fileprivate var contentHeight:CGFloat = 0
    
//    fileprivate var contentWidth:CGFloat {
//        guard let collectionView = self.collectionView else {
//            return 0
//        }
//        let insets = collectionView.contentInset
//        return collectionView.bounds.width - (insets.left + insets.right)
//    }
//
//    /// Must implement #1
//    override var collectionViewContentSize: CGSize {
//        return CGSize(width: contentWidth, height: contentHeight)
//    }
//
//    /// Must implement #2
    override func prepare() {
        self.itemSize = CGSize(width: 345, height: 150)
        self.headerReferenceSize = CGSize(width: 50, height: 50)
        self.headerReferenceSize = CGSize(width: 50, height: 50)
        self.minimumInteritemSpacing = 10.0
        super.prepare()
    }
//
//    //    Must implement #3
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let attributesSuper: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
//        if let attributes = NSArray(array: attributesSuper, copyItems: true) as? [UICollectionViewLayoutAttributes]{
//            var visibleRect = CGRect()
//            visibleRect.origin = collectionView!.contentOffset
//            visibleRect.size = collectionView!.bounds.size
//            for attrs in attributes {
//                if attrs.frame.intersects(rect) {
//                    let distance = visibleRect.midY - attrs.center.y
//                    let normalizedDistance = abs(distance) / (visibleRect.height / 2)
//                    let fade = 1 - normalizedDistance
//                    attrs.alpha = fade
//                }
//            }
//            return attributes
//        }else{
//            return nil
//        }
//    }
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = self.layoutAttributesForItem(at: itemIndexPath)
//        let size = self.collectionView!.frame.size
//        attr?.size = self.collectionView!.frame.size
//        attr?.center = CGPoint(x: size.width / 2.0, y: size.height)
        attr?.alpha = 0
        return attr
    }
    
    
    
    
}
