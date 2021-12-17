//
//  SGPagingContentCollectionView.swift
//  SGPagingView
//
//  Created by kingsic on 2020/12/23.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

public class SGPagingContentCollectionView: SGPagingContentView {
    @objc public init(frame: CGRect, parentVC: UIViewController, childVCs: [UIViewController]) {
        super.init(frame: frame)
        
        parentViewController = parentVC
        childViewControllers = childVCs
        
        addSubview(collectionView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var isScrollEnabled: Bool {
        willSet {
            collectionView.isScrollEnabled = newValue
        }
    }
    
    public override var isBounces: Bool {
        willSet {
            collectionView.bounces = newValue
        }
    }
    
    public override func setPagingContentView(index: Int) {
        setPagingContentCollectionView(index: index)
    }
    
    // MARK: 内部属性
    private weak var parentViewController: UIViewController?
    private var childViewControllers: [UIViewController] = []
    private var startOffsetX: CGFloat = 0.0
    private var previousChildVC: UIViewController?
    private var previousChildVCIndex: Int = -1
    private var scroll: Bool = false

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let tempCollectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        tempCollectionView.showsVerticalScrollIndicator = false
        tempCollectionView.showsHorizontalScrollIndicator = false
        tempCollectionView.isPagingEnabled = true
        tempCollectionView.bounces = isBounces
        tempCollectionView.backgroundColor = .white
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        return tempCollectionView
    }()
}

extension SGPagingContentCollectionView {
    func setPagingContentCollectionView(index: Int) {
        let offsetX = CGFloat(index) * collectionView.frame.size.width
        startOffsetX = offsetX
        if previousChildVCIndex != index {
            collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: isAnimated)
        }
        previousChildVCIndex = index
        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentView(index:)))) != nil) {
            delegate?.pagingContentView?(index: index)
        }
    }
}

private let cellID = "cellID"

extension SGPagingContentCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.contentView.subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
        let childVC = childViewControllers[indexPath.item]
        parentViewController?.addChild(childVC)
        cell.contentView.addSubview(childVC.view)
        childVC.view.frame = cell.contentView.frame
        childVC.didMove(toParent: parentViewController)
        return cell
    }
}

extension SGPagingContentCollectionView: UICollectionViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        scroll = true
        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentViewWillBeginDragging))) != nil) {
            delegate?.pagingContentViewWillBeginDragging?()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scroll = false
        let offsetX = scrollView.contentOffset.x
        previousChildVCIndex = Int(offsetX / scrollView.frame.size.width)
        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentView(index:)))) != nil) {
            delegate?.pagingContentView?(index: previousChildVCIndex)
        }
        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentViewDidEndDecelerating))) != nil) {
            delegate?.pagingContentViewDidEndDecelerating?()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isAnimated == true && scroll == false {
            return
        }
        // 1、定义获取需要的数据
        var progress: CGFloat = 0.0
        var currentIndex: Int = 0
        var targetIndex: Int = 0

        // 2、判断是左滑还是右滑
        let currentOffsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewW: CGFloat = scrollView.bounds.size.width
        if currentOffsetX > startOffsetX { // 左滑
            if currentOffsetX > CGFloat(childViewControllers.count - 1) *  scrollViewW && isBounces == true {
                return
            }
            // 1、计算 progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
            // 2、计算 currentIndex
            currentIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 targetIndex
            targetIndex = currentIndex + 1;
            if targetIndex >= childViewControllers.count {
                progress = 1;
                targetIndex = currentIndex;
            }
            // 4、如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1;
                targetIndex = currentIndex;
            }
        } else { // 右滑
            if currentOffsetX < 0 && isBounces == true {
                return
            }
            // 1、计算 progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
            // 2、计算 targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 currentIndex
            currentIndex = targetIndex + 1;
            if currentIndex >= childViewControllers.count {
                currentIndex = childViewControllers.count - 1;
            }
        }
   
        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentView(contentView:progress:currentIndex:targetIndex:)))) != nil) {
            delegate?.pagingContentView?(contentView: self, progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
        }
    }
}
