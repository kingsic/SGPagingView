//
//  SGPageTitleView.h
//  SGPageViewExample
//
//  Created by apple on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGPageView.git - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import <UIKit/UIKit.h>
@class SGPageTitleView;

typedef enum : NSUInteger {
    SGIndicatorLengthTypeDefault, /// 指示器默认长度与按钮宽度相等
    SGIndicatorLengthTypeEqual, /// 指示器宽度等于按钮文字宽度
    SGIndicatorLengthTypeSpecial /// 当标题内容总长度小于屏幕尺寸时, 指示器样式不想设置 SGIndicatorTypeDefault 或 SGIndicatorTypeEqual 时, 便可使用这种样式，当标题内容总长度大于屏幕尺寸时，不起作用
} SGIndicatorLengthType;

@protocol SGPageTitleViewDelegate <NSObject>
/// delegatePageTitleView
- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex;

@end

@interface SGPageTitleView : UIView
/**
 *  对象方法创建 SGPageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames;
/**
 *  类方法创建 SGPageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 */
+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames;

/** 是否需要弹性效果，默认为 YES */
@property (nonatomic, assign) BOOL isNeedBounces;
/** 普通状态标题文字颜色，默认黑色 */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中状态标题文字颜色，默认红色 */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器颜色，默认红色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 指示器高度，默认是 2 */
@property (nonatomic, assign) CGFloat indicatorHeight;
/** 指示器高度，默认是 2 */
@property (nonatomic, assign) CGFloat indicatorAnimationTime;
/** 选中的按钮下标，默认选中 0 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 指示器长度样式，默认 SGIndicatorLengthTypeDefault */
@property (nonatomic, assign) SGIndicatorLengthType indicatorLengthStyle;
/** 是否让标题有渐变效果，默认为 YES */
@property (nonatomic, assign) BOOL isTitleGradientEffect;
/** 是否开启标题文字缩放效果，默认为 NO */
@property (nonatomic, assign) BOOL isOpenTitleTextZoom;
/** 标题文字缩放比，默认 0.1，取值范围 0 ～ 0.2 */
@property (nonatomic, assign) CGFloat titleTextScaling;
/** 是否显示指示器，默认为 YES */
@property (nonatomic, assign) BOOL isShowIndicator;
/** 是否让指示器滚动，默认为 YES */
@property (nonatomic, assign) BOOL isIndicatorScroll;
/** 是否显示底部分割线，默认为 YES */
@property (nonatomic, assign) BOOL isShowBottomSeparator;

/** 给外界提供的方法，获取 SGContentView 的 progress／originalIndex／targetIndex, 必须实现 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

@end
