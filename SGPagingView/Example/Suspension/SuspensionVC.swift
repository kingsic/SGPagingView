//
//  SuspensionVC.swift
//  SGPagingView
//
//  Created by kingsic on 2021/10/20.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit

let headerViewHeight: CGFloat = 200

class SuspensionVC: UIViewController {
    
    lazy var tableView: BaseTableView = {
        let tempTableView = BaseTableView(frame: CGRect(origin: CGPoint(x: 0, y: UIScreen.statusBarHeight + 44), size: view.frame.size), style: .plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight))
        tempView.backgroundColor = .red
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .black
        let btn_width: CGFloat = 200
        btn.frame = CGRect(origin: CGPoint(x: (view.frame.size.width - btn_width) * 0.5, y: headerViewHeight - 100), size: CGSize(width: btn_width, height: btn_width * 0.25))
        btn.layer.cornerRadius = 10
        btn.setTitle("You know？I can click", for: .normal)
        btn.addTarget(self, action: #selector(btn_action), for: .touchUpInside)
        tempView.addSubview(btn)
        tempTableView.tableHeaderView = tempView
        return tempTableView
    }()
    
    @objc func btn_action() {
        print("btn_action")
    }
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let configure = SGPagingTitleViewConfigure()
        configure.color = .lightGray
        configure.selectedColor = .black
        configure.indicatorType = .Dynamic
        configure.indicatorColor = .orange
        configure.showBottomSeparator = false
        
        let x: CGFloat = 70
        let frame = CGRect.init(x: x, y: 0, width: view.frame.size.width - 2 * x, height: 44)
        let titles = ["精选", "微博", "相册"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.delegate = self
        return pagingTitle
    }()
    
    lazy var pagingContentView: SGPagingContentScrollView = {
        let vc1 = SubVC()
        vc1.view.backgroundColor = .orange
        let vc2 = SubTitleVC()
        vc2.view.backgroundColor = .purple
        let vc3 = SubVC()
        vc3.view.backgroundColor = .green
        let vcs = [vc1, vc2, vc3]
        
        let y: CGFloat = pagingTitleView.frame.maxY
        let tempRect: CGRect = CGRect.init(x: 0, y: y, width: view.frame.size.width, height: view.frame.size.height - y)
        let pagingContent = SGPagingContentScrollView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        pagingContent.isBounces = true
        return pagingContent
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(tableView)

        // 监听子视图发出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(subTableViewDidScroll), name: NSNotification.Name(NNSubScrollViewDidScroll), object: nil)
    }
    
    var tempSubScrollView: UIScrollView?
    
    deinit {
        print("SuspensionVC")
    }
}

extension SuspensionVC {
    @objc func subTableViewDidScroll(noti: Notification) {
        let scrollVeiw = noti.object as! UIScrollView
        tempSubScrollView = scrollVeiw
        if tableView.contentOffset.y < headerViewHeight {
            scrollVeiw.contentOffset = .zero
        }
    }
}

extension SuspensionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView == scrollView {
            if (tempSubScrollView != nil && (tempSubScrollView?.contentOffset.y)! > 0) || scrollView.contentOffset.y > headerViewHeight {
                tableView.contentOffset = CGPoint(x: 0, y: headerViewHeight)
            }
            
            let offSetY = scrollView.contentOffset.y
            if offSetY < headerViewHeight {
                NotificationCenter.default.post(name: NSNotification.Name(NNLesstMainHeaderViewHeight), object: nil)
            }
        }
    }
    
}

extension SuspensionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.contentView.addSubview(pagingTitleView)
        cell.contentView.addSubview(pagingContentView)
        cell.selectionStyle = .none
        return cell
    }
}

extension SuspensionVC: SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func pagingContentViewWillBeginDragging() {
        // 内容子视图开始滚动时，不让父视图 tableView 支持多手势
        NotificationCenter.default.post(name: NSNotification.Name(NNSubScrollViewLRScroll), object: false)
    }
    func pagingContentViewDidEndDecelerating() {
        // 内容子视图结束滚动时，让其父视图 tableView 支持多手势
        NotificationCenter.default.post(name: NSNotification.Name(NNSubScrollViewLRScroll), object: true)
    }
}
