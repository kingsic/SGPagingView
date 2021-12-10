//
//  BaseSubProVC.swift
//  SGPagingView
//
//  Created by kingsic on 2021/10/20.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit

/// 监听子视图滚动方法名
let NNProSubScrollViewDidScroll = "NNProSubScrollViewDidScroll"

let pro_subScrollViewContentOffsetY: CGFloat = pro_headerViewHeight + pro_pagingTitleViewHeight

class BaseSubProVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /// 标记子 scrollView
    public var scrollView: UIScrollView?
    
    /// 标记子 scrollView 的 contentOffset
    fileprivate var scrollViewContentOffset: CGPoint = .zero

    /// 供子类调用
    func subScrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        
        // 子 scrollView 的偏移量差值
        let offsetDifference = scrollView.contentOffset.y - scrollViewContentOffset.y

        let tempUserInfo: [String : Any] = ["scrollingScrollView": scrollView, "offsetDifference": offsetDifference]
        // 子 scrollVIew 滚动时，发通知告诉主控制器
        NotificationCenter.default.post(name: NSNotification.Name(NNProSubScrollViewDidScroll), object: scrollView, userInfo: tempUserInfo)
        
        // 标记子 scrollVIew 的 contentOffset
        scrollViewContentOffset = scrollView.contentOffset
    }
    
    deinit {
        print("BaseSubProVC")
    }
    
}
