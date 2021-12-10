//
//  BaseTableView.swift
//  SGPagingView
//
//  Created by kingsic on 2021/10/20.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit

/// 监听子视图滚动方法名
let NNSubScrollViewDidScroll = "NNSubScrollViewDidScroll"
/// 监听主视图滚动方法名
let NNLesstMainHeaderViewHeight = "NNLesstMainHeaderViewHeight"
/// 监听子视图左右滚动方法名
let NNSubScrollViewLRScroll = "NNSubScrollViewLRScroll"

class BaseTableView: UITableView, UIGestureRecognizerDelegate {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        NotificationCenter.default.addObserver(self, selector: #selector(subScrollViewLRScroll), name: NSNotification.Name(NNSubScrollViewLRScroll), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tempLRScroll: Bool = true
    @objc func subScrollViewLRScroll(noti: Notification) {
        tempLRScroll = noti.object as! Bool
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if tempLRScroll == false {
            return false
        }
        return true
    }

}
