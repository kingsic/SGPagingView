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
    SGIndicatorTypeDefault, /// 指示器默认长度与按钮宽度相等
    SGIndicatorTypeEqual, /// 指示器宽度等于按钮文字宽度
} SGIndicatorType;

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


/** 普通状态标题文字颜色，默认黑色 */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中状态标题文字颜色，默认红色 */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器颜色，默认红色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 选中的按钮下标, 如果这个属性和 indicatorStyle 属性同时存在，则此属性在前 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 指示器样式 */
@property (nonatomic, assign) SGIndicatorType indicatorStyle;
/** 是否让标题有渐变效果，默认为 YES */
@property (nonatomic, assign) BOOL isTitleGradientEffect;
/** 是否让指示器滚动，默认为跟随内容的滚动而滚动 */
@property (nonatomic, assign) BOOL isIndicatorScroll;
/** 是否显示指示器，默认为 YES */
@property (nonatomic, assign) BOOL isShowIndicator;
/** 是否需要弹性效果，默认为 YES */
@property (nonatomic, assign) BOOL isNeedBounces;

/** 给外界提供的方法，获取 SGContentView 的 progress／originalIndex／targetIndex, 必须实现 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

@end
