//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  SGPageTitleView.h
//  SGPagingViewExample
//
//  Created by kingsic on 17/4/10.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGPageTitleViewConfigure, SGPageTitleView;

@protocol SGPageTitleViewDelegate <NSObject>
/**
 *  联动 pageContent 的方法
 *
 *  @param pageTitleView      SGPageTitleView
 *  @param selectedIndex      选中按钮的下标
 */
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex;
@end

@interface SGPageTitleView : UIView
/// SGPageTitleView 配置信息
@property (nonatomic, readonly, strong) SGPageTitleViewConfigure *configure;
/**
 *  对象方法创建 SGPageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 *  @param configure        SGPageTitleView 信息配置
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(SGPageTitleViewConfigure *)configure;
/**
 *  类方法创建 SGPageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 *  @param configure        SGPageTitleView 信息配置
 */
+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(SGPageTitleViewConfigure *)configure;

/** SGPageTitleView 是否需要弹性效果，默认为 YES */
@property (nonatomic, assign) BOOL isNeedBounces;
/** 选中标题按钮下标，默认为 0 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 重置选中标题按钮下标（用于子控制器内的点击事件改变标题的选中下标）*/
@property (nonatomic, assign) NSInteger resetSelectedIndex;
/** 是否让标题按钮文字有渐变效果，默认为 YES */
@property (nonatomic, assign) BOOL isTitleGradientEffect;
/** 是否开启标题按钮文字缩放效果，默认为 NO */
@property (nonatomic, assign) BOOL isOpenTitleTextZoom;
/** 标题文字缩放比，默认为 0.1f，取值范围 0 ～ 0.3f */
@property (nonatomic, assign) CGFloat titleTextScaling;
/** 是否显示指示器，默认为 YES */
@property (nonatomic, assign) BOOL isShowIndicator;
/** 是否显示底部分割线，默认为 YES */
@property (nonatomic, assign) BOOL isShowBottomSeparator;

/** 给外界提供的方法，获取 SGPageContentView 的 progress／originalIndex／targetIndex, 必须实现 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

/** 根据下标重置标题文字（index 标题所对应的下标值、title 新的标题名）*/
- (void)resetTitleWithIndex:(NSInteger)index newTitle:(NSString *)title;

@end
