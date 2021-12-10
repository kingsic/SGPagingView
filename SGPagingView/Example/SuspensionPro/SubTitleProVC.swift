//
//  SubTitleProVC.swift
//  SGPagingView
//
//  Created by kingsic on 2021/10/20.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit
//import MJRefresh

class SubTitleProVC: BaseSubProVC {

    lazy var tableView: UITableView = {
        let tempTableView = UITableView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: view.frame.size.height)), style: .plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tempTableView.contentInset = UIEdgeInsets(top: pro_subScrollViewContentOffsetY, left: 0, bottom: 0, right: 0)
        return tempTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never;
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
//        addRefresh()
    }

}

extension SubTitleProVC {
//    func addRefresh() {
//        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(header_refresh))
//    }
//    @objc func header_refresh() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(2)) { [self] in
//            tableView.mj_header?.endRefreshing()
//        }
//    }
}

extension SubTitleProVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        subScrollViewDidScroll(scrollView)
    }
}

extension SubTitleProVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "第 \(indexPath.row) 行"
        return cell
    }
}
