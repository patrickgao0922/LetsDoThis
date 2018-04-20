//
//  NewsTVC.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 16/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import RxSwift

class NewsTVC: UITableViewCell {
    
    /// News Table View Cell UI components
    @IBOutlet var mediaIcon: UIImageView!
    @IBOutlet var mediaNameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var featuredImage: UIImageView!
    var presenter:NewsTVCPresenter!
    
    fileprivate var disposeBag: DisposeBag = DisposeBag()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - Config
extension NewsTVC {
    func config(with presenter:NewsTVCPresenter) {
        self.presenter = presenter
        setupCell()
        setupObservables()
    }
    
    func setupCell() {
        self.mediaNameLabel.text = presenter.mediaName
        self.titleLabel.text = presenter.title
    }
}

// MARK: - Setup Observable
extension NewsTVC {
    
    func setupObservables() {
        _ = presenter.featuredImagePath.asObservable().subscribe(onNext: { (imagePath) in
            if let imagePath = imagePath {
                let image = UIImage(contentsOfFile: imagePath)
                self.featuredImage.image = image
            }
        })
        _ = presenter.mediaIconPath.asObservable().subscribe(onNext: {(imagePath) in
            if let imagePath = imagePath {
                let image = UIImage(contentsOfFile: imagePath)
                self.mediaIcon.image = image
            }
        })
        presenter.loadFeaturedImage()
        presenter.loadMediaIcon()
    }
}
