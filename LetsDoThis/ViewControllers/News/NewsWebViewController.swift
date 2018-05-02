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
    var disposeBag = DisposeBag()
    var vm:NewsWebViewModel!
    var webWrapper:WKWebViewWrapper!
    var url:Variable<URL?> = Variable<URL?>(nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        activityIndicatorContainer.layer.cornerRadius = 10
        activityIndicatorContainer.clipsToBounds = true
//        setupUI()
        setupWebView()
        setupObservables()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func config(with viewModel:NewsWebViewModel) {
        self.vm = viewModel
        self.navigationItem.title = vm.sourceName
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

// MARK: - Setup UI
extension NewsWebViewController {
    func setupUI() {}
    
    func setupEditingMenu() {
        
    }
}

extension NewsWebViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicatorContainer.isHidden = true
    }
}

// MARK: - Handle Touches
extension NewsWebViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 2 && self.becomeFirstResponder() {
            let menuController = UIMenuController.shared
            let menuItem = UIMenuItem(title: NSLocalizedString("Translate", comment: ""), action: #selector(menuItemAction))
            menuController.menuItems?.insert(menuItem, at: 0)
            menuController.setMenuVisible(true, animated: true)
        }
        
//        super.touchesEnded(touches, with: event)
    }
    
    
    @objc
    func menuItemAction() {
        if let string = webView.copy() as? String {
            print(string)
        }
    }
}

// MARK: - Setup Observable
extension NewsWebViewController {
    func setupObservables() {
        _ = url.asObservable().subscribe(onNext: { (url) in
            if let url = url {
                self.webView.load(URLRequest(url: url))
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - Rich Web View
extension NewsWebViewController {
    func setupWebView() {
        self.webWrapper = WKWebViewWrapper(forWebView:webView)
    }
}
