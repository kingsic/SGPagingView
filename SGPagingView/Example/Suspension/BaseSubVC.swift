//
//  BaseSubVC.swift
//  SGPagingView
//
//  Created by kingsic on 2021/10/20.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit

class BaseSubVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 监听主视图发出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(pageTitleViewToTop), name: NSNotification.Name(NNLesstMainHeaderViewHeight), object: nil)
    }
    
    var subScrollView: UIScrollView?
    
    func subScrollViewDidScroll(_ scrollView: UIScrollView) {
        subScrollView = scrollView
        
        NotificationCenter.default.post(name: NSNotification.Name(NNSubScrollViewDidScroll), object: scrollView)
    }
    
    @objc func pageTitleViewToTop() {
        subScrollView?.contentOffset = .zero
    }
    
    deinit {
        print("BaseSubVC")
    }
    
}
