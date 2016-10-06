
## 前沿

* 新闻、电商、视频等 app 经常会看到这种 SegmentedControl 布局样式

* 这里的 SegmentedControl 采取的是腾讯新闻、网易新闻、礼物说、淘宝(微淘界面)、京东(发现界面)等布局样式

* 轻轻的我走了，正如我轻轻的来，我动一动鼠标，就是为了给你 Star (喜欢的朋友别忘了哦 😊 😊）

* 代码后期不断更新维护中（会增加类似贝贝、腾讯视屏动态改变指示器的宽度）


## 主要内容的介绍

* `静止状态下标题按钮`<br>

* `滚动状态下标题按钮`<br>

* `静态状态下带有图片的标题按钮`<br>

* `滚动状态下带有图片的标题按钮`<br>

* `指示器样式`<br>

* `指示器样式二`<br>

* `标题按钮文字渐显效果`<br>

* `标题按钮文字缩放效果`<br>

* `导航栏标题按钮的创建`<br>


## 效果图

![](https://github.com/kingsic/SGSegmentedControl/raw/master/Gif/sorgle.gif) 


## 代码介绍

### * `SGSegmentedControl的使用`<br>

  * 将项目中SGSegmentedControl文件夹拖入工程

  * 导入#import "SGSegmentedControl.h"头文件

  * 对象方法创建
```Objective-C
普通状态下的对象方法创建

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType titleArr:(NSArray *)titleArr;
```

```Objective-C
带有图片的对象方法创建

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr titleArr:(NSArray *)titleArr;
```

  * 类方法创建
```Objective-C
普通状态下的类方法创建

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType titleArr:(NSArray *)titleArr;
```

```Objective-C
带有图片的类方法创建

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr titleArr:(NSArray *)titleArr;
```

  * 属性设置

   * @property (nonatomic, assign) SGSegmentedControlType segmentedControlType; // 枚举属性, 默认为滚动风格
 
   * @property (nonatomic, strong) UIColor *titleColorStateNormal; // 标题文字颜色(默认为黑色)

   * @property (nonatomic, strong) UIColor *titleColorStateSelected; // 选中时标题文字颜色(默认为红色) 

   * @property (nonatomic, strong) UIColor *indicatorColor;  // 指示器的颜色(默认为红色) 

   * @property (nonatomic, assign) BOOL showsBottomScrollIndicator; // 是否显示底部滚动指示器(默认为YES, 显示)

   * @property (nonatomic, assign) SGSegmentedControlIndicatorType segmentedControlIndicatorType;  // 枚举属性, 指示器样式(默认为底部样式)

   * 遵循SGSegmentedControlDelegate协议的delegate_SG方法
```Objective-C
- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index;
```
   * - (void)titleBtnSelectedWithScrollView:(UIScrollView *)scrollView; // 标题选中颜色改变以及指示器位置变化
   
   * @property (nonatomic, assign) BOOL titleColorGradualChange; // 标题文字渐变效果(默认为NO), 与titleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效
   
   * @property (nonatomic, assign) BOOL titleFondGradualChange; // 标题文字缩放效果(默认为NO), 与titleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效
   
   * - (void)titleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView; // 给外界scrollViewDidScroll方法提供文字渐显效果

* 提示信息文字，根据内容自动调节
```Objective-C
- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(nullable NSDictionary *)attributes context:(nullable NSStringDrawingContext *)context;
```


## 版本介绍

* 2016. 10. 7 --> 初始版本的创建


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 Issues me 或 kingsic@126.com 邮箱联系我

