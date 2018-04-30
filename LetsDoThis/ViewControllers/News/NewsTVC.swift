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
    @IBOutlet var featuredImageContainerView: UIView!
    
    @IBOutlet var activityIndicatorView: UIVisualEffectView!
    
    var presenter:NewsTVCPresenter?
    
    var featuredImageSub:Disposable?
    
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
        featuredImageSub?.dispose()
        setupCell()
        setupObservables()
    }
    
    func setupCell() {
//        self.activityIndicatorView.layer.cornerRadius = 5
        self.featuredImageContainerView.layer.shadowColor = UIColor.black.cgColor
        self.featuredImageContainerView.layer.shadowOpacity = 1
        featuredImageContainerView.layer.shadowOffset = CGSize(width: -5, height: 5)
        featuredImageContainerView.layer.shadowRadius = 5
        self.mediaNameLabel.text = presenter?.mediaName
        self.titleLabel.text = presenter?.title
        if let date = presenter?.publishedAt {
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
        self.featuredImage.image = nil
        self.activityIndicatorView.isHidden = false
    }
}

// MARK: - Setup Observable
extension NewsTVC {
    
    func setupObservables() {
        featuredImageSub = presenter?.featuredImage.asObservable()
            .subscribe(onNext: { [unowned self] (image) in

                
            
            if image != nil {
                self.featuredImage.image = image
                self.activityIndicatorView.isHidden = true
            }
            
        })
        featuredImageSub?.disposed(by: disposeBag)
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
