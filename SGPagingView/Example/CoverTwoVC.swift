//
//  CoverTwoVC.swift
//  SGPagingView
//
//  Created by kingsic on 2020/12/29.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

class CoverTwoVC: UIViewController , SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    
    deinit {
        print("CoverTwoVC - deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(pagingTitleView)
        view.addSubview(pagingContentView)
    }
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let configure = SGPagingTitleViewConfigure()
        configure.showBottomSeparator = false
        configure.indicatorAnimationTime = 0.05
        configure.indicatorType = .Fixed // 由于 Cover 样式是随标题内容而变化的，而这里的指示器长度是固定的，所以使用 Fixed 样式再配置相关属性
        configure.indicatorHeight = 38
        configure.indicatorFixedWidth = (UIScreen.width - 60)/3 - 6
        configure.indicatorCornerRadius = 5
        configure.indicatorColor = .white
        configure.indicatorToBottomDistance = 3;
        configure.color = .lightGray
        configure.selectedColor = .black
        
        let frame = CGRect.init(x: 30, y: UIScreen.navBarHeight, width: UIScreen.width - 60, height: 44)
        let titles = ["下载列表", "上传列表", "保存至手机"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.layer.cornerRadius = 5
        pagingTitle.backgroundColor = UIColor.black.withAlphaComponent(0.07)
        pagingTitle.delegate = self
        return pagingTitle
    }()
    
    lazy var pagingContentView: SGPagingContentCollectionView = {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .orange
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .purple
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .green
        let vcs = [vc1, vc2, vc3]
        
        let y: CGFloat = pagingTitleView.frame.maxY
        let tempRect: CGRect = CGRect.init(x: 0, y: y, width: UIScreen.width, height: UIScreen.height - y)
        let pagingContent = SGPagingContentCollectionView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        return pagingContent
    }()

    
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }

}
