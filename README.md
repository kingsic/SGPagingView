
## 前沿

* 新闻、电商、视频等 app 经常会看到这种 SegmentedControl 布局样式

* 这里的 SegmentedControl 采取的是腾讯新闻、网易新闻、礼物说等布局样式

* 版本升级（根据标题内容自动适配 SGPageTitleView 是静止还是滚动）


### 为什么版本升级 ？为什么要用 SGPageView ？

* 1、这种控件大部分采用 UILabel 或 UIButton 进行的封装，您可以根据项目需求搜索选取很多第三方去使用，但大部分的这种控件都是静止或滚动状态，只有封装很好的才会有静止滚动同时存在

* 2、之前的版本就是把静止状态与滚动状态进行分开而写，使用者还要自己选取，总感觉很不方便；如若遇到像网易新网、虎牙直播这种用户可以根据自己的需求定制标题个数，这种控件就不能再选取使用了

* 3、 因此，为了让开发者更好的使用，进行了一次版本升级；升级之后的滚动条样式减少了许多，但解决了可根据标题内容设置滚动条的宽度以及根据标题内容自动选取是静止还是滚动样式（例：6P 是静止状态，5s 是滚动状态）


## 主要内容的介绍

* `普通样式一`<br>

* `普通样式二`<br>

* `标题按钮文字渐显效果`<br>

* `导航栏样式`<br>


## 效果图

![](https://github.com/kingsic/SGPageView/raw/master/Gif/sorgle.gif) 


## 代码介绍（详细使用请参考 Demo）

  * 将项目中 SGPageView 文件夹拖入工程

  * 导入 #import "SGPageView.h" 的头文件
  
* 创建滚动内容视图

```Objective-C
    /// 创建子控制器
    
    ChildVCOne *oneVC = [[ChildVCOne alloc] init];
    
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    
    ChildVCFour *fourVC = [[ChildVCFour alloc] init];
    
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC];
    
    /// pageContentView
    
    CGFloat contentViewHeight = self.view.frame.size.height - 108;
    
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    
    _pageContentView.delegatePageContentView = self;
    
    [self.view addSubview:_pageContentView];
```

* * 滚动内容视图代理方法

```Objective-C
- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];

}
```

* 创建滚动标题视图

```Objective-C
    /// 子标题数组
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺"];
    
    /// pageTitleView
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) delegate:self titleNames:titleArr];
    
    _pageTitleView.selectedIndex = 1;
    
    [self.view addSubview:_pageTitleView];
```

* * 滚动标题视图代理方法

```Objective-C
- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
}
```


## 版本介绍

* 2016-10-7 --> 初始版本的创建
* 2017-4-13 --> 版本升级（根据标题内容自动适配 SGPageTitleView 是静止还是滚动）
* 2017-4-18 --> 新增标题文字颜色属性以及指示器颜色属性
* 2017-4-20 --> 修复标题选中 Bug


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGPageView/issues) 或 kingsic@126.com 邮箱联系我

