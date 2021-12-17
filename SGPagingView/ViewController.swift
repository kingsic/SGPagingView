//
//  ViewController.swift
//  SGPagingView
//
//  Created by kingsic on 2021/12/10.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var dataSource = [
        ["固定样式一（回弹效果）": FixedOneVC.self],
        ["固定样式二（动画效果）": FixedTwoVC.self],
        ["滚动样式（指定下标值）": ScrollVC.self],
        ["富文本样式": AttributedVC.self],
        ["文字渐变效果": GradientEffectVC.self],
        ["文字缩放效果": ZoomVC.self],
        ["通知消息样式": BadgeVC.self],
        ["指示器固定样式（爱奇艺首页效果）": IFixedVC.self],
        ["指示器动态样式": IDynamicVC.self],
        ["指示器遮盖样式": CoverOneVC.self],
        ["百度网盘传输界面样式": CoverTwoVC.self],
        ["悬浮效果": SuspensionVC.self],
        ["悬浮效果Pro": SuspensionProVC.self]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.tableFooterView = UIView()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.text = dataSource[indexPath.row].keys.first
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = dataSource[indexPath.row].values.first
        if let tempVC = vc {
            navigationController?.pushViewController(tempVC.init(), animated: true)
        }
    }
}

