//
//  SuspensionProVC.swift
//  SGPagingView
//
//  Created by kingsic on 2021/10/20.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit

let pro_headerViewHeight: CGFloat = 270
let pro_pagingTitleViewHeight: CGFloat = 40

let navHeight: CGFloat = 44 + UIScreen.statusBarHeight

class SuspensionProVC: UIViewController {
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let configure = SGPagingTitleViewConfigure()
        configure.color = .lightGray
        configure.selectedColor = .black
        configure.indicatorType = .Dynamic
        configure.indicatorColor = .orange
        configure.showBottomSeparator = false
        
        let frame = CGRect.init(x: 0, y: pro_headerViewHeight, width: view.frame.size.width, height: pro_pagingTitleViewHeight)
        let titles = ["精选", "微博", "相册"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.delegate = self
        return pagingTitle
    }()
    
    var tempBaseSubVCs: [BaseSubProVC] = []
    
    lazy var pagingContentView: SGPagingContentScrollView = {
        let vc1 = SubProVC()
        let vc2 = SubTitleProVC()
        let vc3 = SubProVC()
        let vcs = [vc1, vc2, vc3]
        tempBaseSubVCs = vcs
        
        let tempRect: CGRect = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        let pagingContent = SGPagingContentScrollView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        return pagingContent
    }()
    
    lazy var headerView: UIView = {
        let headerView: UIView = UIView()
        headerView.backgroundColor = .red
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: pro_headerViewHeight)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan_action))
        headerView.addGestureRecognizer(pan)
        let btn = UIButton(type: .custom)
        let btn_width: CGFloat = 200
        let btn_x = 0.5 * (view.frame.width - btn_width)
        btn.frame = CGRect(x: btn_x, y: pro_headerViewHeight - 100, width: btn_width, height: 50)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .black
        btn.setTitle("You know？I can click", for: .normal)
        btn.addTarget(self, action: #selector(temp_btn_action), for: .touchUpInside)
        headerView.addSubview(btn)
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(UIView())
        view.addSubview(pagingContentView)
        view.addSubview(headerView)
        view.addSubview(pagingTitleView)
        
        tempLastPagingTitleViewY = pro_headerViewHeight

        // 监听子视图发出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(subTableViewDidScroll), name: NSNotification.Name(NNProSubScrollViewDidScroll), object: nil)
    }
    
    var tempSubScrollView: UIScrollView?
    var tempLastPagingTitleViewY: CGFloat = 0
    var tempLastPoint: CGPoint = .zero

    deinit {
        print("SuspensionProVC")
    }
}

extension SuspensionProVC {
    @objc func pan_action(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            
        } else if pan.state == .changed {
            let currenrPoint: CGPoint = pan.translation(in: pan.view)
            let distanceY = currenrPoint.y - tempLastPoint.y
            tempLastPoint = currenrPoint
            let baseSubVC = tempBaseSubVCs[pagingTitleView.index]
            var contentOffset: CGPoint = baseSubVC.scrollView!.contentOffset
            contentOffset.y += -distanceY
            if contentOffset.y <= -pro_subScrollViewContentOffsetY {
                contentOffset.y = -pro_subScrollViewContentOffsetY
            }
            baseSubVC.scrollView?.contentOffset = contentOffset
        } else {
            pan.setTranslation(.zero, in: pan.view)
            tempLastPoint = .zero
        }
    }
}

extension SuspensionProVC {
    @objc func subTableViewDidScroll(noti: Notification) {
        let scrollingScrollView = noti.userInfo!["scrollingScrollView"] as! UIScrollView
        let offsetDifference: CGFloat = noti.userInfo!["offsetDifference"] as! CGFloat
        
        var distanceY: CGFloat = 0
        
        let baseSubVC = tempBaseSubVCs[pagingTitleView.index]
        
        // 当前滚动的 scrollView 不是当前显示的 scrollView 直接返回
        guard scrollingScrollView == baseSubVC.scrollView else {
            return
        }
        var pagingTitleViewFrame: CGRect = pagingTitleView.frame
        guard pagingTitleViewFrame.origin.y >= navHeight else {
            return
        }
        
        let scrollViewContentOffsetY = scrollingScrollView.contentOffset.y
        
        // 往上滚动
        if offsetDifference > 0 && scrollViewContentOffsetY + pro_subScrollViewContentOffsetY > 0 {
            if (scrollViewContentOffsetY + pro_subScrollViewContentOffsetY + pagingTitleView.frame.origin.y) > pro_headerViewHeight || scrollViewContentOffsetY + pro_subScrollViewContentOffsetY < 0 {
                pagingTitleViewFrame.origin.y += -offsetDifference
                if pagingTitleViewFrame.origin.y <= navHeight {
                    pagingTitleViewFrame.origin.y = navHeight
                }
            }
        } else { // 往下滚动
            if (scrollViewContentOffsetY + pagingTitleView.frame.origin.y + pro_subScrollViewContentOffsetY) < pro_headerViewHeight {
                pagingTitleViewFrame.origin.y = -scrollViewContentOffsetY - pro_pagingTitleViewHeight
                if pagingTitleViewFrame.origin.y >= pro_headerViewHeight {
                    pagingTitleViewFrame.origin.y = pro_headerViewHeight
                }
            }
        }
        
        // 更新 pagingTitleView 的 frame
        pagingTitleView.frame = pagingTitleViewFrame
        
        // 更新 headerView 的 frame
        var headerViewFrame: CGRect = headerView.frame
        headerViewFrame.origin.y = pagingTitleView.frame.origin.y - pro_headerViewHeight
        headerView.frame = headerViewFrame
        
        distanceY = pagingTitleViewFrame.origin.y - tempLastPagingTitleViewY
        tempLastPagingTitleViewY = pagingTitleView.frame.origin.y
        
        /// 让其余控制器的 scrollView 跟随当前正在滚动的 scrollView 而滚动
        otherScrollViewFollowingScrollingScrollView(scrollView: scrollingScrollView, distanceY: distanceY)
    }
    
    /// 让其余控制器的 scrollView 跟随当前正在滚动的 scrollView 而滚动
    func otherScrollViewFollowingScrollingScrollView(scrollView: UIScrollView, distanceY: CGFloat) {
        var baseSubVC: BaseSubProVC
        for (index, _) in tempBaseSubVCs.enumerated() {
            baseSubVC = tempBaseSubVCs[index]
            if baseSubVC.scrollView == scrollView {
                continue
            } else {
                if let tempScrollView = baseSubVC.scrollView {
                    var contentOffSet: CGPoint = tempScrollView.contentOffset
                    contentOffSet.y += -distanceY
                    tempScrollView.contentOffset = contentOffSet
                }
            }
        }
    }
}

extension SuspensionProVC: SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func pagingContentViewDidScroll() {
        let baseSubVC: BaseSubProVC = tempBaseSubVCs[pagingTitleView.index]
        if let tempScrollView = baseSubVC.scrollView {
            if (tempScrollView.contentSize.height) < UIScreen.main.bounds.size.width {
                tempScrollView.setContentOffset(CGPoint(x: 0, y: -pro_subScrollViewContentOffsetY), animated: false)
            }
        }
    }
    
}

extension SuspensionProVC {
    @objc func temp_btn_action() {
        print("temp_btn_action")
    }
}
