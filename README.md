
# SGPagingView


## 目录

* [结构图](#结构图)

* [效果图](#效果图)

* [主要内容的介绍](#主要内容的介绍)

* [Installation](#Installation)

* [代码介绍](#代码介绍)

* [问题及解决方案](#问题及解决方案)

* [版本介绍](#版本介绍)

* [Concluding remarks](#Concluding_remarks)


## 结构图
![](https://github.com/kingsic/SGPagingView/raw/master/Picture/SGPagingView.png)
``` 
SGPageTitleViewConfigure（SGPageTitleView 初始化配置信息）

SGPageTitleView（用于与 SGPageContent 联动）

SGPageContentScrollView（内部由 UIScrollView 实现）

SGPageContentCollectionView（内部由 UICollectionView 实现）
``` 


## 效果图
![](https://github.com/kingsic/SGPagingView/raw/master/Picture/sorgle.gif)


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


## Installation
* 1、CocoaPods 导入 pod 'SGPagingView', '~> 1.5.3'
* 2、下载、拖拽 “SGPagingView” 文件夹到工程中


## 代码介绍
#### SGPagingView 的使用（详细使用, 请参考 Demo）
``` 
    /// pageTitleViewConfigure
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    /// pageTitleView
    SGPageTitleView *pageTitleView = [SGPageTitleView pageTitleViewWithFrame:frame delegate:self titleNames:titleNames configure:configure];
    [self.view addSubview:pageTitleView];
    
    /// pageContent
    SGPageContentScrollView *pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:frame parentVC:self childVCs:childVCs];
    pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:pageContentScrollView];
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
    [self.pageContentScrollView setPageCententScrollViewCurrentIndex:selectedIndex];
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
|**titleAdditionalWidth**|标题额外增加的宽度，默认为 20.0f|
|**indicatorStyle**|指示器样式;SGIndicatorStyleDefault、SGIndicatorStyleCover、SGIndicatorStyleFixed、SGIndicatorStyleDynamic（仅在 SGIndicatorScrollStyleDefault 样式下支持）|
|**indicatorCornerRadius**|圆角属性，默认为 0.f；若圆角大于 1/2 指示器高度，则圆角大小为指示器高度的 1/2|
|**indicatorScrollStyle**|指示器滚动样式|
|**resetTitle:forIndex:**|根据标题下标值重置标题文字|
|**setAttributedTitle:selectedAttributedTitle:forIndex:**|根据标题下标值设置标题的 attributedTitle 属性|
|**setImages:selectedImages:imagePositionType:spacing:**|设置图片及样式|


## 问题及解决方案
### 一、CocoaPods 安装 SGPagingView 时，遇到的问题及解决方案
* 若在使用 CocoaPods 安装 SGPagingView 时，出现 [!] Unable to find a specification for SGPagingView 提示时，打开终端先输入 pod repo remove master；执行完毕后再输入 pod setup 即可 (可能会等待一段时间)
***

### 二、关于父子控制器的说明（SGPageContentScrollView 与 SGPageContentCollectionView）
###### 参考链接
* [添加子视图控制器时，子视图控制器的 viewWillAppear 方法不调用](https://blog.csdn.net/u012907783/article/details/78972227)
* [addChildViewController 与 viewWillAppear、viewDidAppear 关系说明](https://blog.csdn.net/zhaoxy_thu/article/details/50826190)
***

### 三、关于侧滑返回手势（请参考 DefaultVCPopGesture 类以及点击子控制器对下一界面所做的处理）
#### 1、如果是系统默认返回 item ；只需实现 SGPageContentScrollView 的 pageContentScrollView:offsetX:代理方法或 SGPageContentCollectionView 的 pageContentCollectionView:offsetX:代理方法，并在此方法实现以下代码即可，如：
```
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    if (index == 0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
```

#### 2、如果是自定义返回 item 
a. 需单独在 .h 文件中导入 #import "SGPagingViewPopGestureVC.h"，且控制器继承 SGPagingViewPopGestureVC;

b. 实现 SGPageContentScrollView 的 pageContentScrollView:index:代理方法或 SGPageContentCollectionView 的 pageContentCollectionView:index:代理方法
```
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    if (index == 0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
```

##### 温馨提示一：由于 index != 0 时 self.navigationController.interactivePopGestureRecognizer.enabled = NO; 所以 push 到下一控制器需在 viewDidLoad 中设置为 YES；

##### 温馨提示二：导航栏包装自定义返回 item 使用 SGPagingView 也会导致侧滑返回失效解决方案同（2、如果是自定义返回 item）；如果你工程中某个控制器使用自定义返回 item 解决方案同（2、如果是自定义返回 item）；这里只是提供一种解决方案，仅供参考。如果你有更好的解决方案欢迎联我

##### 温馨提示三：自定义返回 item 导致侧滑返回手势失效[参考链接](https://www.jianshu.com/p/33ce1340a543)

#### 3、issues [关于返回手势](https://github.com/kingsic/SGPagingView/issues/25) 已有开发者提供了解决方案，仅供参看
***


## 版本介绍

* 2016-10-07 ：初始版本的创建

* 2017-04-13 ：版本升级（根据标题内容自动识别 SGPageTitleView 是静止还是滚动样式）

* 2017-07-21 ：v1.1.7 加入 CocoaPods 管理以及新增 SGPageContentScrollView 类

* 2017-10-17 ：v1.3.0 版本升级（新增 SGPageTitleViewConfigure 类并提供更多属性设置以及支持指示器遮盖样式）

* 2017-11-28 ：v1.3.3 SGPageContentView 与 SGPageContentScrollView 新增代理方法，用来处理侧滑返回手势

* 2018-05-08 ：v1.3.7 修复 v1.3.6 选中标题重复点击恢复默认状态以及 SGPageTitleViewConfigure 新增配置属性

* 2018-05-09 ：v1.4.0 版本升级（SGPageTitleView.h 中的部分属性调整到 SGPageTitleViewConfigure.h）

* 2018-06-01 ：v1.4.2 新增标题间分割线属性、根据下标设置标题的 attributedTitle 方法以及设置标题图片位置样式方法

* 2018-07-01 ：v1.4.3 优化标题首次点击居中问题以及修复标题文字缩放切换到后台再返回时存在的标题字号问题

* 2018-07-09 ：v1.5.0 版本升级（具体相关信息请查看 [releases](https://github.com/kingsic/SGPagingView/releases) 中版本介绍）

* 2018-08-28 ：v1.5.2 SGPageContentScrollView 内部代码优化处理（感谢 [petyou](https://github.com/petyou) 提供的优化方案）

* 2018-09-01 ：v1.5.3 SGPageTitleView 内部代码优化以及新增 SGPagingViewPopGestureVC 用于解决侧滑返回手势


## Concluding remarks

* iOS 技术交流群：429899752

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGPagingView/issues) 或 kingsic@126.com 邮箱联系我
