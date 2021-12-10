# SGPagingView


## 前言
* 2.0.0 版本起，升级为 Swift 编程语言
* [Objc 版本说明](https://github.com/kingsic/SGPagingView/blob/master/READMEOBJC.md)


## 结构图
![](https://github.com/kingsic/SGPagingView/blob/master/Pictures/SGPagingView.png)


## 效果图
![](https://github.com/kingsic/Kar98k/blob/master/SGPagingView/SGPagingView.gif)


##  Installation
* CocoaPods 导入 pod 'SGPagingView', '~> 2.0.0'


## 代码介绍
* 初始化方法
```
let configure = SGPagingTitleViewConfigure()
// PagingTitle
let pagingTitleView = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
pagingTitleView.delegate = self
view.addSubview(pagingTitleView)

// PagingContent
let pagingContentView = SGPagingContentScrollView(frame: frame, parentVC: self, childVCs: childVCs)
pagingContentView.delegate = self
view.addSubview(pagingContentView)
```

*  SGPagingTitleView 代理方法
```
func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
    pagingContentView.setPagingContentView(index: index)
}
```

*  SGPagingContentView 代理方法
```
func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
    pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
}
```


## Requirements
* iOS 10.0 +
* Swift 5.0 +


## Concluding remarks
* 如有问题 [issues](https://github.com/kingsic/SGPagingView/issues) 或加QQ群：825339547

