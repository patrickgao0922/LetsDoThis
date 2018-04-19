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
        }, onError: nil, onCompleted: nil, onDisposed: disposeBag)
    }
}
