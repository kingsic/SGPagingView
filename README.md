
## 前沿

* 新闻、电商、视频等 app 经常会看到这种 SegmentedControl 布局样式

* 这里的 SegmentedControl 采取的是腾讯新闻、网易新闻、礼物说、淘宝(微淘界面)、京东(发现界面)等布局样式

* 轻轻的我走了，正如我轻轻的来，我动一动鼠标，就是为了给你 Star (喜欢的朋友别忘了哦 😊 😊）

* 代码后期不断更新维护中（会增加类似贝贝、腾讯视频动态改变指示器的宽度以及位置）


## 主要内容的介绍

* `静止状态下标题按钮`<br>

* `滚动状态下标题按钮`<br>

* `静态状态下带有图片的标题按钮`<br>

* `滚动状态下带有图片的标题按钮`<br>

* `指示器样式一`<br>

* `指示器样式二`<br>

* `指示器样式三`<br>

* `标题按钮文字渐显效果`<br>

* `标题按钮文字缩放效果`<br>

* `导航栏样式`<br>


## 效果图

![](https://github.com/kingsic/SGSegmentedControl/raw/master/Gif/sorgle.gif) 


## 代码介绍

### * `SGSegmentedControl的使用`<br>

  * 将项目中 SGSegmentedControl 文件夹导入工程

  * 导入 #import "SGSegmentedControl.h" 头文件

  * 对象方法创建
```Objective-C
普通状态下的对象方法创建

/** 对象方法创建 SGSegmentedControlStatic （静止状态）*/

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle;

/** 对象方法创建 SGSegmentedControlDefault（滚动状态） */

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText;
```

```Objective-C
带有图片的对象方法创建

/** 对象方法创建，带有图片的 SGSegmentedControlStatic */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;

/** 对象方法创建，带有图片的 SGSegmentedControlDefault */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;
```

  * 类方法创建
```Objective-C
普通状态下的类方法创建

/** 类方法创建 SGSegmentedControlStatic */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle;

/** 类方法创建 SGSegmentedControlDefault */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText;
```

```Objective-C
带有图片的类方法创建

/** 类方法创建，带有图片的 SGSegmentedControlStatic */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;

/** 类方法创建，带有图片的 SGSegmentedControlDefault */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;
```

  * 属性设置
 
   * @property (nonatomic, strong) UIColor *titleColorStateNormal; // 标题文字颜色(默认为黑色)

   * @property (nonatomic, strong) UIColor *titleColorStateSelected; // 选中时标题文字颜色(默认为红色) 

   * @property (nonatomic, strong) UIColor *indicatorColor;  // 指示器的颜色(默认为红色) 

   * @property (nonatomic, assign) BOOL showsBottomScrollIndicator; // 是否显示底部滚动指示器(默认为YES, 显示)

   * @property (nonatomic, assign) segmentedControlIndicatorType segmentedControlIndicatorType;  // 枚举属性, 指示器样式(默认为底部样式)

   * -(void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView; // 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现）
   
   * @property (nonatomic, assign) BOOL titleColorGradualChange; // 标题文字渐变效果(默认为NO), 与-(void)selectedTitleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView方法，一起才会生效 (附言：先设置属性，再实现方法)
   
   * @property (nonatomic, assign) BOOL titleFondGradualChange; // 标题文字缩放效果(默认为NO), 与-(void)selectedTitleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView方法，一起才会生效 (附言：先设置属性，再实现方法)
   
   * -(void)selectedTitleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView; // 文字渐显、缩放效果的实现（给外界 scrollViewDidScroll 提供的方法 -> 可供选择） (附言：先设置属性，再实现方法) 
    
   * 遵循 SGSegmentedControlDelegate 协议的 delegate_SG 方法
```Objective-C
/** SGSegmentedControlStaticDelegate */

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index;

/** SGSegmentedControlDefaultDelegate */

- (void)SGSegmentedControlDefault:(SGSegmentedControlDefault *)segmentedControlDefault didSelectTitleAtIndex:(NSInteger)index;
```

* 提示信息文字，根据内容自动调节
```Objective-C
- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(nullable NSDictionary *)attributes context:(nullable NSStringDrawingContext *)context;
```


## 版本介绍

* 2016. 10. 7  --> 初始版本的创建
* 2016. 11. 10 --> 全面升级（为了方便理解和使用，将静态状态下的 SGSegmentControl 与滚动状态下的 SGSegmentControl 拆分管理）
* 2016. 11. 11 --> 新增指示器样式三（UIImageView样式的指示器）；解决 scrollViewDidScroll 的 Bug 问题
* 2016. 11. 17 --> 新增判断是否开启字体缩放功能
* 2016. 11. 18 --> 新增导航栏样式


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGSegmentedControl/issues) 或 kingsic@126.com 邮箱联系我

