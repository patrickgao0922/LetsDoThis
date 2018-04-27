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
    @IBOutlet var timeLabel: UILabel!
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
        if let featuredImagePath = self.presenter.featuredImagePath.value {
            self.featuredImage.image = UIImage(contentsOfFile: featuredImagePath)
        }
        if let date = presenter.publishedAt {
            let components = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfYear,.month], from: date, to: Date())
            if components.month != nil && components.month! != 0{
                    timeLabel.text = "\(components.month!) months ago"
                
            } else if components.weekOfYear != nil && components.weekOfYear! != 0 {
                    timeLabel.text = "\(components.weekOfYear!) weeks ago"
                
            } else if components.day != nil && components.day! != 0 {
                    timeLabel.text = "\(components.day!) days "
                
            } else if components.hour != nil && components.hour! != 0 {
                timeLabel.text = "\(components.hour!) days "
                
            } else if components.minute != nil && components.minute! != 0 {
                    timeLabel.text = "\(components.minute!) minutes "
                
            } else if components.second != nil && components.second! != 0 {
                timeLabel.text = "\(components.second!) seconds ago"
            }
            
        }
//        if let mediaIconPath = self.presenter.mediaIconPath.value {
//            self.mediaIcon.image = UIImage(contentsOfFile: mediaIconPath)
//        }
        self.featuredImage.layer.cornerRadius = 5.0
    }
}

// MARK: - Setup Observable
extension NewsTVC {
    
    func setupObservables() {
        _ = presenter.featuredImage.asObservable().subscribe(onNext: { (image) in

                
                self.featuredImage.image = image
            
        })
//        _ = presenter.mediaIcon.asObservable().subscribe(onNext: {(image) in
//
//                
//                self.mediaIcon.image = image
//
//        })
//        presenter.loadFeaturedImage()
//        presenter.loadMediaIcon()
    }
}
