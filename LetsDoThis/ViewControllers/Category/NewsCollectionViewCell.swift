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
    var disposeBag = DisposeBag()
    var vm:NewsTVCPresenter!
    
    func config(with vm:NewsTVCPresenter) {
        self.vm = vm
        setupObservables()
    }
}

extension NewsCollectionViewCell {
    func setupObservables() {
        _ = vm.featuredImage.asObservable().subscribe(onNext: { (image) in
            if let image = image {
                self.featuredImage.image = image
            }
        }).disposed(by: disposeBag)
    }
}
