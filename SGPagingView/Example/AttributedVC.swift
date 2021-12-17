//
//  SystemVC.swift
//  SGPagingView
//
//  Created by kingsic on 2020/12/29.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

class AttributedVC: UIViewController {
    
    deinit {
        print("AttributedVC - deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .green
        
        HY()
        
        addPagingView()
    }
    
    func HY() {
        // 提示语
        let lab: UILabel = UILabel()
        lab.frame = CGRect.init(x: 0, y: 110, width: UIScreen.width, height: 50)
        lab.text = "虎牙样式"
        lab.textAlignment = .center
        lab.font = .boldSystemFont(ofSize: 22)
        view.addSubview(lab)

        let configure = SGPagingTitleViewConfigure()
        configure.showBottomSeparator = false
        configure.font = .systemFont(ofSize: 13)

        let pty = lab.frame.maxY
        let ptw = view.frame.size.width * 4 / 5
        let pth: CGFloat = 44

        let frame = CGRect.init(x: 0, y: pty, width: ptw, height: pth)
        let titles = ["聊天", "主播", "排行", "贵宾"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        view.addSubview(pagingTitle)
        
        // setAttributedTitle
        let ptStr = "贵宾(12138)"
        let ptAttriStr = NSMutableAttributedString(string: ptStr)
        let ptDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let ptRange = NSMakeRange(2, ptStr.count - 2)
        ptAttriStr.addAttributes(ptDict, range: ptRange)
        
        let ptSAttriStr = NSMutableAttributedString(string: ptStr)
        let ptSDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.red]
        let ptSSDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.red]
        let ptSRange = NSMakeRange(0, 2)
        ptSAttriStr.addAttributes(ptSSDict, range: ptRange)
        ptSAttriStr.addAttributes(ptSDict, range: ptSRange)
        pagingTitle.setTitle(attributed: ptAttriStr, selectedAttributed: ptSAttriStr, index: 3)

        
        // rightBtn
        let rightBtn: UIButton = UIButton(type: .custom)
        rightBtn.frame = CGRect.init(x: pagingTitle.frame.maxX, y: pty, width: view.frame.size.width / 5, height: pth)
        rightBtn.backgroundColor = .orange
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.titleLabel!.lineBreakMode = .byWordWrapping
        rightBtn.titleLabel?.textAlignment = .center
        rightBtn.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(rightBtn)
        
        let rightBtnText = "订阅\n520"
        let attriStr = NSMutableAttributedString(string: rightBtnText)
        let dict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
        let range = NSMakeRange(0, 2)
        attriStr.addAttributes(dict, range: range)
        rightBtn.setAttributedTitle(attriStr, for: .normal)
    }

    
    func addPagingView() {
        view.addSubview(pagingTitleView)
        view.addSubview(pagingContentView)
    }
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let configure = SGPagingTitleViewConfigure()
        configure.indicatorLocation = .Top
        configure.indicatorHeight = 5
        
        let frame = CGRect.init(x: 0, y: 220, width: UIScreen.width, height: 44)
        let titles = ["聊天", "主播", "排行", "贵宾"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.delegate = self

        let text = "订阅\n520"
        let attriStr = NSMutableAttributedString(string: text)
        let dict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.black]
        let range = NSMakeRange(0, 2)
        attriStr.addAttributes(dict, range: range)
        let dict2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]
        let range2 = NSMakeRange(text.count - 3, 3)
        attriStr.addAttributes(dict2, range: range2)
        
        let selectedAttriStr = NSMutableAttributedString(string: text)
        let selectedDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.red]
        let selectedRange = NSMakeRange(0, 2)
        selectedAttriStr.addAttributes(selectedDict, range: selectedRange)
        let selectedDict2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.red]
        let selectedRange2 = NSMakeRange(text.count - 3, 3)
        selectedAttriStr.addAttributes(selectedDict2, range: selectedRange2)
        
        pagingTitle.setTitle(attributed: attriStr, selectedAttributed: selectedAttriStr, index: 3)
        
        let imageUrl = "https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"
        pagingTitle.setBackgroundImage(name: imageUrl, selectedName: nil, index: 1)
        return pagingTitle
    }()
    
    lazy var pagingContentView: SGPagingContentScrollView = {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .orange
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .purple
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .brown
        let vcs = [vc1, vc2, vc3, vc4]
        
        let y: CGFloat = pagingTitleView.frame.maxY + 20
        let tempRect: CGRect = CGRect.init(x: 0, y: y, width: UIScreen.width, height: 200)
        let pagingContent = SGPagingContentScrollView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        pagingContent.isAnimated = true
        pagingContent.isBounces = true
        return pagingContent
    }()
}

extension AttributedVC: SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
}
