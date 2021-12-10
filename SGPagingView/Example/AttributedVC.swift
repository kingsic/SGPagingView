//
//  SystemVC.swift
//  SGPagingView
//
//  Created by kingsic on 2020/12/29.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

class AttributedVC: UIViewController, SGPagingTitleViewDelegate {
    
    deinit {
        print("AttributedVC - deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .green
        
        HY()
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
        rightBtn.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(rightBtn)
        
        let rightBtnText = "订阅\n  520"
        let attriStr = NSMutableAttributedString(string: rightBtnText)
        let dict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
        let range = NSMakeRange(0, 2)
        attriStr.addAttributes(dict, range: range)
        rightBtn.setAttributedTitle(attriStr, for: .normal)
    }

}
