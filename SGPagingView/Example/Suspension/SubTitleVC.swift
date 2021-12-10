//
//  SubTitleVC.swift
//  SGPagingView
//
//  Created by kingsic on 2021/10/20.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit

class SubTitleVC: BaseSubVC {

    lazy var tableView: UITableView = {
        let tempTableView = UITableView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: view.frame.size.height - UIScreen.statusBarHeight - 44 - 44)), style: .plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        return tempTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
    }

}

extension SubTitleVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        subScrollViewDidScroll(scrollView)
    }
}

extension SubTitleVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "第 \(indexPath.row) 行"
        return cell
    }
}
