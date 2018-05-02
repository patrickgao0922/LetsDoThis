//
//  WKWebViewWrapper.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 2/5/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import WebKit

enum WebEvent:String {
    case imageChanged
    case documentReady
    
    static var array: [WebEvent] {
        var a: [WebEvent] = []
        switch WebEvent.imageChanged {
        case .imageChanged: a.append(.imageChanged); fallthrough
        case .documentReady: a.append(.documentReady);
        }
        return a
    }
}
class WKWebViewWrapper:NSObject,WKScriptMessageHandler {
    
    var webView : WKWebView
    
    var eventFunctions:[WebEvent: (String) -> Void]
    
    init(forWebView webView : WKWebView){
        self.webView = webView
        self.eventFunctions = [WebEvent: (String) -> Void]()
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    func setUpPlayerAndEventDelegation() {
        let userContentController = WKUserContentController()
        webView.configuration.userContentController = userContentController
        
        for event in WebEvent.array {
            userContentController.add(self, name: event.rawValue)
        }
    }
}
