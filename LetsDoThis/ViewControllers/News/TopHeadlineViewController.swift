//
//  TopHeadlineViewController.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 16/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import RxSwift

class TopHeadlineViewController: UIViewController {
    var presenter:TopHeadlineVCPresenter!
    var news:Variable<[Article]> = Variable<[Article]>([])
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func config(with presenter:TopHeadlineVCPresenter) {
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

}

// MARK: - Setup Observables
extension TopHeadlineViewController {
    func setUpObservables() {
        _ = presenter.news.asObservable().subscribe(onNext: { (articles) in
            self.news.value = articles
        })
    }
}
