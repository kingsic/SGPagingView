//
//  ViewController.swift
//  SGPagingView
//
//  Created by kingsic on 2021/12/10.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource = ["固定样式一（回弹效果）", "固定样式二（动画效果）", "滚动样式（指定下标值）", "富文本样式", "badge 样式", "文字渐变效果", "文字缩放效果", "指示器固定样式（爱奇艺效果）", "指示器动态样式", "指示器遮盖样式", "百度网盘传输界面样式", "悬浮效果", "悬浮效果Pro"]

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
        cell.textLabel?.text = dataSource[indexPath.row];
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = FixedOneVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = FixedTwoVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = ScrollVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = AttributedVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = BadgeVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            let vc = GradientEffectVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            let vc = ZoomVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            let vc = IFixedVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 8 {
            let vc = IDynamicVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            let vc = CoverOneVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10 {
            let vc = CoverTwoVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 11 {
            let vc = SuspensionVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 12 {
            let vc = SuspensionProVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

