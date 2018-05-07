//
//  NewsCollectionViewCell.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 1/5/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import RxSwift

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var featuredImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var featuredImageSub:Disposable?
    var disposeBag = DisposeBag()
    var vm:NewsTVCPresenter!
    
    func config(with vm:NewsTVCPresenter) {
        self.vm = vm
        titleLabel.text = vm.title
        sourceLabel.text = vm.mediaName
        timeLabel.text = vm.publishedAt?.getTimeIntervalToNow()
        featuredImage.image = nil
        featuredImageSub?.dispose()
        setupObservables()
    }
}

extension NewsCollectionViewCell {
    func setupObservables() {
        featuredImageSub = vm.featuredImage.asObservable().subscribe(onNext: { (image) in
            if let image = image {
                self.featuredImage.image = image
            }
        })
        featuredImageSub?.disposed(by: disposeBag)
    }
}
