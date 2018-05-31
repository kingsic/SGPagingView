
# SGPagingView


## 目录
* [效果图](#效果图)

* [主要内容的介绍](#主要内容的介绍)

* [SGPagingView 集成](#SGPagingView-集成)

* [代码介绍](#代码介绍)

* [问题及解决方案](#问题及解决方案)

* [版本介绍](#版本介绍)

* [Concluding remarks](#Concluding-remarks)


## 效果图
![](https://github.com/kingsic/SGPagingView/raw/master/Gif/sorgle.gif)       ![](https://github.com/kingsic/SGPagingView/raw/master/Gif/sorgle2.gif)


## 主要内容的介绍
* `系统样式`<br>

* `图片样式`<br>

* `指示器遮盖样式`<br>

* `指示器固定样式`<br>

* `指示器动态样式`<br>

* `指示器下划线样式`<br>

* `指示器长度自定义`<br>

* `标题文字渐显效果`<br>

* `标题文字缩放效果`<br>

* `多种指示器滚动样式`<br>


## SGPagingView 集成
* 1、CocoaPods 导入 pod 'SGPagingView', '~> 1.4.2'
* 2、下载、拖拽 “SGPagingView” 文件夹到工程中


## 代码介绍
#### SGPagingView 的使用（详细使用, 请参考 Demo）
``` 
    /// pageTitleView 
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:frame delegate:self titleNames:titleNames configure:configure];
    [self.view addSubview:_pageTitleView];
    
    
    /// pageContentView
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:frame parentVC:self childVCs:childVCs];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
```

* 滚动内容视图的代理方法
```
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}
```

* 滚动标题视图的代理方法
```
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententScrollViewCurrentIndex:selectedIndex];
}
```


#### SGPagingView 的介绍
|主要属性、方法|描述|
|----|-----|
|**selectedIndex**|选中标题下标|
|**resetSelectedIndex**|重置标题下标|
|**titleFont**|标题文字字号大小，默认 15 号字体|
|**titleColor**|普通状态下标题按钮文字的颜色，默认为黑色|
|**titleSelectedColor**|选中状态下标题按钮文字的颜色，默认为红色|
|**indicatorColor**|指示器颜色，默认为红色|
|**indicatorStyle**|指示器样式，默认为下划线样式；下划线、遮盖样式|
|**indicatorHeight**|指示器高度；下划线样式下默认为 2.f，遮盖样式下，默认为标题文字的高度，若大于 SGPageTitleView，则高度为 SGPageTitleView 高度，下划线样式未做处理|
|**indicatorAdditionalWidth**|指示器遮盖、下划线样式下额外增加的宽度，默认为 0.0f；介于标题文字宽度与按钮宽度之间|
|**spacingBetweenButtons**|按钮之间的间距，默认 20.f|
|**indicatorStyle**|指示器样式;SGIndicatorStyleDefault、SGIndicatorStyleCover、SGIndicatorStyleFixed、SGIndicatorStyleDynamic（仅在 SGIndicatorScrollStyleDefault 样式下支持）|
|**indicatorCornerRadius**|圆角属性，默认为 0.f；若圆角大于 1/2 指示器高度，则圆角大小为指示器高度的 1/2|
|**indicatorScrollStyle**|指示器滚动样式|
|**resetTitle:forIndex:**|根据标题下标重置标题文字|
|**setAttributedTitle:selectedAttributedTitle:forIndex:**|根据标题下标设置标题的 attributedTitle 属性|
|**setImages:selectedImages:imagePositionType:spacing:**|设置图片及样式|


## 问题及解决方案
#### 1、CocoaPods 安装 SGPagingView 时，遇到的问题及解决方案
* 若在使用 CocoaPods 安装 SGPagingView 时，出现 [!] Unable to find a specification for SGPagingView 提示时，打开终端先输入 pod repo remove master；执行完毕后再输入 pod setup 即可 (可能会等待一段时间)
***

#### 2、关于父子控制器的说明（SGPageContentView 与 SGPageContentScrollView）
###### 参考链接
* [iOS 父子控制器添加与移除](https://www.aliyun.com/jiaocheng/352895.html)
* [iOS 进阶之正确添加子控制器的方法](https://www.jianshu.com/p/7c4aeb2c6655)
* [添加子视图控制器时，子视图控制器的 viewWillAppear 方法不调用](https://blog.csdn.net/u012907783/article/details/78972227)
* [addChildViewController 与 viewWillAppear、viewDidAppear 关系说明](https://blog.csdn.net/zhaoxy_thu/article/details/50826190)
***

#### 3、关于侧滑返回手势（请参考 DefaultVCPopGesture 类以及点击子控制器对下一界面所做的处理）
###### 1、如果是系统默认返回 item ；只需实现 SGPageContentScrollView 的 pageContentScrollView:offsetX:代理方法或 SGPageContentCollectionView 的 pageContentCollectionView:offsetX:代理方法，并在此方法实现以下代码即可，如：
```
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView offsetX:(CGFloat)offsetX {
    if (offsetX == 0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
```

###### 2、如果是自定义返回 item 
a. 设置代理：self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

b. 遵循协议：UINavigationControllerDelegate

c. 实现代理方法：
```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
```
d. 实现 SGPageContentScrollView 的 pageContentScrollView:offsetX:代理方法或 SGPageContentCollectionView 的 pageContentCollectionView:offsetX:代理方法；实现代码如 1、

###### 3、issues [关于返回手势](https://github.com/kingsic/SGPagingView/issues/25) 已有开发者提供了解决方案，可供参看
***


## 版本介绍

* 2016-10-07 ：初始版本的创建

* 2017-04-13 ：版本升级（根据标题内容自动识别 SGPageTitleView 是静止还是滚动）

* 2017-06-01 ：v1.1.0 解决标题中既有中文又有英文存在的指示器滚动错乱问题以及性能优化

* 2017-06-15 ：v1.1.5 新增新浪微博模块以及代码的优化

* 2017-07-21 ：v1.1.7 新增 SGPageContentScrollView 类以及加入 pods 管理

* 2017-10-17 ：v1.3.0 版本升级（新增 SGPageTitleViewConfigure 类，提供更多的属性设置以及支持指示器遮盖样式）

* 2017-10-28 ：v1.3.2 SGPageTitleViewConfigure 类新增指示器遮盖样式下的边框宽度及边框颜色属性

* 2017-11-01 ：适配 iOS 11（如果你是 Xcode 8 的运行环境，请在 releases 中下载 v1.3.2 的代码进行运行）

* 2017-11-28 ：v1.3.3 SGPageContentView 与 SGPageContentScrollView 新增代理方法，用来处理侧滑返回手势

* 2017-12-07 ：v1.3.4 新增指示器固定样式

* 2017-12-28 ：v1.3.5 新增指示器动态样式（仅在 SGIndicatorScrollStyleDefault 样式下支持）

* 2018-01-30 ：v1.3.6 解决 SGPageTitleView 标题点击与 SGPageContentView 滚动问题

* 2018-05-08 ：v1.3.7 修复 v1.3.6 选中标题重复点击恢复默认状态以及 SGPageTitleViewConfigure 新增配置属性

* 2018-05-09 ：v1.4.0 版本升级（SGPageTitleView.h 部分属性调整到 SGPageTitleViewConfigure.h 以及对 SGPageContentView 进行重构）

* 2018-06-01 ：v1.4.2 新增标题间分割线属性、根据下标设置标题的 attributedTitle 方法以及设置标题图片位置样式方法


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGPagingView/issues) 或 kingsic@126.com 邮箱联系我
