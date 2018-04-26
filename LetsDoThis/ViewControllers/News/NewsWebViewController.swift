//
//  NewsWebViewController.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 24/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

class NewsWebViewController: UIViewController {
    @IBOutlet var activityIndicatorContainer: UIVisualEffectView!
    @IBOutlet var activityIndicator: PGActivityIndicator!
    @IBOutlet var webView: WKWebView!
    var vm:NewsWebViewModel!
    var url:Variable<URL?> = Variable<URL?>(nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        activityIndicatorContainer.layer.cornerRadius = 10
        activityIndicatorContainer.clipsToBounds = true
        setupObservables()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func config(with viewModel:NewsWebViewModel) {
        self.vm = viewModel
        if let url = URL(string: vm.url) {
            self.url.value = url
        }
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

extension NewsWebViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicatorContainer.isHidden = true
    }
}

// MARK: - Setup Observable
extension NewsWebViewController {
    func setupObservables() {
        _ = url.asObservable().subscribe(onNext: { (url) in
            if let url = url {
                self.webView.load(URLRequest(url: url))
            }
        })
    }
    
}
