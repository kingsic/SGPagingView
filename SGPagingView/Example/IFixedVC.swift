//
//  IFixedVC.swift
//  SGPagingView
//
//  Created by kingsic on 2020/12/29.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

class IFixedVC: UIViewController, SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    
    deinit {
        print("IFixedVC - deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.addSubview(pagingTitleView)
        view.addSubview(pagingContentView)
    }
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let configure = SGPagingTitleViewConfigure()
        configure.indicatorType = .Fixed
        configure.indicatorScrollStyle = .End
        configure.indicatorHeight = 3

        let frame = CGRect.init(x: 0, y: UIScreen.navBarHeight, width: UIScreen.width, height: 44)
        let titles = ["关注", "推荐", "热榜", "免费小说"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.delegate = self
        pagingTitle.backgroundColor = .white
        return pagingTitle
    }()
    
    lazy var pagingContentView: SGPagingContentScrollView = {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .purple
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .red
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .green
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .brown
        let vcs = [vc1, vc2, vc3, vc4]
        
        let y: CGFloat = pagingTitleView.frame.maxY
        let tempRect: CGRect = CGRect.init(x: 0, y: y, width: UIScreen.width, height: UIScreen.height - y)
        let pagingContent = SGPagingContentScrollView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        return pagingContent
    }()

    
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func pagingContentView(index: Int) {
        if index == 1 {
            pagingTitleView.backgroundColor = .black
            pagingTitleView.resetTitle(color: .white, selectedColor: .white)
            pagingTitleView.resetIndicator(color: .white)
        } else {
            pagingTitleView.backgroundColor = .white
            pagingTitleView.resetTitle(color: .black, selectedColor: .red)
            pagingTitleView.resetIndicator(color: .red)
        }
    }
    
}
