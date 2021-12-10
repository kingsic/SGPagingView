//
//  FixedOneVC.swift
//  SGPagingView
//
//  Created by kingsic on 2020/12/29.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

class FixedOneVC: UIViewController, SGPagingTitleViewDelegate, SGPagingContentViewDelegate {

    deinit {
        print("FixedOneVC - deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        
        addPagingView()
    }
    
    var pagingTitleView: SGPagingTitleView!
    var pagingContentView: SGPagingContentScrollView!

    func addPagingView() {
        let configure = SGPagingTitleViewConfigure()
        configure.equivalence = false
        configure.additionalWidth = 37
        configure.selectedFont = .systemFont(ofSize: 17)
        
        let frame = CGRect.init(x: 0, y: UIScreen.navBarHeight, width: UIScreen
                                    .width, height: 44)
        let titles = ["关注", "推荐", "热榜", "免费小说"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.delegate = self
        view.addSubview(pagingTitle)
        pagingTitleView = pagingTitle
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .orange
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .purple
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .green
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .brown
        let vcs = [vc1, vc2, vc3, vc4]
        
        let y: CGFloat = pagingTitle.frame.maxY
        let tempRect: CGRect = CGRect.init(x: 0, y: y, width: UIScreen.width, height: UIScreen.height - y)
        let pagingContent = SGPagingContentScrollView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        pagingContent.isBounces = true
        view.addSubview(pagingContent)
        pagingContentView = pagingContent
    }

    
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
}
